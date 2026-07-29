/* ==========================================================================
   Crowne Plaza Hotel Management System - Shared Local Database & State Engine
   ========================================================================== */

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
  },
  {
    id: "BK-1002",
    roomNumber: "201",
    guestName: "Marcus Sterling",
    guestEmail: "marcus@sterling.com",
    guestPhone: "+1 (555) 876-5432",
    checkIn: "2026-07-27",
    checkOut: "2026-07-31",
    guestsCount: 3,
    category: "AC Room with Balcony",
    totalAmount: 18000,
    status: "Occupied",
    paymentStatus: "Paid",
    wifiPassword: "hotelmanagement",
    createdAt: "2026-07-26"
  },
  {
    id: "BK-1003",
    roomNumber: "102",
    guestName: "Sophia Loren",
    guestEmail: "sophia@loren.com",
    guestPhone: "+1 (555) 998-1122",
    checkIn: "2026-07-29",
    checkOut: "2026-08-03",
    guestsCount: 2,
    category: "Standard AC Room",
    totalAmount: 17500,
    status: "Occupied",
    paymentStatus: "Pending Desk",
    wifiPassword: "hotelmanagement",
    createdAt: "2026-07-28"
  }
];

const INITIAL_SERVICES = [
  { id: "SR-501", roomNumber: "101", guestName: "Eleanor Vance", serviceName: "Gourmet Breakfast in Bed", type: "Dining", amount: 1200, status: "Pending", time: "08:30 AM" },
  { id: "SR-502", roomNumber: "201", guestName: "Marcus Sterling", serviceName: "Extra Feather Pillows & Linens", type: "Housekeeping", amount: 0, status: "Completed", time: "10:15 AM" },
  { id: "SR-503", roomNumber: "101", guestName: "Eleanor Vance", serviceName: "Luxury Spa Aromatherapy Massage", type: "Spa", amount: 3500, status: "Completed", time: "02:00 PM" }
];

// Initialize Database in localStorage
function initDatabase() {
  const existingBookings = localStorage.getItem('cp_bookings');
  const existingRooms = localStorage.getItem('cp_rooms');
  
  // Reset database if it's missing the Wi-Fi property OR has old room counts (more than 5 rooms)
  const needsReset = !existingBookings || 
                     !JSON.parse(existingBookings)[0]?.hasOwnProperty('wifiPassword') ||
                     (existingRooms && JSON.parse(existingRooms).length > 5);

  if (needsReset) {
    localStorage.setItem('cp_rooms', JSON.stringify(INITIAL_ROOMS));
    localStorage.setItem('cp_bookings', JSON.stringify(INITIAL_BOOKINGS));
    localStorage.setItem('cp_services', JSON.stringify(INITIAL_SERVICES));
  } else {
    if (!localStorage.getItem('cp_rooms')) {
      localStorage.setItem('cp_rooms', JSON.stringify(INITIAL_ROOMS));
    }
    if (!localStorage.getItem('cp_services')) {
      localStorage.setItem('cp_services', JSON.stringify(INITIAL_SERVICES));
    }
  }
}

initDatabase();

// Data Engine API
const HotelDB = {
  getRooms() {
    return JSON.parse(localStorage.getItem('cp_rooms') || '[]');
  },

  saveRooms(rooms) {
    localStorage.setItem('cp_rooms', JSON.stringify(rooms));
  },

  updateRoomStatus(roomNumber, newStatus) {
    const rooms = this.getRooms();
    const room = rooms.find(r => r.number === String(roomNumber));
    if (room) {
      room.status = newStatus;
      this.saveRooms(rooms);
    }
  },

  getBookings() {
    return JSON.parse(localStorage.getItem('cp_bookings') || '[]');
  },

  saveBookings(bookings) {
    localStorage.setItem('cp_bookings', JSON.stringify(bookings));
  },

  findActiveBookingByRoom(roomNumber) {
    const bookings = this.getBookings();
    return bookings.find(b => String(b.roomNumber) === String(roomNumber) && b.status === 'Occupied');
  },

  updateWifiPassword(bookingId, newPassword) {
    const bookings = this.getBookings();
    const booking = bookings.find(b => b.id === bookingId);
    if (booking) {
      booking.wifiPassword = newPassword;
      this.saveBookings(bookings);
      return true;
    }
    return false;
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

    // Automatically update room status to Occupied
    if (bookingData.roomNumber) {
      this.updateRoomStatus(bookingData.roomNumber, 'Occupied');
    }
    return newBooking;
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

  cancelBooking(bookingId) {
    const bookings = this.getBookings();
    const booking = bookings.find(b => b.id === bookingId);
    if (booking) {
      booking.status = 'Cancelled';
      this.saveBookings(bookings);
      if (booking.roomNumber) {
        this.updateRoomStatus(booking.roomNumber, 'Available');
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

  getMetrics() {
    const rooms = this.getRooms();
    const bookings = this.getBookings();
    const services = this.getServices();

    const occupied = rooms.filter(r => r.status === 'Occupied').length;
    const available = rooms.filter(r => r.status === 'Available').length;
    const cleaning = rooms.filter(r => r.status === 'Cleaning').length;
    const maintenance = rooms.filter(r => r.status === 'Maintenance').length;

    const activeBookings = bookings.filter(b => b.status === 'Occupied');
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
