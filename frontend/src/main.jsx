import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

//se monta en StrictMode, lo cual ejecuta doble render en dev.
// Esto se hace intencionalmente para detectar efectos secundarios ocultos
// por ejemplo, llamadas a APIs que no están correctamente controladas

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)