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

function invoiceEscape(value) {
  return String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
}

function generateInvoiceHTML(bookingId, bill = null, bookingOverride = null, folio = null) {
  const bookings = bookingOverride ? [bookingOverride] : HotelDB.getBookings();
  const booking = bookings.find(b => b.id === bookingId || String(b.reservationId) === String(bookingId).replace('RES-', ''));
  if (!booking) return '<div class="alert alert-warning">Invoice record not found.</div>';

  const services = HotelDB.getServices().filter(s => s.roomNumber === booking.roomNumber);
  
  const ci = new Date(booking.checkIn);
  const co = new Date(booking.checkOut);
  const nights = Math.max(1, Math.ceil((co - ci) / (1000 * 60 * 60 * 24)));
  const billedRoomCharge = bill ? Number(bill.room_charge) : booking.totalAmount;
  const roomPricePerNight = Math.round(billedRoomCharge / nights);

  let servicesTotal = bill ? Number(bill.service_charge) : 0;
  const additionalTotal = bill ? Number(bill.additional_charge || 0) : Number(folio?.totals?.additional_charge || 0);
  let servicesRows = folio ? [
    ...folio.food_orders.map(item => `<tr><td>Food: ${invoiceEscape(item.service_name)} <span class="text-muted">(${invoiceEscape(item.cuisine)})</span>${item.status !== 'Completed' ? ` <span class="badge bg-light text-dark">${invoiceEscape(item.status)} · not billed</span>` : ''}</td><td class="text-center">${item.quantity}</td><td class="text-end">Rs. ${Number(item.unit_price).toLocaleString()}</td><td class="text-end fw-semibold">Rs. ${item.status === 'Completed' ? Number(item.total_price).toLocaleString() : '0'}</td></tr>`),
    ...folio.other_services.map(item => `<tr><td>Service: ${invoiceEscape(item.service_name)}${item.status !== 'Completed' ? ` <span class="badge bg-light text-dark">${invoiceEscape(item.status)} · not billed</span>` : ''}</td><td class="text-center">${item.quantity}</td><td class="text-end">Rs. ${Number(item.unit_price).toLocaleString()}</td><td class="text-end fw-semibold">Rs. ${item.status === 'Completed' ? Number(item.total_price).toLocaleString() : '0'}</td></tr>`),
    ...folio.additional_expenses.map(item => `<tr><td>Additional: ${invoiceEscape(item.expense_type)} — ${invoiceEscape(item.description)}</td><td class="text-center">${item.quantity}</td><td class="text-end">Rs. ${Number(item.unit_price).toLocaleString()}</td><td class="text-end fw-semibold">Rs. ${Number(item.total_amount).toLocaleString()}</td></tr>`)
  ].join('') : bill ? (() => {
    const foodTotal = Number(bill.food_charge || 0);
    const otherServices = Math.max(0, servicesTotal - foodTotal);
    return `${foodTotal ? `<tr><td>Food charges</td><td class="text-center">—</td><td class="text-end">—</td><td class="text-end fw-semibold">Rs. ${foodTotal.toLocaleString()}</td></tr>` : ''}${otherServices ? `<tr><td>Other completed services</td><td class="text-center">—</td><td class="text-end">—</td><td class="text-end fw-semibold">Rs. ${otherServices.toLocaleString()}</td></tr>` : ''}${additionalTotal ? `<tr><td>Additional expenses</td><td class="text-center">—</td><td class="text-end">—</td><td class="text-end fw-semibold">Rs. ${additionalTotal.toLocaleString()}</td></tr>` : ''}`;
  })() : services.map(s => {
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

  if (folio) servicesTotal = Number(folio.totals.food_charge) + Number(folio.totals.other_service_charge);
  const subtotal = billedRoomCharge + servicesTotal + additionalTotal;
  const offerDiscount = folio ? Number(folio.totals.discount) : bill ? Number(bill.discount || 0) : 0;
  const gstTax = folio ? Number(folio.totals.tax) : bill ? Number(bill.tax) : Math.round(subtotal * 0.18);
  const grandTotal = folio ? Number(folio.totals.total_amount) : bill ? Number(bill.total_amount) : subtotal + gstTax;
  const offerDiscountRows = folio ? folio.offers.map(offer => `
    <div class="d-flex justify-content-between mb-1 text-${['Approved','Applied'].includes(offer.status) ? 'success' : 'secondary'} small">
      <span>${invoiceEscape(offer.offer_name)} (${Number(offer.discount_percent)}% · ${invoiceEscape(offer.status)})${offer.eligibility_details ? ` — ${invoiceEscape(offer.eligibility_details)}` : ''}</span>
      <strong>${offer.status === 'Applied' && Number(offer.applied_discount) > 0 ? `- Rs. ${Number(offer.applied_discount).toLocaleString()}` : offer.status === 'Approved' ? 'Approved · reflected in eligible total' : 'Not applied'}</strong>
    </div>`).join('') : bill ? (bill.offer_discounts || []).map(offer => `
    <div class="d-flex justify-content-between mb-1 text-success small">
      <span>${offer.offer_name} (${offer.discount_percent}% of ${offer.applicable_to === 'Room Charges' ? 'room charges' : 'eligible food charges'}: Rs. ${Number(offer.applied_charge).toLocaleString()}):</span>
      <strong>- Rs. ${Number(offer.applied_discount).toLocaleString()}</strong>
    </div>`).join('') : '';

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
            <td class="text-end fw-semibold">Rs. ${billedRoomCharge.toLocaleString()}</td>
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
            ${offerDiscount > 0 ? `<div class="d-flex justify-content-between mb-1 text-success small"><strong>Special offer discounts:</strong><strong>- Rs. ${offerDiscount.toLocaleString()}</strong></div>${offerDiscountRows}` : ''}
            <div class="d-flex justify-content-between mb-1 text-secondary small">
              <span>${bill ? 'Tax (5%):' : 'GST / Luxury Tax (18%):'}</span>
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

async function openInvoiceModal(bookingId) {
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

  let bookings = [];
  let bills = [];
  let folio = null;
  try {
    [bookings, bills] = await Promise.all([HotelDB.getBookingsAsync(), HotelDB.getBillsAsync()]);
  } catch (e) {
    console.warn('Could not load the saved invoice details:', e);
  }
  const reservationId = String(bookingId).replace('RES-', '');
  const booking = bookings.find(item => item.id === bookingId || String(item.reservationId) === reservationId) || null;
  const bill = bills.find(item => String(item.reservation_id) === reservationId) || null;
  try { folio = await HotelDB.getReservationFolioAsync(reservationId); }
  catch (e) { console.warn('Could not load reservation expense lines:', e); }
  document.getElementById('invoiceModalBody').innerHTML = generateInvoiceHTML(bookingId, bill, booking, folio);
  const bsModal = new bootstrap.Modal(modalEl);
  bsModal.show();
}
