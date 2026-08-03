/* ==========================================================================
   Crowne Plaza Hotel Management System - UI Helpers (Toasts & Invoice Generator)
   ========================================================================== */

function showToast(message, title = 'Notification', type = 'info') {
  let container = document.getElementById('luxuryToastContainer');
  if (!container) {
    container = document.createElement('div');
    container.id = 'luxuryToastContainer';
    container.className = 'toast-container-luxury';
    document.body.appendChild(container);
  }

  const iconMap = {
    success: 'fa-circle-check',
    danger: 'fa-circle-xmark',
    warning: 'fa-bell',
    info: 'fa-circle-info'
  };

  const icon = iconMap[type] || iconMap.info;

  const toast = document.createElement('div');
  toast.className = `toast-luxury toast-${type}`;
  toast.innerHTML = `
    <i class="fa-solid ${icon} toast-luxury-icon"></i>
    <div class="toast-luxury-content">
      <div class="toast-luxury-title">${title}</div>
      <div class="toast-luxury-message">${message}</div>
    </div>
    <button class="toast-luxury-close" onclick="this.parentElement.remove()">&times;</button>
  `;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    toast.style.transition = 'all 0.3s ease';
    setTimeout(() => toast.remove(), 300);
  }, 4500);
}

function generateInvoiceHTML(bookingId) {
  const bookings = HotelDB.getBookings();
  const booking = bookings.find(b => b.id === bookingId);
  if (!booking) return '<div class="alert alert-warning">Invoice record not found.</div>';

  const services = HotelDB.getServices().filter(s => s.roomNumber === booking.roomNumber);
  
  const ci = new Date(booking.checkIn);
  const co = new Date(booking.checkOut);
  const nights = Math.max(1, Math.ceil((co - ci) / (1000 * 60 * 60 * 24)));
  const roomPricePerNight = Math.round(booking.totalAmount / nights);

  let servicesTotal = 0;
  let servicesRows = services.map(s => {
    servicesTotal += s.amount || 0;
    return `
      <tr>
        <td>Service: ${s.serviceName} (${s.time})</td>
        <td class="text-center">1</td>
        <td class="text-end">Rs. ${(s.amount || 0).toLocaleString()}</td>
        <td class="text-end fw-semibold">Rs. ${(s.amount || 0).toLocaleString()}</td>
      </tr>
    `;
  }).join('');

  const subtotal = booking.totalAmount + servicesTotal;
  const gstTax = Math.round(subtotal * 0.18);
  const grandTotal = subtotal + gstTax;

  return `
    <div class="invoice-card" id="printableInvoiceArea">
      <div class="d-flex justify-content-between align-items-center invoice-header-brand">
        <div>
          <h2 class="font-serif text-navy mb-0 fw-bold"><i class="fa-solid fa-crown text-warning me-2"></i>Crowne Plaza Hotel</h2>
          <span class="text-gold small fw-bold tracking-wider">LUXURY SUITES & RESORT &bull; TAX INVOICE</span>
        </div>
        <div class="text-end">
          <h4 class="text-uppercase font-monospace text-muted mb-0">FOLIO #${booking.id}</h4>
          <span class="small text-secondary">Date: ${new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })}</span>
        </div>
      </div>

      <div class="row g-4 mb-4">
        <div class="col-6">
          <span class="text-muted small d-block text-uppercase fw-bold mb-1">Guest Information</span>
          <strong class="text-dark d-block fs-5">${booking.guestName}</strong>
          <span class="text-secondary small d-block">${booking.guestEmail}</span>
          <span class="text-secondary small d-block">${booking.guestPhone}</span>
        </div>
        <div class="col-6 text-end">
          <span class="text-muted small d-block text-uppercase fw-bold mb-1">Stay Details</span>
          <strong class="text-navy d-block">Room #${booking.roomNumber} &bull; ${booking.category}</strong>
          <span class="text-secondary small d-block">Check-In: <strong>${booking.checkIn}</strong></span>
          <span class="text-secondary small d-block">Check-Out: <strong>${booking.checkOut}</strong> (${nights} Nights)</span>
        </div>
      </div>

      <table class="invoice-table mb-3">
        <thead>
          <tr>
            <th>Description</th>
            <th class="text-center">Qty / Nights</th>
            <th class="text-end">Rate</th>
            <th class="text-end">Amount</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Accommodation: ${booking.category} (Room #${booking.roomNumber})</td>
            <td class="text-center">${nights}</td>
            <td class="text-end">Rs. ${roomPricePerNight.toLocaleString()}</td>
            <td class="text-end fw-semibold">Rs. ${booking.totalAmount.toLocaleString()}</td>
          </tr>
          ${servicesRows}
        </tbody>
      </table>

      <div class="row justify-content-end mb-4">
        <div class="col-md-6">
          <div class="p-3 bg-light rounded-3">
            <div class="d-flex justify-content-between mb-1 text-secondary small">
              <span>Subtotal:</span>
              <strong>Rs. ${subtotal.toLocaleString()}</strong>
            </div>
            <div class="d-flex justify-content-between mb-1 text-secondary small">
              <span>GST / Luxury Tax (18%):</span>
              <strong>Rs. ${gstTax.toLocaleString()}</strong>
            </div>
            <hr class="my-2">
            <div class="d-flex justify-content-between fs-5 font-serif fw-bold text-navy">
              <span>Grand Total:</span>
              <span class="text-gold">Rs. ${grandTotal.toLocaleString()}</span>
            </div>
            <div class="text-end text-success small fw-semibold mt-1">
              <i class="fa-solid fa-circle-check me-1"></i> Payment Status: ${booking.paymentStatus || 'Paid'}
            </div>
          </div>
        </div>
      </div>

      <div class="d-flex justify-content-between align-items-end pt-3 border-top text-muted small">
        <div>
          <p class="mb-0">Thank you for staying at Crowne Plaza Hotel.</p>
          <p class="mb-0">For support, contact reception@crowneplaza.com</p>
        </div>
        <div class="text-end">
          <div class="font-serif italic text-secondary mb-1">Arthur Pendelton</div>
          <div class="border-top border-secondary pt-1 fw-bold text-uppercase" style="font-size: 0.65rem;">Authorized Signature</div>
        </div>
      </div>
    </div>
  `;
}

function openInvoiceModal(bookingId) {
  let modalEl = document.getElementById('invoiceModal');
  if (!modalEl) {
    modalEl = document.createElement('div');
    modalEl.id = 'invoiceModal';
    modalEl.className = 'modal fade';
    modalEl.setAttribute('tabindex', '-1');
    modalEl.innerHTML = `
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow-lg">
          <div class="modal-header bg-navy text-white rounded-top-4" style="background: #0b1329;">
            <h5 class="modal-title font-serif text-gold"><i class="fa-solid fa-file-invoice-dollar me-2"></i> Guest Folio Invoice</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body p-4" id="invoiceModalBody">
          </div>
          <div class="modal-footer bg-light rounded-bottom-4">
            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-gold rounded-pill px-4" onclick="window.print()">
              <i class="fa-solid fa-print me-2"></i> Print / Save PDF
            </button>
          </div>
        </div>
      </div>
    `;
    document.body.appendChild(modalEl);
  }

  document.getElementById('invoiceModalBody').innerHTML = generateInvoiceHTML(bookingId);
  const bsModal = new bootstrap.Modal(modalEl);
  bsModal.show();
}
