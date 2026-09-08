/* ==========================================================================
   Crowne Plaza Hotel Management System - Shared API & PostgreSQL Engine
   ========================================================================== */

const API_BASE_URL = 'http://127.0.0.1:5000/api';

const INITIAL_ROOMS = [
  { id: 101, number: "101", category: "Luxury Suite", floor: 1, price: 6000, status: "Occupied", type: "Suite", capacity: 2, bed: "King Bed", view: "City Skyline", amenities: ["Wi-Fi", "Minibar", "Jacuzzi", "Smart TV", "City View"], image: "https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=80" },
  { id: 102, number: "102", category: "Standard AC Room", floor: 1, price: 3500, status: "Available", type: "AC", capacity: 2, bed: "King Bed", view: "Garden View", amenities: ["Wi-Fi", "Coffee Maker", "Smart TV", "Balcony"], image: "https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80" },
  { id: 103, number: "103", category: "Economy Non-AC Room", floor: 1, price: 2000, status: "Cleaning", type: "Non-AC", capacity: 2, bed: "2 Twin Beds", view: "Courtyard View", amenities: ["Wi-Fi", "Work Desk", "Mini Fridge"], image: "https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80" },
  { id: 201, number: "201", category: "AC Room with Balcony", floor: 2, price: 4500, status: "Occupied", type: "AC with Balcony", capacity: 4, bed: "King Bed + Sofa Bed", view: "Ocean View", amenities: ["Wi-Fi", "Private Balcony", "Ocean Panorama", "Espresso Bar"], image: "https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=800&q=80" },
  { id: 202, number: "202", category: "Family AC Room", floor: 2, price: 4000, status: "Available", type: "AC Family", capacity: 4, bed: "2 Double Beds", view: "Garden View", amenities: ["Wi-Fi", "Mini Fridge", "Smart TV"], image: "https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=800&q=80" }
];

const INITIAL_BOOKINGS = [
  {
    id: "BK-1001",
    roomNumber: "101",
    guestName: "Eleanor Vance",
    guestEmail: "guest@crowneplaza.com",
    guestPhone: "+1 (555) 234-5678",
    checkIn: "2026-07-28",
    checkOut: "2026-08-02",
    guestsCount: 2,
    category: "Luxury Suite",
    totalAmount: 30000,
    status: "Occupied",
    paymentStatus: "Paid",
    wifiPassword: "hotelmanagement",
    createdAt: "2026-07-25"
  }
];

const INITIAL_SERVICES = [
  { id: "SR-501", roomNumber: "101", guestName: "Eleanor Vance", serviceName: "Gourmet Breakfast in Bed", type: "Dining", amount: 1200, status: "Pending", time: "08:30 AM" }
];

function initLocalStorageFallback() {
  if (!localStorage.getItem('cp_rooms')) {
    localStorage.setItem('cp_rooms', JSON.stringify(INITIAL_ROOMS));
  }
  if (!localStorage.getItem('cp_bookings')) {
    localStorage.setItem('cp_bookings', JSON.stringify(INITIAL_BOOKINGS));
  }
  if (!localStorage.getItem('cp_services')) {
    localStorage.setItem('cp_services', JSON.stringify(INITIAL_SERVICES));
  }
}
initLocalStorageFallback();

