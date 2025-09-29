import React from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Building, Bed, Calendar } from 'lucide-react'

const Header = () => {
  const location = useLocation()

  return (
    <header className="header">
      <div className="container">
        <nav className="navbar">
          <div className="logo">
            <Building size={24} style={{ marginRight: '10px', display: 'inline' }} />
            Hotel Paradise
          </div>
          <ul className="nav-links">
            <li>
              <Link to="/" className={location.pathname === '/' ? 'active' : ''}>
                Inicio
              </Link>
            </li>
            <li>
              <Link to="/habitaciones" className={location.pathname === '/habitaciones' ? 'active' : ''}>
                <Bed size={16} style={{ marginRight: '5px', display: 'inline' }} />
                Habitaciones
              </Link>
            </li>
            <li>
              <Link to="/reservas" className={location.pathname === '/reservas' ? 'active' : ''}>
                <Calendar size={16} style={{ marginRight: '5px', display: 'inline' }} />
                Mis Reservas
              </Link>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  )
}

export default Header