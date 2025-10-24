// Esta función es disparada por eventos SNS cuando se crea una reserva
// Envía un email de confirmación al cliente

const AWS = require("aws-sdk");
const ses = new AWS.SES({ region: process.env.SES_REGION || "us-east-1" });

exports.handler = async (event) => {
  console.log("Evento recibido:", JSON.stringify(event, null, 2));

  try {
    // Parsear evento SNS
    const message = JSON.parse(event.Records[0].Sns.Message);

    const {
      reservationId,
      guestEmail,
      guestName,
      checkIn,
      checkOut,
      roomType,
      totalPrice,
    } = message;

    // Validar datos
    if (!guestEmail || !guestName) {
      throw new Error("Email o nombre del huésped no proporcionados");
    }

    // Preparar parámetros del email
    const params = {
      Source: "noreply@hotel.example.com", // dominio
      Destination: {
        ToAddresses: [guestEmail],
      },
      Message: {
        Subject: {
          Data: `Confirmación de Reserva #${reservationId}`,
          Charset: "UTF-8",
        },
        Body: {
          Html: {
            Data: `
              <html>
                <head></head>
                <body>
                  <h1>¡Reserva Confirmada!</h1>
                  <p>Estimado/a ${guestName},</p>
                  
                  <p>Confirmamos tu reserva en nuestro hotel con los siguientes detalles:</p>
                  
                  <table border="1" cellpadding="10">
                    <tr>
                      <td><strong>Número de Reserva:</strong></td>
                      <td>${reservationId}</td>
                    </tr>
                    <tr>
                      <td><strong>Check-in:</strong></td>
                      <td>${checkIn}</td>
                    </tr>
                    <tr>
                      <td><strong>Check-out:</strong></td>
                      <td>${checkOut}</td>
                    </tr>
                    <tr>
                      <td><strong>Tipo de Habitación:</strong></td>
                      <td>${roomType}</td>
                    </tr>
                    <tr>
                      <td><strong>Precio Total:</strong></td>
                      <td>$${totalPrice}</td>
                    </tr>
                  </table>
                  
                  <p>Esperamos tu llegada. Si necesitas ayuda, contáctanos.</p>
                  
                  <p>Saludos cordiales,<br>Hotel Paradise</p>
                </body>
              </html>
            `,
            Charset: "UTF-8",
          },
        },
      },
    };

    // Enviar email
    const result = await ses.sendEmail(params).promise();

    console.log("Email enviado exitosamente:", result.MessageId);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Email enviado",
        messageId: result.MessageId,
      }),
    };
  } catch (error) {
    console.error("Error enviando email:", error);

    // Re-lanzar error para que SQS lo reintente
    throw error;
  }
};
