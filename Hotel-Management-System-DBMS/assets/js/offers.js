const offerEscape = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));

function offerBadgeClass(status) {
  return ({Applied:'bg-success',Approved:'bg-primary',Eligible:'bg-info text-dark','Pending Verification':'bg-warning text-dark',Rejected:'bg-danger','Not Eligible':'bg-secondary','Reservation Cancelled':'bg-secondary'})[status] || 'bg-light text-dark border';
}

async function renderGuestOffers() {
  const container = document.getElementById('guestOffersContainer');
  if (!container) return;
  try {
    const data = await HotelDB.getGuestOffersAsync();
    const relevantReservations = data.reservations.filter(reservation =>
      ['Confirmed', 'Booked', 'Checked-in', 'Occupied'].includes(reservation.status))
      .sort((a, b) => Number(b.reservation_id) - Number(a.reservation_id));
    if (!relevantReservations.length) {
      container.innerHTML = '<div class="col-12"><div class="alert alert-light border mb-0">Offers will appear here after you reserve a room.</div></div>';
      return;
    }
    container.innerHTML = relevantReservations.map(reservation => `
      <div class="col-12"><div class="border rounded-4 p-3 p-lg-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3"><div><strong class="text-navy">Room #${offerEscape(reservation.room_number)} &bull; ${offerEscape(reservation.room_type)}</strong><div class="small text-muted">${offerEscape(reservation.check_in)} to ${offerEscape(reservation.check_out)} &bull; ${reservation.nights} nights</div></div><span class="badge ${offerBadgeClass(reservation.status)}">${offerEscape(reservation.status)}</span></div>
        <div class="row g-3">${reservation.offers.map(offer => renderGuestOfferCard(reservation, offer)).join('')}</div>
      </div></div>`).join('');
  } catch (error) {
    container.innerHTML = `<div class="col-12"><div class="alert alert-warning mb-0">${offerEscape(error.message)}</div></div>`;
  }
}

function renderGuestOfferCard(reservation, offer) {
  const claimForm = offer.can_claim ? `
    <form class="mt-3" onsubmit="submitStudentOffer(event,${reservation.reservation_id})">
      <label class="form-label small fw-semibold" for="studentEvidence${reservation.reservation_id}">College/student ID evidence (JPG, PNG, WebP or PDF; up to 5 MB)</label>
      <div class="input-group input-group-sm"><input id="studentEvidence${reservation.reservation_id}" class="form-control" type="file" accept="image/jpeg,image/png,image/webp,application/pdf" required><button class="btn btn-outline-navy">Submit for review</button></div>
    </form>` : '';
  const claimNote = offer.claim_id && offer.status !== 'Available' ? `<div class="small mt-2">${offer.remarks ? `Reception note: ${offerEscape(offer.remarks)}` : ''}${offer.applied_discount > 0 ? `<br>Applied discount: Rs. ${Number(offer.applied_discount).toLocaleString()}` : ''}</div>` : '';
  return `<div class="col-md-6 col-xl-3"><article class="h-100 border rounded-3 p-3"><div class="d-flex justify-content-between align-items-start gap-2"><strong>${offerEscape(offer.offer_name)}</strong><span class="badge ${offerBadgeClass(offer.status)}">${offerEscape(offer.status)}</span></div><div class="text-gold fw-bold my-2">${offer.discount_percent}% off ${offerEscape(offer.applicable_to.toLowerCase())}</div><p class="small text-secondary mb-2">${offerEscape(offer.description)}</p><div class="small text-muted">${offerEscape(offer.eligibility_details)}</div>${claimNote}${claimForm}</article></div>`;
}

async function submitStudentOffer(event, reservationId) {
  event.preventDefault();
  const input = document.getElementById(`studentEvidence${reservationId}`);
  const file = input.files[0];
  const allowed = ['image/jpeg','image/png','image/webp','application/pdf'];
  if (!file || !allowed.includes(file.type) || file.size > 5 * 1024 * 1024) {
    showToast('Choose a JPG, PNG, WebP, or PDF file no larger than 5 MB.', 'Evidence Validation', 'danger');
    return;
  }
  try {
    await HotelDB.submitStudentOfferAsync(reservationId, file);
    showToast('Student ID submitted. The offer will apply only if reception approves it.', 'Offer Submitted', 'success');
    await renderGuestOffers();
  } catch (error) {
    showToast(error.message, 'Offer Submission Error', 'danger');
  }
}

