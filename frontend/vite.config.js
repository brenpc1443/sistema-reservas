import { defineConfig } from 'vite'  // Importa función para definir configuración de Vite
import react from '@vitejs/plugin-react' // Importa plugin oficial de React para Vite

// https://vitejs.dev/config/    // Referencia a la documentación oficial

export default defineConfig({    // Exporta la configuración de Vite
  plugins: [react()],           // Agrega el plugin de React
  server: {                     // Opciones del servidor de desarrollo
    host: '0.0.0.0',            // Permite acceso desde cualquier dirección IP
    port: 5173,                 // Define el puerto donde corre el servidor
    watch: {                    // Configuración de monitoreo de archivos
      usePolling: true          // Usa polling en vez de watch nativo (útil en Docker/WLS2)
    }
  }
})
