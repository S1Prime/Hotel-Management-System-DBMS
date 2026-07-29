/* ==========================================================================
   Crowne Plaza Hotel Management System - Shared Local Database & State Engine
   ========================================================================== */

const INITIAL_ROOMS = [
  { id: 101, number: "101", category: "Crowne Executive Suite", floor: 1, price: 250, status: "Occupied", type: "Suite", capacity: 2, bed: "King Bed", view: "City Skyline", amenities: ["Wi-Fi", "Minibar", "Jacuzzi", "Smart TV", "City View"], image: "https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=80" },
  { id: 102, number: "102", category: "Crowne Deluxe King", floor: 1, price: 180, status: "Available", type: "Deluxe", capacity: 2, bed: "King Bed", view: "Garden View", amenities: ["Wi-Fi", "Coffee Maker", "Smart TV", "Balcony"], image: "https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80" },
  { id: 103, number: "103", category: "Crowne Twin Deluxe", floor: 1, price: 160, status: "Cleaning", type: "Deluxe", capacity: 3, bed: "2 Twin Beds", view: "Courtyard View", amenities: ["Wi-Fi", "Work Desk", "Mini Fridge"], image: "https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80" },
  { id: 104, number: "104", category: "Crowne Executive Suite", floor: 1, price: 250, status: "Available", type: "Suite", capacity: 2, bed: "King Bed", view: "City Skyline", amenities: ["Wi-Fi", "Minibar", "Jacuzzi", "Balcony"], image: "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80" },
  { id: 201, number: "201", category: "Ocean View Luxury Suite", floor: 2, price: 320, status: "Occupied", type: "Suite", capacity: 4, bed: "King Bed + Sofa Bed", view: "Ocean View", amenities: ["Wi-Fi", "Private Balcony", "Ocean Panorama", "Espresso Bar"], image: "https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=800&q=80" },
  { id: 202, number: "202", category: "Crowne Deluxe King", floor: 2, price: 180, status: "Maintenance", type: "Deluxe", capacity: 2, bed: "King Bed", view: "Garden View", amenities: ["Wi-Fi", "Coffee Maker", "Smart TV"], image: "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80" },
  { id: 203, number: "203", category: "Crowne Family Suite", floor: 2, price: 290, status: "Available", type: "Suite", capacity: 4, bed: "2 Queen Beds", view: "Pool View", amenities: ["Wi-Fi", "Kitchenette", "Living Area", "2 Smart TVs"], image: "https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=800&q=80" },
  { id: 204, number: "204", category: "Crowne Deluxe King", floor: 2, price: 180, status: "Occupied", type: "Deluxe", capacity: 2, bed: "King Bed", view: "City Skyline", amenities: ["Wi-Fi", "Coffee Maker", "Smart TV"], image: "https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=800&q=80" },
  { id: 301, number: "301", category: "Presidential Royal Penthouse", floor: 3, price: 650, status: "Available", type: "Penthouse", capacity: 4, bed: "Super King Bed", view: "Panoromic Ocean & City", amenities: ["Private Pool", "Personal Butler", "Full Kitchen", "Private Elevator", "Helipad Access"], image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80" },
  { id: 302, number: "302", category: "Ocean View Luxury Suite", floor: 3, price: 320, status: "Cleaning", type: "Suite", capacity: 3, bed: "King Bed", view: "Ocean View", amenities: ["Wi-Fi", "Private Balcony", "Ocean Panorama"], image: "https://images.unsplash.com/photo-1595576508898-0ad5c879a061?auto=format&fit=crop&w=800&q=80" },
  { id: 401, number: "401", category: "Crowne Executive Suite", floor: 4, price: 260, status: "Available", type: "Suite", capacity: 2, bed: "King Bed", view: "High Skyline", amenities: ["Wi-Fi", "Executive Lounge Access", "Jacuzzi"], image: "https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80" }
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
    category: "Crowne Executive Suite",
    totalAmount: 1250,
    status: "Occupied",
    paymentStatus: "Paid",
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
    category: "Ocean View Luxury Suite",
    totalAmount: 1280,
    status: "Occupied",
    paymentStatus: "Paid",
    createdAt: "2026-07-26"
  },
  {
    id: "BK-1003",
    roomNumber: "204",
    guestName: "Sophia Loren",
    guestEmail: "sophia@loren.com",
    guestPhone: "+1 (555) 998-1122",
    checkIn: "2026-07-29",
    checkOut: "2026-08-03",
    guestsCount: 2,
    category: "Crowne Deluxe King",
    totalAmount: 900,
    status: "Occupied",
    paymentStatus: "Pending Desk",
    createdAt: "2026-07-28"
  }
];

const INITIAL_SERVICES = [
  { id: "SR-501", roomNumber: "101", guestName: "Eleanor Vance", serviceName: "Gourmet Breakfast in Bed", type: "Dining", amount: 45, status: "Pending", time: "08:30 AM" },
  { id: "SR-502", roomNumber: "201", guestName: "Marcus Sterling", serviceName: "Extra Feather Pillows & Linens", type: "Housekeeping", amount: 0, status: "Completed", time: "10:15 AM" },
  { id: "SR-503", roomNumber: "101", guestName: "Eleanor Vance", serviceName: "Luxury Spa Aromatherapy Massage", type: "Spa", amount: 120, status: "Completed", time: "02:00 PM" }
];

// Initialize Database in localStorage
function initDatabase() {
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

  createBooking(bookingData) {
    const bookings = this.getBookings();
    const newBooking = {
      id: 'BK-' + (1000 + bookings.length + 1),
      status: 'Occupied',
      paymentStatus: bookingData.paymentStatus || 'Paid',
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
