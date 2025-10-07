import React, { useState, useEffect } from "react";
import { Bed, Users, Wifi, Car, Coffee } from "lucide-react";
import { getRooms } from "../services/api";

const Rooms = () => {
  const [rooms, setRooms] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    loadRooms();
  }, []);

  const loadRooms = async () => {
    try {
      setLoading(true);
      // Temporal: datos mock hasta que el backend esté listo
      const mockRooms = [
        {
          id: 1,
          name: "Habitación Standard",
          description: "Habitación cómoda con todas las comodidades básicas",
          price: 80,
          capacity: 2,
          amenities: ["wifi", "tv", "ac"],
        },
        {
          id: 2,
          name: "Habitación Deluxe",
          description:
            "Habitación espaciosa con vista exterior y amenities premium",
          price: 120,
          capacity: 2,
          amenities: ["wifi", "tv", "ac", "minibar", "safe"],
        },
        {
          id: 3,
          name: "Suite Ejecutiva",
          description: "Suite de lujo con sala de estar separada y jacuzzi",
          price: 200,
          capacity: 4,
          amenities: ["wifi", "tv", "ac", "minibar", "safe", "jacuzzi"],
        },
        {
          id: 4,
          name: "Habitación Familiar",
          description: "Amplia habitación perfecta para familias",
          price: 150,
          capacity: 4,
          amenities: ["wifi", "tv", "ac", "family"],
        },
      ];
      setRooms(mockRooms);
    } catch (err) {
      setError("Error al cargar las habitaciones");
      console.error("Error:", err);
    } finally {
      setLoading(false);
    }
  };

  const getAmenityIcon = (amenity) => {
    switch (amenity) {
      case "wifi":
        return <Wifi size={20} />;
      case "tv":
        return <Bed size={20} />;
      case "ac":
        return <Car size={20} />;
      case "minibar":
        return <Coffee size={20} />;
      default:
        return <Users size={20} />;
    }
  };

  if (loading)
    return (
      <div className="container">
        <div className="loading">Cargando habitaciones...</div>
      </div>
    );
  if (error)
    return (
      <div className="container">
        <div className="error">{error}</div>
      </div>
    );

  return (
    <div className="container">
      <div className="card">
        <h1>Nuestras Habitaciones</h1>
        <p>Selecciona la habitación perfecta para tu estadía</p>

        <div className="room-grid">
          {rooms.map((room) => (
            <div key={room.id} className="room-card">
              <div className="room-image">{room.name}</div>
              <div className="room-content">
                <h3>{room.name}</h3>
                <p>{room.description}</p>
                <div
                  style={{
                    display: "flex",
                    alignItems: "center",
                    margin: "1rem 0",
                  }}
                >
                  <Users size={20} style={{ marginRight: "5px" }} />
                  <span>Máx. {room.capacity} personas</span>
                </div>
                <div className="room-price">${room.price} / noche</div>
                <div style={{ margin: "1rem 0" }}>
                  <h4>Comodidades:</h4>
                  <div
                    style={{
                      display: "flex",
                      gap: "10px",
                      flexWrap: "wrap",
                      marginTop: "0.5rem",
                    }}
                  >
                    {room.amenities.map((amenity, index) => (
                      <div
                        key={index}
                        style={{ display: "flex", alignItems: "center" }}
                      >
                        {getAmenityIcon(amenity)}
                      </div>
                    ))}
                  </div>
                </div>
                <button className="btn" style={{ width: "100%" }}>
                  Reservar Ahora
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Rooms;
