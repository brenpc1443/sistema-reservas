import React from "react";
import { Link } from "react-router-dom";
import { Star, Wifi, Car, Utensils } from "lucide-react";

const Home = () => {
  return (
    <div>
      <section className="hero">
        <div className="container">
          <h1>Bienvenido a Hotel Paradise</h1>
          <p>
            Descubre el confort y la excelencia en nuestro hotel de lujo.
            Reserva tu estadía perfecta hoy mismo.
          </p>
          <Link to="/habitaciones">
            <button className="btn" style={{ marginTop: "2rem" }}>
              Ver Habitaciones Disponibles
            </button>
          </Link>
        </div>
      </section>

      <div className="container">
        <section className="card">
          <h2>¿Por qué elegirnos?</h2>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))",
              gap: "2rem",
              marginTop: "2rem",
            }}
          >
            <div style={{ textAlign: "center" }}>
              <Star color="#FFD700" size={48} />
              <h3>Calidad 5 Estrellas</h3>
              <p>Servicio de primera clase con estándares internacionales</p>
            </div>
            <div style={{ textAlign: "center" }}>
              <Wifi color="#667eea" size={48} />
              <h3>WiFi Gratuito</h3>
              <p>Conexión de alta velocidad en todas las áreas</p>
            </div>
            <div style={{ textAlign: "center" }}>
              <Car color="#28a745" size={48} />
              <h3>Estacionamiento</h3>
              <p>Estacionamiento seguro y gratuito para huéspedes</p>
            </div>
            <div style={{ textAlign: "center" }}>
              <Utensils color="#dc3545" size={48} />
              <h3>Restaurante</h3>
              <p>Gastronomía excepcional con chefs internacionales</p>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};

export default Home;
