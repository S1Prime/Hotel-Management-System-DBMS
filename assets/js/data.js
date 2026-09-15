/* ==========================================================================
   Crowne Plaza Hotel Management System - Shared API & PostgreSQL Engine
   ========================================================================== */

const API_BASE_URL = 'http://127.0.0.1:5000/api';

const HotelDB = {
  // ------------------------------------------------------------------------
  // 1. ROOMS API INTEGRATION
  // ------------------------------------------------------------------------
  async getRoomsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/rooms`);
      if (res.ok) {
        const dbRooms = await res.json();
        if (dbRooms && dbRooms.length > 0) {
          return dbRooms.map(r => ({
            id: r.room_id,
            number: r.room_number,
            category: r.room_type,
            floor: parseInt(r.room_number[0], 10) || 1,
            price: parseFloat(r.price_per_night),
            status: r.status || 'Available',
            type: r.room_type,
            capacity: r.room_type.includes('Suite') || r.room_type.includes('Family') ? 4 : 2,
            bed: r.room_type.includes('Suite') ? 'King Bed' : 'Double Bed',
            view: 'City & Panorama View',
            amenities: ['Wi-Fi', 'Smart TV', 'Air Conditioning', 'Executive Desk'],
            image: r.room_type.includes('Suite')
              ? 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=80'
              : 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80'
          }));
        }
      }
    } catch (e) {
      console.warn('Backend API offline, using fallback:', e);
    }
    return JSON.parse(localStorage.getItem('cp_rooms') || '[]');
  },

  async addRoomAsync(roomData) {
    try {
      const res = await fetch(`${API_BASE_URL}/rooms`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(roomData)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to add room');
      return data;
    } catch (e) {
      console.error('Error adding room:', e);
      throw e;
    }
  },

  async updateRoomAsync(roomId, roomData) {
    try {
      const res = await fetch(`${API_BASE_URL}/rooms/${roomId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(roomData)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to update room');
      return data;
    } catch (e) {
      console.error('Error updating room:', e);
      throw e;
    }
  },

  async updateRoomStatusAsync(roomNumber, newStatus) {
    try {
      const rooms = await this.getRoomsAsync();
      const target = rooms.find(r => String(r.number) === String(roomNumber));
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
  },

  async deleteRoomAsync(roomId) {
    try {
      const res = await fetch(`${API_BASE_URL}/rooms/${roomId}`, {
        method: 'DELETE'
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to delete room');
      return data;
    } catch (e) {
      console.error('Error deleting room:', e);
      throw e;
    }
  },

  // ------------------------------------------------------------------------
  // 2. RESERVATIONS & BOOKINGS API INTEGRATION
  // ------------------------------------------------------------------------
  async getBookingsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/reservations`);
      if (res.ok) {
        const dbRes = await res.json();
        if (dbRes && dbRes.length > 0) {
          return dbRes.map(b => ({
            id: `RES-${b.reservation_id}`,
            reservationId: b.reservation_id,
            customerId: b.customer_id,
            roomNumber: b.room_number,
            guestName: b.guest_name,
            guestEmail: b.guest_email,
            guestPhone: b.guest_phone,
            checkIn: b.check_in,
            checkOut: b.check_out,
            guestsCount: b.number_of_guests || 1,
            specialRequests: b.special_requests || '',
            category: b.room_type,
            totalAmount: parseFloat(b.estimated_total || 0),
            status: b.status,
            paymentStatus: b.status === 'Checked-out' ? 'Paid' : 'Pending',
            wifiPassword: 'hotelmanagement'
          }));
        }
      }
    } catch (e) {
      console.warn('Backend API reservations offline, falling back:', e);
    }
    return JSON.parse(localStorage.getItem('cp_bookings') || '[]');
  },

  async createBookingAsync(bookingData) {
    try {
      const res = await fetch(`${API_BASE_URL}/reservations`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          customer_id: bookingData.customerId,
          room_number: bookingData.roomNumber,
          guest_name: bookingData.guestName,
          guest_email: bookingData.guestEmail,
          guest_phone: bookingData.guestPhone,
          check_in: bookingData.checkIn,
          check_out: bookingData.checkOut,
          number_of_guests: bookingData.guestsCount || 1,
          special_requests: bookingData.specialRequests || ''
        })
      });
      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || 'Failed to create reservation.');
      }
      return data;
    } catch (e) {
      console.error('Backend API reservation error:', e);
      throw e;
    }
  },

  async checkInBookingAsync(reservationId) {
    try {
      const cleanId = String(reservationId).replace('RES-', '');
      const res = await fetch(`${API_BASE_URL}/reservations/${cleanId}/check-in`, {
        method: 'POST'
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to check in');
      return data;
    } catch (e) {
      console.error('CheckIn API error:', e);
      throw e;
    }
  },

  async checkOutBookingAsync(reservationId) {
    try {
      const cleanId = String(reservationId).replace('RES-', '');
      const res = await fetch(`${API_BASE_URL}/reservations/${cleanId}/check-out`, {
        method: 'POST'
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to check out');
      return data;
    } catch (e) {
      console.error('CheckOut API error:', e);
      throw e;
    }
  },

  // ------------------------------------------------------------------------
  // 3. HOTEL SERVICES & SERVICE REQUESTS API INTEGRATION
  // ------------------------------------------------------------------------
  async getServicesCatalogAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/services`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch services catalog from API:', e);
    }
    return [
      { service_id: 1, service_name: "Gourmet Breakfast in Bed", price: 1200, description: "Fresh continental breakfast" },
      { service_id: 2, service_name: "Express Laundry Service", price: 850, description: "Same-day laundry & pressing" },
      { service_id: 3, service_name: "Luxury Spa & Wellness Package", price: 3500, description: "60-minute relaxing massage" },
      { service_id: 4, service_name: "Extra Rollaway Bed", price: 1500, description: "Twin bed with linens" }
    ];
  },

  async getServiceRequestsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/service-requests`);
      if (res.ok) {
        const list = await res.json();
        return list.map(sr => ({
          id: `SR-${sr.request_id}`,
          requestId: sr.request_id,
          reservationId: sr.reservation_id,
          roomNumber: sr.room_number,
          guestName: sr.guest_name,
          serviceName: sr.service_name,
          quantity: sr.quantity,
          amount: parseFloat(sr.total_price),
          status: sr.status,
          time: new Date(sr.request_date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        }));
      }
    } catch (e) {
      console.warn('Failed to fetch service requests from API:', e);
    }
    return JSON.parse(localStorage.getItem('cp_services') || '[]');
  },

  async addServiceRequestAsync(requestData) {
    try {
      const res = await fetch(`${API_BASE_URL}/service-requests`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          reservation_id: requestData.reservationId,
          service_id: requestData.serviceId,
          quantity: requestData.quantity || 1
        })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to submit service request');
      return data;
    } catch (e) {
      console.error('Service request API error:', e);
      throw e;
    }
  },

  async updateServiceStatusAsync(requestId, newStatus) {
    try {
      const cleanId = String(requestId).replace('SR-', '');
      const res = await fetch(`${API_BASE_URL}/service-requests/${cleanId}/status`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status: newStatus })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to update service status');
      return data;
    } catch (e) {
      console.error('Update service status error:', e);
      throw e;
    }
  },

  // ------------------------------------------------------------------------
  // 4. BILLS & BILLING API INTEGRATION
  // ------------------------------------------------------------------------
  async getBillsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/bills`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch bills from API:', e);
    }
    return [];
  },

  async payBillAsync(billId) {
    try {
      const res = await fetch(`${API_BASE_URL}/bills/${billId}/pay`, {
        method: 'PUT'
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to process bill payment');
      return data;
    } catch (e) {
      console.error('Pay bill API error:', e);
      throw e;
    }
  },

  // ------------------------------------------------------------------------
  // 5. HOUSEKEEPING TASKS API INTEGRATION
  // ------------------------------------------------------------------------
  async getHousekeepingAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/housekeeping`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch housekeeping tasks from API:', e);
    }
    return [];
  },

  async updateHousekeepingStatusAsync(taskId, newStatus) {
    try {
      const res = await fetch(`${API_BASE_URL}/housekeeping/${taskId}/status`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status: newStatus })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to update housekeeping task');
      return data;
    } catch (e) {
      console.error('Housekeeping update error:', e);
      throw e;
    }
  },

  // ------------------------------------------------------------------------
  // 6. REPORTS & METRICS API INTEGRATION
  // ------------------------------------------------------------------------
  async getReportsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/reports`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch reports from API:', e);
    }
    return {
      metrics: { totalRooms: 5, occupiedRooms: 2, availableRooms: 2, cleaningRooms: 1, maintenanceRooms: 0, totalRevenue: 32760 },
      revenueByRoomType: []
    };
  },

  async getMetricsAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/metrics`);
      if (res.ok) {
        const m = await res.json();
        const reports = await this.getReportsAsync();
        return {
          totalRooms: m.totalRooms,
          occupied: m.occupied,
          available: m.available,
          cleaning: m.cleaning,
          maintenance: m.maintenance,
          activeBookingsCount: m.activeBookingsCount,
          totalRevenue: reports.metrics ? reports.metrics.totalRevenue : 0
        };
      }
    } catch (e) {
      console.warn('Backend metrics API error:', e);
    }
    return { totalRooms: 5, occupied: 2, available: 2, cleaning: 1, maintenance: 0, activeBookingsCount: 2, totalRevenue: 0 };
  },

  // ------------------------------------------------------------------------
  // 7. DEDICATED ADMIN API INTEGRATIONS
  // ------------------------------------------------------------------------
  async getAdminCustomersAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/admin/customers`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch admin customer list:', e);
    }
    return [];
  },

  async getCustomerHistoryAsync(customerId) {
    try {
      const res = await fetch(`${API_BASE_URL}/admin/customers/${customerId}/history`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch customer history:', e);
    }
    return { customer: null, reservations: [] };
  },

  async getAdminStaffAsync() {
    try {
      const res = await fetch(`${API_BASE_URL}/admin/staff`);
      if (res.ok) return await res.json();
    } catch (e) {
      console.warn('Failed to fetch staff accounts:', e);
    }
    return [];
  },

  async addStaffAsync(staffData) {
    try {
      const res = await fetch(`${API_BASE_URL}/admin/staff`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(staffData)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to add staff account');
      return data;
    } catch (e) {
      console.error('Error adding staff:', e);
      throw e;
    }
  },

  async updateStaffAsync(staffId, staffData) {
    try {
      const res = await fetch(`${API_BASE_URL}/admin/staff/${staffId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(staffData)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to update staff account');
      return data;
    } catch (e) {
      console.error('Error updating staff:', e);
      throw e;
    }
  },

  async addServiceAsync(serviceData) {
    try {
      const res = await fetch(`${API_BASE_URL}/services`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(serviceData)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to add service');
      return data;
    } catch (e) {
      console.error('Error adding service:', e);
      throw e;
    }
  },

  async updateServiceAsync(serviceId, serviceData) {
    try {
      const res = await fetch(`${API_BASE_URL}/admin/services/${serviceId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(serviceData)
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to update service');
      return data;
    } catch (e) {
      console.error('Error updating service:', e);
      throw e;
    }
  }
};
