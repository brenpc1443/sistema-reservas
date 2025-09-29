import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api'

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
})

// Interceptor para manejar errores globalmente
api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error)
    throw error
  }
)

export const getRooms = async () => {
  const response = await api.get('/rooms')
  return response.data
}

export const createReservation = async (reservationData) => {
  const response = await api.post('/reservations', reservationData)
  return response.data
}

export const getReservations = async () => {
  const response = await api.get('/reservations')
  return response.data
}

export default api