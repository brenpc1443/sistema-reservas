// lambda/invoice-generator/index.js
// Esta función es disparada por SQS cuando se procesa un pago
// Genera una factura en PDF y la almacena en S3

const AWS = require("aws-sdk");
const db = require("./db-connection");
const pdfGenerator = require("./pdf-generator");

const s3 = new AWS.S3();

exports.handler = async (event) => {
  console.log("Evento SQS recibido:", JSON.stringify(event, null, 2));

  try {
    // Procesar registros del batch SQS
    const promises = event.Records.map((record) => procesarPago(record));

    const results = await Promise.allSettled(promises);

    // Log de resultados
    results.forEach((result, idx) => {
      if (result.status === "fulfilled") {
        console.log(`Registro ${idx}: Factura generada exitosamente`);
      } else {
        console.error(`Registro ${idx}: Error -`, result.reason);
      }
    });

    return {
      batchItemFailures: results
        .map((result, idx) => (result.status === "rejected" ? idx : null))
        .filter((idx) => idx !== null)
        .map((idx) => ({ itemId: event.Records[idx].messageId })),
    };
  } catch (error) {
    console.error("Error procesando batch:", error);
    throw error;
  }
};

async function procesarPago(record) {
  const { body } = record;
  const paymentData = JSON.parse(body);

  const {
    paymentId,
    reservationId,
    amount,
    guestEmail,
    guestName,
    checkIn,
    checkOut,
    roomType,
  } = paymentData;

  console.log(`Procesando pago ${paymentId} para reserva ${reservationId}`);

  try {
    // Obtener detalles adicionales de la base de datos
    const paymentDetails = await db.query(
      "SELECT * FROM payments WHERE id = $1",
      [paymentId]
    );

    if (!paymentDetails.rows.length) {
      throw new Error(`Pago no encontrado: ${paymentId}`);
    }

    // Generar PDF
    const pdfBuffer = await pdfGenerator.generate({
      reservationId,
      paymentId,
      guestName,
      checkIn,
      checkOut,
      roomType,
      amount,
      timestamp: new Date().toISOString(),
    });

    // Guardar en S3
    const s3Key = `invoices/${reservationId}/${paymentId}.pdf`;
    await s3
      .putObject({
        Bucket: process.env.INVOICES_BUCKET,
        Key: s3Key,
        Body: pdfBuffer,
        ContentType: "application/pdf",
        Metadata: {
          "reservation-id": reservationId,
          "payment-id": paymentId,
        },
      })
      .promise();

    console.log(`Factura guardada en S3: ${s3Key}`);

    // Actualizar estado en base de datos
    await db.query(
      "UPDATE payments SET invoice_generated = true, invoice_url = $1 WHERE id = $2",
      [`s3://${process.env.INVOICES_BUCKET}/${s3Key}`, paymentId]
    );

    return {
      paymentId,
      reservationId,
      success: true,
      invoiceUrl: s3Key,
    };
  } catch (error) {
    console.error(`Error procesando pago ${paymentId}:`, error);
    throw error;
  }
}
