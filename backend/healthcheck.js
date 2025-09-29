// backend/healthcheck.js
// Este script realiza un chequeo de salud (health check) a un servicio backend
// verificando que responda correctamente en el puerto 3000 y en la ruta /health.
// Si el servicio responde con un código 200, el proceso termina con éxito (exit 0),
// de lo contrario termina con error (exit 1).
const http = require('http');  // Importa el módulo HTTP nativo de Node.js
// Opciones de la solicitud HTTP que se va a enviar al backend
const options = {
  host: 'localhost',  // Dirección del servidor a verificar (en este caso local)
  port: 3000,         // Puerto donde corre el backend
  path: '/health',    // Ruta que expone el estado de salud del servicio
  timeout: 2000       // Tiempo máximo de espera en milisegundos (2 segundos)
};

const request = http.request(options, (res) => {
  console.log(`STATUS: ${res.statusCode}`);     // Muestra en consola el código de respuesta
  // Si la respuesta es 200 (OK), el proceso finaliza con éxito
  if (res.statusCode === 200) {
    process.exit(0);
  } else {
    // Cualquier otro código de estado se considera error
    process.exit(1);
  }
});
// Manejo de errores en caso de que el servidor no responda o haya fallas de red
request.on('error', (err) => {
  console.log('ERROR', err);  // Muestra el error en consola
  process.exit(1);            // Finaliza el proceso indicando fallo 
});
// Finaliza y envía la solicitud HTTP
request.end();
