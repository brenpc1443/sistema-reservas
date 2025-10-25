// backend/server.js
const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");
const aws = require("aws-sdk");
require("dotenv").config();

const app = express();
const port = process.env.PORT || 3000;

// ============================================================
// MIDDLEWARE
// ============================================================
app.use(cors());
app.use(express.json());

// ============================================================
// DATABASE CONNECTION
// ============================================================
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

// Test database connection
pool.query("SELECT NOW()", (err, res) => {
  if (err) {
    console.error("Database connection failed:", err);
  } else {
    console.log("Database connected successfully");
  }
});

// ============================================================
// AWS SERVICES
// ============================================================
const sqs = new aws.SQS({ region: "us-east-1" });
const sns = new aws.SNS({ region: "us-east-1" });

// ============================================================
// ROUTES - HEALTH CHECK
// ============================================================
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok", timestamp: new Date() });
});

// ============================================================
// ROUTES - ROOMS (Habitaciones)
// ============================================================
app.get("/api/rooms", async (req, res) => {
  try {
    const query = `
      SELECT 
        rt.id,
        rt.name,
        rt.description,
        rt.base_price,
        rt.max_guests,
        rt.amenities,
        COUNT(r.id) as total_rooms,
        COALESCE(COUNT(CASE WHEN r.status = 'available' THEN 1 END), 0) as available_rooms
      FROM room_types rt
      LEFT JOIN rooms r ON rt.id = r.room_type_id
      WHERE rt.is_active = true
      GROUP BY rt.id, rt.name, rt.description, rt.base_price, rt.max_guests, rt.amenities
      ORDER BY rt.base_price
    `;
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (error) {
    console.error("Error fetching rooms:", error);
    res.status(500).json({ error: "Failed to fetch rooms" });
  }
});

// ============================================================
// ROUTES - RESERVATIONS (Reservas)
// ============================================================
app.post("/api/reservations", async (req, res) => {
  const client = await pool.connect();
  try {
    const {
      guest_name,
      guest_email,
      guest_phone,
      room_type_id,
      check_in,
      check_out,
      number_of_guests,
      special_requests,
    } = req.body;

    // Validaciones
    if (
      !guest_name ||
      !guest_email ||
      !room_type_id ||
      !check_in ||
      !check_out
    ) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    await client.query("BEGIN");

    // 1. Crear o obtener guest
    const guestResult = await client.query(
      "SELECT id FROM guests WHERE email = $1",
      [guest_email]
    );

    let guestId;
    if (guestResult.rows.length > 0) {
      guestId = guestResult.rows[0].id;
    } else {
      const newGuestResult = await client.query(
        "INSERT INTO guests (full_name, email, phone) VALUES ($1, $2, $3) RETURNING id",
        [guest_name, guest_email, guest_phone]
      );
      guestId = newGuestResult.rows[0].id;
    }

    // 2. Obtener room disponible del tipo solicitado
    const roomResult = await client.query(
      `SELECT r.id FROM rooms r
       WHERE r.room_type_id = $1 AND r.status = 'available'
       LIMIT 1`,
      [room_type_id]
    );

    if (roomResult.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ error: "No available rooms of this type" });
    }

    const roomId = roomResult.rows[0].id;

    // 3. Obtener precio
    const priceResult = await client.query(
      "SELECT base_price FROM room_types WHERE id = $1",
      [room_type_id]
    );
    const basePrice = priceResult.rows[0].base_price;

    // Calcular días y precio total
    const checkInDate = new Date(check_in);
    const checkOutDate = new Date(check_out);
    const days = Math.ceil(
      (checkOutDate - checkInDate) / (1000 * 60 * 60 * 24)
    );
    const totalPrice = basePrice * days;

    // 4. Crear reserva
    const reservationResult = await client.query(
      `INSERT INTO reservations 
       (guest_id, room_id, check_in, check_out, number_of_guests, total_price, special_requests, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, 'pending')
       RETURNING id, created_at`,
      [
        guestId,
        roomId,
        check_in,
        check_out,
        number_of_guests,
        totalPrice,
        special_requests,
      ]
    );

    const reservationId = reservationResult.rows[0].id;

    // 5. Actualizar estado de room
    await client.query("UPDATE rooms SET status = $1 WHERE id = $2", [
      "occupied",
      roomId,
    ]);

    await client.query("COMMIT");

    // 6. Publicar evento en SNS
    const snsMessage = {
      reservationId,
      guestName: guest_name,
      guestEmail: guest_email,
      checkIn: check_in,
      checkOut: check_out,
      roomType: room_type_id,
      totalPrice,
      timestamp: new Date().toISOString(),
    };

    await sns
      .publish({
        TopicArn: process.env.SNS_NUEVA_RESERVA,
        Message: JSON.stringify(snsMessage),
        Subject: `Nueva Reserva #${reservationId}`,
      })
      .promise();

    res.status(201).json({
      id: reservationId,
      message: "Reservation created successfully",
      totalPrice,
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error creating reservation:", error);
    res.status(500).json({ error: "Failed to create reservation" });
  } finally {
    client.release();
  }
});

app.get("/api/reservations/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      `SELECT 
        r.id, r.check_in, r.check_out, r.status, r.total_price,
        g.full_name, g.email,
        rt.name as room_type
       FROM reservations r
       LEFT JOIN guests g ON r.guest_id = g.id
       LEFT JOIN rooms rm ON r.room_id = rm.id
       LEFT JOIN room_types rt ON rm.room_type_id = rt.id
       WHERE r.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Reservation not found" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error fetching reservation:", error);
    res.status(500).json({ error: "Failed to fetch reservation" });
  }
});

// ============================================================
// ROUTES - PAYMENTS (Pagos)
// ============================================================
app.post("/api/payments", async (req, res) => {
  try {
    const { reservation_id, payment_method, amount } = req.body;

    if (!reservation_id || !payment_method || !amount) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    // Crear pago
    const paymentResult = await pool.query(
      `INSERT INTO payments 
       (reservation_id, amount, payment_method, payment_status, payment_date)
       VALUES ($1, $2, $3, 'completed', NOW())
       RETURNING id, payment_status`,
      [reservation_id, amount, payment_method]
    );

    const paymentId = paymentResult.rows[0].id;

    // Actualizar estado de reserva
    await pool.query("UPDATE reservations SET status = $1 WHERE id = $2", [
      "confirmed",
      reservation_id,
    ]);

    // Publicar evento en SNS
    const snsMessage = {
      paymentId,
      reservationId: reservation_id,
      amount,
      paymentMethod: payment_method,
      timestamp: new Date().toISOString(),
    };

    await sns
      .publish({
        TopicArn: process.env.SNS_PAGO_COMPLETADO,
        Message: JSON.stringify(snsMessage),
        Subject: `Pago Completado #${paymentId}`,
      })
      .promise();

    // Enviar a SQS para factura
    await sqs
      .sendMessage({
        QueueUrl: process.env.SQS_PAGOS_URL,
        MessageBody: JSON.stringify(snsMessage),
      })
      .promise();

    res.status(201).json({
      id: paymentId,
      message: "Payment processed successfully",
    });
  } catch (error) {
    console.error("Error processing payment:", error);
    res.status(500).json({ error: "Failed to process payment" });
  }
});

// ============================================================
// ERROR HANDLING
// ============================================================
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Internal server error" });
});

// ============================================================
// START SERVER
// ============================================================
app.listen(port, () => {
  console.log(`Backend server running on port ${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || "development"}`);
});