async function renderOfferRedemptions() {
  const body = document.getElementById('offerRedemptionsBody');
  if (!body) return;
  try {
    const [entries, bills] = await Promise.all([HotelDB.getOfferRedemptionsAsync(), HotelDB.getBillsAsync()]);
    const billByReservation = new Map(bills.map(bill => [Number(bill.reservation_id), bill]));
    const visibleEntries = entries.filter(entry => {
      if (entry.offer_code !== 'STUDENT15' || !entry.claim_id || entry.reservation_status === 'Cancelled') return false;
      if (entry.status === 'Pending Verification') return true;
      if (!['Approved', 'Applied'].includes(entry.status)) return false;
      const bill = billByReservation.get(Number(entry.reservation_id));
      return !(entry.reservation_status === 'Checked-out' && bill?.payment_status === 'Paid');
    });
    const pendingEntries = visibleEntries.filter(entry => entry.status === 'Pending Verification');
    const badge = document.getElementById('pendingOfferBadge');
    if (badge) badge.textContent = pendingEntries.length
      ? `${pendingEntries.length} Need Approval${visibleEntries.length > pendingEntries.length ? ` · ${visibleEntries.length - pendingEntries.length} Active` : ''}`
      : `${visibleEntries.length} Active Claims`;
    if (!visibleEntries.length) {
      body.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-3">No offer claims need review or follow-up right now. Automatic offer eligibility is shown on the room cards.</td></tr>';
      return;
    }
    body.innerHTML = visibleEntries.map(renderOfferRedemptionRow).join('');
  } catch (error) {
    body.innerHTML = `<tr><td colspan="5" class="text-center text-danger py-3">${offerEscape(error.message)}</td></tr>`;
  }
}

function renderOfferRedemptionRow(entry) {
  const date = entry.claimed_at ? new Date(entry.claimed_at).toLocaleString() : '';
  const evidence = entry.evidence_available && entry.claim_id ? `<button class="btn btn-sm btn-outline-navy rounded-pill" onclick="viewOfferEvidence(${entry.claim_id})"><i class="fa-solid fa-id-card me-1"></i>View student ID</button>` : '<span class="small text-danger">Evidence missing</span>';
  const canReview = entry.offer_code === 'STUDENT15' && entry.status === 'Pending Verification' && entry.claim_id && entry.reservation_status !== 'Cancelled';
  const review = canReview ? `<input id="offerRemark${entry.claim_id}" class="form-control form-control-sm mb-1" maxlength="1000" placeholder="Optional verification remark"><div class="d-flex gap-1"><button class="btn btn-sm btn-success" onclick="reviewOffer(${entry.claim_id},'Approved')">Approve</button><button class="btn btn-sm btn-outline-danger" onclick="reviewOffer(${entry.claim_id},'Rejected')">Reject</button></div>` : '<span class="small text-muted">—</span>';
  return `<tr><td><strong>Room #${offerEscape(entry.room_number)}</strong><div>${offerEscape(entry.guest_name)}</div><div class="small text-muted">${offerEscape(entry.guest_phone || 'No phone')} · Reservation ${offerEscape(entry.reservation_id)}</div></td><td><strong>${offerEscape(entry.offer_name)}</strong><div class="small text-muted">${entry.discount_percent}% off ${offerEscape(entry.applicable_to.toLowerCase())}</div></td><td><span class="badge ${offerBadgeClass(entry.status)}">${offerEscape(entry.status)}</span></td><td>${evidence}<div class="small text-muted mt-1">${offerEscape(date)}</div>${entry.remarks ? `<div class="small text-muted mt-1">${offerEscape(entry.remarks)}</div>` : ''}</td><td style="min-width:170px">${review}</td></tr>`;
}

async function reviewOffer(claimId, decision) {
  try {
    const remarks = document.getElementById(`offerRemark${claimId}`)?.value.trim() || '';
    await HotelDB.verifyOfferClaimAsync(claimId, decision, remarks);
    showToast(`Student Offer ${decision.toLowerCase()}.`, 'Offer Review Updated', decision === 'Approved' ? 'success' : 'info');
    await renderOfferRedemptions();
    if (typeof renderRoomGrid === 'function') await renderRoomGrid();
  } catch (error) {
    showToast(error.message, 'Offer Review Error', 'danger');
  }
}

async function viewOfferEvidence(claimId) {
  try {
    const response = await fetch(`${API_BASE_URL}/offers/claims/${claimId}/evidence`, {headers: hotelAuthHeaders()});
    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new Error(error.error || 'Could not load evidence.');
    }
    const url = URL.createObjectURL(await response.blob());
    const link = document.createElement('a');
    link.href = url; link.target = '_blank'; link.rel = 'noopener'; link.click();
    setTimeout(() => URL.revokeObjectURL(url), 60000);
  } catch (error) {
    showToast(error.message, 'Evidence Error', 'danger');
  }
}

async function saveOfferRemark(claimId) {
  try {
    const remarks = document.getElementById(`offerNote${claimId}`).value.trim();
    await HotelDB.updateOfferRemarkAsync(claimId, remarks);
    showToast('Offer remark saved.', 'Offer Note Updated', 'success');
    await renderOfferRedemptions();
  } catch (error) {
    showToast(error.message, 'Offer Note Error', 'danger');
  }
}

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('guestOffersContainer')) renderGuestOffers();
  if (document.getElementById('offerRedemptionsBody')) renderOfferRedemptions();
});
