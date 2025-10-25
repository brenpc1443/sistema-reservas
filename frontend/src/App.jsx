import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Header from "./components/Header";
import Home from "./pages/Home";
import Rooms from "./pages/Rooms";
import Reservations from "./pages/Reservations";
import "./index.css";

function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <Header />
        <main className="main-content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/habitaciones" element={<Rooms />} />
            <Route path="/reservas" element={<Reservations />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </main>
        <footer className="footer">
          <p>&copy; 2024 Hotel Paradise. Todos los derechos reservados.</p>
        </footer>
      </div>
    </BrowserRouter>
  );
}

function NotFound() {
  return (
    <div className="container">
      <div className="card" style={{ textAlign: "center", padding: "4rem" }}>
        <h1>404 - Página no encontrada</h1>
        <p>Lo sentimos, la página que buscas no existe.</p>
      </div>
    </div>
  );
}

export default App;