// Unified Data Engine interacting with PostgreSQL Backend API
const HotelDB = {
  // 1. Fetch Rooms from PostgreSQL API
  async getRoomsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/rooms`);
      if (res.ok) {
        const dbRooms = await res.json();
        if (dbRooms && dbRooms.length > 0) {
          // Format DB rooms to match frontend template expectations
          return dbRooms.map(r => ({
            id: r.room_id,
            number: r.room_number,
            category: r.room_type.includes('Room') || r.room_type.includes('Suite') ? r.room_type : `${r.room_type} Room`,
            floor: parseInt(r.room_number[0], 10) || 1,
            price: parseFloat(r.price_per_night),
            status: r.status || 'Available',
            type: r.room_type,
            capacity: r.room_type.includes('Suite') || r.room_type.includes('Double') ? 4 : 2,
            bed: r.room_type.includes('Suite') ? 'King Bed' : 'Double Bed',
            view: 'City & Sea Panorama',
            amenities: ['Wi-Fi', 'Smart TV', 'Air Conditioning', 'Executive Desk'],
            image: r.room_type.includes('Suite')
              ? 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=80'
              : 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80'
          }));
        }
      }
    } catch (e) {
      console.warn('Backend API offline, falling back to client cache:', e);
    }
    return JSON.parse(localStorage.getItem('cp_rooms') || '[]');
  },

  getRooms() {
    return JSON.parse(localStorage.getItem('cp_rooms') || '[]');
  },

  saveRooms(rooms) {
    localStorage.setItem('cp_rooms', JSON.stringify(rooms));
  },

  async updateRoomStatusAsync(roomNumber, newStatus) {
    try {
      const rooms = await this.getRoomsAsync();
      const target = rooms.find(r => r.number === String(roomNumber));
      if (target && target.id) {
        await fetch(`${API_BASE_URL}/rooms/${target.id}/status`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ status: newStatus })
        });
      }
    } catch (e) {
      console.warn('Room status update API error:', e);
    }
    this.updateRoomStatus(roomNumber, newStatus);
  },

  updateRoomStatus(roomNumber, newStatus) {
    const rooms = this.getRooms();
    const room = rooms.find(r => r.number === String(roomNumber));
    if (room) {
      room.status = newStatus;
      this.saveRooms(rooms);
    }
  },

  // 2. Fetch Bookings/Reservations from PostgreSQL API
  async getBookingsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/reservations`);
      if (res.ok) {
        const dbRes = await res.json();
        if (dbRes && dbRes.length > 0) {
          return dbRes.map(b => ({
            id: `RES-${b.reservation_id}`,
            reservationId: b.reservation_id,
            roomNumber: b.room_number,
            guestName: b.guest_name,
            guestEmail: b.guest_email,
            guestPhone: b.guest_phone,
            checkIn: b.check_in,
            checkOut: b.check_out,
            guestsCount: 2,
            category: b.room_type,
            totalAmount: parseFloat(b.price_per_night) * 3,
            status: b.status === 'Booked' ? 'Occupied' : b.status,
            paymentStatus: 'Paid',
            wifiPassword: 'hotelmanagement'
          }));
        }
      }
    } catch (e) {
      console.warn('Backend API offline, falling back to client bookings:', e);
    }
    return JSON.parse(localStorage.getItem('cp_bookings') || '[]');
  },

  getBookings() {
    return JSON.parse(localStorage.getItem('cp_bookings') || '[]');
  },

  saveBookings(bookings) {
    localStorage.setItem('cp_bookings', JSON.stringify(bookings));
  },

  findActiveBookingByRoom(roomNumber) {
    const bookings = this.getBookings();
    return bookings.find(b => String(b.roomNumber) === String(roomNumber) && (b.status === 'Occupied' || b.status === 'Booked'));
  },

  // 3. Create Reservation in PostgreSQL API
  async createBookingAsync(bookingData) {
    try {
      const res = await fetch(`${API_BASE_URL}/reservations`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          room_number: bookingData.roomNumber,
          guest_name: bookingData.guestName,
          guest_email: bookingData.guestEmail,
          guest_phone: bookingData.guestPhone,
          check_in: bookingData.checkIn,
          check_out: bookingData.checkOut
        })
      });
      if (res.ok) {
        console.log('Reservation created in PostgreSQL!');
      }
    } catch (e) {
      console.warn('Backend API reservation error:', e);
    }
    return this.createBooking(bookingData);
  },

  createBooking(bookingData) {
    const bookings = this.getBookings();
    const newBooking = {
      id: 'BK-' + (1000 + bookings.length + 1),
      status: 'Occupied',
      paymentStatus: bookingData.paymentStatus || 'Paid',
      wifiPassword: 'hotelmanagement',
      createdAt: new Date().toISOString().split('T')[0],
      ...bookingData
    };
    bookings.unshift(newBooking);
    this.saveBookings(bookings);

    if (bookingData.roomNumber) {
      this.updateRoomStatus(bookingData.roomNumber, 'Occupied');
    }
    return newBooking;
  },

  async checkOutBookingAsync(bookingId) {
    if (String(bookingId).startsWith('RES-')) {
      const dbId = bookingId.replace('RES-', '');
      try {
        await fetch(`${API_BASE_URL}/reservations/${dbId}/status`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ status: 'Completed' })
        });
      } catch (e) {
        console.warn('CheckOut API error:', e);
      }
    }
    this.checkOutBooking(bookingId);
  },

  checkOutBooking(bookingId) {
    const bookings = this.getBookings();
    const booking = bookings.find(b => b.id === bookingId);
    if (booking) {
      booking.status = 'Completed';
      this.saveBookings(bookings);
      if (booking.roomNumber) {
        this.updateRoomStatus(booking.roomNumber, 'Cleaning');
      }
    }
  },

  getServices() {
    return JSON.parse(localStorage.getItem('cp_services') || '[]');
  },

  saveServices(services) {
    localStorage.setItem('cp_services', JSON.stringify(services));
  },

  addServiceRequest(request) {
    const services = this.getServices();
    const newReq = {
      id: 'SR-' + (500 + services.length + 1),
      status: 'Pending',
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      ...request
    };
    services.unshift(newReq);
    this.saveServices(services);
    return newReq;
  },

  updateServiceStatus(serviceId, newStatus) {
    const services = this.getServices();
    const service = services.find(s => s.id === serviceId);
    if (service) {
      service.status = newStatus;
      this.saveServices(services);
    }
  },

  // 4. Fetch Metrics from PostgreSQL API
  async getMetricsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/metrics`);
      if (res.ok) {
        const m = await res.json();
        return {
          totalRooms: m.totalRooms,
          occupied: m.occupied,
          available: m.available,
          cleaning: m.cleaning,
          maintenance: m.maintenance,
          activeBookingsCount: m.activeBookingsCount,
          pendingServicesCount: this.getServices().filter(s => s.status === 'Pending').length,
          totalRevenue: m.occupied * 5000
        };
      }
    } catch (e) {
      console.warn('Backend metrics API error:', e);
    }
    return this.getMetrics();
  },

  getMetrics() {
    const rooms = this.getRooms();
    const bookings = this.getBookings();
    const services = this.getServices();

    const occupied = rooms.filter(r => r.status === 'Occupied').length;
    const available = rooms.filter(r => r.status === 'Available').length;
    const cleaning = rooms.filter(r => r.status === 'Cleaning').length;
    const maintenance = rooms.filter(r => r.status === 'Maintenance').length;

    const activeBookings = bookings.filter(b => b.status === 'Occupied' || b.status === 'Booked');
    const totalRevenue = activeBookings.reduce((sum, b) => sum + (b.totalAmount || 0), 0) +
      services.reduce((sum, s) => sum + (s.amount || 0), 0);

    return {
      totalRooms: rooms.length,
      occupied,
      available,
      cleaning,
      maintenance,
      activeBookingsCount: activeBookings.length,
      pendingServicesCount: services.filter(s => s.status === 'Pending').length,
      totalRevenue
    };
  }
};
