/**
 * Crowne Plaza Hotel Management System - Lost & Found Frontend Engine
 * Handles guest report submission, image encoding, real-time API syncing, and staff management.
 */

const API_BASE = 'http://127.0.0.1:5000/api';

document.addEventListener('DOMContentLoaded', async () => {
  initUserSession();
  setupFormHandler();
  await loadLostAndFoundReports();
});

function showAlert(message, type = 'success') {
  const alertEl = document.getElementById('lfAlert');
  if (!alertEl) return;
  alertEl.className = `alert alert-${type} shadow-sm rounded-3`;
  alertEl.innerHTML = `<i class="fa-solid fa-${type === 'success' ? 'circle-check' : 'triangle-exclamation'} me-2"></i> ${message}`;
  alertEl.classList.remove('d-none');
  setTimeout(() => {
    alertEl.classList.add('d-none');
  }, 6000);
}

function initUserSession() {
  const user = getCurrentUser();
  const userNameEl = document.getElementById('lfUserName');
  const backLinkEl = document.getElementById('lfBackLink');
  const createPanelEl = document.getElementById('lfCreatePanel');
  const lostAtInput = document.getElementById('lfLostAt');

  // Set default datetime to now
  if (lostAtInput && !lostAtInput.value) {
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    lostAtInput.value = now.toISOString().slice(0, 16);
  }

  if (user) {
    const roleCapitalized = (user.role || 'Guest').charAt(0).toUpperCase() + (user.role || 'Guest').slice(1);
    if (userNameEl) {
      userNameEl.innerHTML = `<i class="fa-solid fa-user-circle me-1"></i> ${user.name || user.email} <span class="badge bg-gold text-dark ms-1">${roleCapitalized}</span>`;
    }

    const role = (user.role || '').toLowerCase();
    if (['receptionist', 'admin', 'staff'].includes(role)) {
      if (backLinkEl) {
        backLinkEl.href = role === 'admin' ? 'admin.html' : 'reception-dashboard.html';
        backLinkEl.textContent = role === 'admin' ? 'Back to Admin Center' : 'Back to Front Desk';
      }
      // Staff can also submit reports on behalf of guests
      if (createPanelEl) createPanelEl.classList.remove('d-none');
    } else {
      // Customer
      if (backLinkEl) {
        backLinkEl.href = 'customer-dashboard.html';
        backLinkEl.textContent = 'Back to Guest Dashboard';
      }
      if (createPanelEl) createPanelEl.classList.remove('d-none');
    }
  } else {
    if (userNameEl) userNameEl.textContent = 'Guest (Not Logged In)';
    if (backLinkEl) backLinkEl.href = 'customer-login.html';
    // Allow non-logged in guests or prompt login
    if (createPanelEl) createPanelEl.classList.remove('d-none');
  }
}

function setupFormHandler() {
  const form = document.getElementById('lfCreateForm');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const user = getCurrentUser();

    const item = document.getElementById('lfItem').value.trim();
    const location = document.getElementById('lfLocation').value.trim();
    const lostAt = document.getElementById('lfLostAt').value;
    const description = document.getElementById('lfDescription').value.trim();
    const imageInput = document.getElementById('lfImage');

    let base64Image = null;
    if (imageInput && imageInput.files && imageInput.files[0]) {
      const file = imageInput.files[0];
      if (file.size > 5 * 1024 * 1024) {
        showAlert('Photo size exceeds 5 MB limit. Please select a smaller image.', 'danger');
        return;
      }
      base64Image = await fileToBase64(file);
    }

    const payload = {
      customer_id: user?.id || null,
      item_name: item,
      category: 'Personal Belonging',
      location: location,
      lost_date: lostAt,
      description: description,
      image_url: base64Image,
      reporter_name: user?.name || 'Valued Guest',
      reporter_email: user?.email || 'customer@gmail.com',
      reporter_phone: user?.phone || '9876543210'
    };

    try {
      const res = await fetch(`${API_BASE}/lost-and-found`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      const data = await res.json();

      if (res.ok) {
        showAlert(`Report #${data.report_id || ''} for "${item}" submitted successfully! Front desk has been alerted.`, 'success');
        form.reset();
        initUserSession();
        await loadLostAndFoundReports();
      } else {
        showAlert(data.error || 'Failed to submit report. Please try again.', 'danger');
      }
    } catch (err) {
      console.error(err);
      showAlert('Network error: Unable to connect to backend server. Make sure Flask is running.', 'danger');
    }
  });
}

function fileToBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = (error) => reject(error);
  });
}

const pendingStatusUpdates = new Set();

function getStatusBadgeConfig(status) {
  let badgeClass = 'bg-warning text-dark';
  let icon = 'fa-triangle-exclamation';
  if (status === 'Found (Not Yet Received)' || status === 'Found - Not Yet Received') { badgeClass = 'bg-warning text-dark'; icon = 'fa-clock-rotate-left'; }
  else if (status === 'Found') { badgeClass = 'bg-primary text-white'; icon = 'fa-magnifying-glass-location'; }
  else if (status === 'Returned') { badgeClass = 'bg-success text-white'; icon = 'fa-hand-holding-heart'; }
  else if (status === 'Claimed') { badgeClass = 'bg-success text-white'; icon = 'fa-circle-check'; }
  else if (status === 'Investigating') { badgeClass = 'bg-info text-dark'; icon = 'fa-clock'; }
  else if (status === 'Closed') { badgeClass = 'bg-secondary text-white'; icon = 'fa-lock'; }
  else if (status === 'Pending') { badgeClass = 'bg-danger text-white'; icon = 'fa-hourglass-half'; }
  else if (status === 'Discarded') { badgeClass = 'bg-dark text-white'; icon = 'fa-trash'; }
  return { badgeClass, icon };
}

async function loadLostAndFoundReports() {
  const container = document.getElementById('lfReports');
  if (!container) return;

  try {
    const res = await fetch(`${API_BASE}/lost-and-found`);
    const data = await res.json();
    const reports = data.reports || [];

    if (reports.length === 0) {
      container.innerHTML = `
        <div class="col-12">
          <div class="card p-5 text-center border-0 rounded-4 shadow-sm bg-white">
            <i class="fa-solid fa-box-open text-muted fs-1 mb-3"></i>
            <h4 class="font-serif text-dark mb-1">No Lost Items Reported</h4>
            <p class="text-muted small mb-0">All items are accounted for or resolved. New guest reports will appear here.</p>
          </div>
        </div>
      `;
      return;
    }

    const user = getCurrentUser();
    const isStaff = user && ['receptionist', 'admin', 'staff'].includes((user.role || '').toLowerCase());

    container.innerHTML = reports.map(r => {
      const cfg = getStatusBadgeConfig(r.status);
      const dateStr = r.lost_date ? new Date(r.lost_date).toLocaleString() : 'N/A';
      const createdStr = r.created_at ? new Date(r.created_at).toLocaleDateString() : '';

      return `
        <div class="col-md-6 col-lg-4" id="lfCard_${r.report_id}">
          <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden bg-white d-flex flex-column justify-content-between">
            <div>
              ${r.image_url ? `
                <div style="height: 180px; overflow: hidden; background: #0f172a;" class="position-relative">
                  <img src="${r.image_url}" alt="${r.item_name}" style="width: 100%; height: 100%; object-fit: cover;">
                  <span id="lfBadge_${r.report_id}" class="badge ${cfg.badgeClass} position-absolute top-0 end-0 m-3 shadow-sm px-3 py-2 rounded-pill">
                    <i class="fa-solid ${cfg.icon} me-1"></i> <span>${r.status}</span>
                  </span>
                </div>
              ` : `
                <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center">
                  <span class="text-muted small"><i class="fa-solid fa-tag text-gold me-1"></i> ${r.category || 'Belonging'}</span>
                  <span id="lfBadge_${r.report_id}" class="badge ${cfg.badgeClass} px-3 py-1.5 rounded-pill shadow-sm">
                    <i class="fa-solid ${cfg.icon} me-1"></i> <span>${r.status}</span>
                  </span>
                </div>
              `}

              <div class="p-4">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <h4 class="font-serif fs-5 text-dark mb-0">${r.item_name}</h4>
                  <span class="text-muted small">#LF-${r.report_id}</span>
                </div>
                
                <p class="text-secondary small mb-2"><i class="fa-solid fa-location-dot text-danger me-1"></i> <strong>Lost at:</strong> ${r.location_lost}</p>
                <p class="text-secondary small mb-2"><i class="fa-solid fa-calendar-day text-primary me-1"></i> <strong>Date:</strong> ${dateStr}</p>
                
                <p class="text-muted small p-2 bg-light rounded-3 mb-3 border">
                  ${r.description}
                </p>

                <div class="pt-2 border-top">
                  <div class="d-flex justify-content-between align-items-center text-muted small">
                    <span><i class="fa-solid fa-user me-1 text-gold"></i> ${r.reporter_name}</span>
                    <span><i class="fa-solid fa-envelope me-1"></i> ${r.reporter_email}</span>
                  </div>
                  ${r.staff_notes ? `
                    <div class="mt-2 text-info small bg-info bg-opacity-10 p-2 rounded border border-info border-opacity-25">
                      <strong><i class="fa-solid fa-comment-dots me-1"></i> Staff Note:</strong> ${r.staff_notes}
                    </div>
                  ` : ''}
                </div>
              </div>
            </div>

            ${isStaff ? `
              <div class="p-3 bg-light border-top d-flex gap-2">
                <div class="dropdown flex-grow-1" id="dropdownWrap_${r.report_id}">
                  <button id="btnStatus_${r.report_id}" class="btn btn-sm btn-outline-navy w-100 rounded-pill dropdown-toggle py-1.5" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-pen-to-square me-1"></i> Update Status
                  </button>
                  <ul class="dropdown-menu dropdown-menu-end shadow">
                    <li><a class="dropdown-item ${r.status === 'Reported' ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Reported')"><i class="fa-solid fa-triangle-exclamation text-warning me-2"></i>Reported</a></li>
                    <li><a class="dropdown-item ${r.status === 'Investigating' ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Investigating')"><i class="fa-solid fa-clock text-info me-2"></i>Investigating</a></li>
                    <li><a class="dropdown-item ${(r.status === 'Found (Not Yet Received)' || r.status === 'Found - Not Yet Received') ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Found (Not Yet Received)')"><i class="fa-solid fa-clock-rotate-left text-warning me-2"></i>Found (Not Yet Received)</a></li>
                    <li><a class="dropdown-item ${r.status === 'Found' ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Found')"><i class="fa-solid fa-magnifying-glass-location text-primary me-2"></i>Found (Item in Custody)</a></li>
                    <li><a class="dropdown-item ${r.status === 'Returned' ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Returned')"><i class="fa-solid fa-hand-holding-heart text-success me-2"></i>Returned (Returned to Owner)</a></li>
                    <li><a class="dropdown-item ${r.status === 'Claimed' ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Claimed')"><i class="fa-solid fa-circle-check text-success me-2"></i>Claimed (Owner Verified)</a></li>
                    <li><a class="dropdown-item ${r.status === 'Closed' ? 'active' : ''}" href="javascript:void(0)" onclick="updateStatusPrompt(${r.report_id}, 'Closed')"><i class="fa-solid fa-lock text-secondary me-2"></i>Closed</a></li>
                  </ul>
                </div>
              </div>
            ` : ''}
          </div>
        </div>
      `;
    }).join('');

  } catch (err) {
    console.error(err);
    container.innerHTML = `
      <div class="col-12">
        <div class="alert alert-danger">
          Failed to load reports. Please ensure backend server is running.
        </div>
      </div>
    `;
  }
}

async function updateStatusPrompt(reportId, newStatus, customNotes) {
  if (pendingStatusUpdates.has(reportId)) return;
  pendingStatusUpdates.add(reportId);

  const btn = document.getElementById(`btnStatus_${reportId}`);
  const badgeEl = document.getElementById(`lfBadge_${reportId}`);
  const prevBtnHtml = btn ? btn.innerHTML : '';
  const prevBadgeHtml = badgeEl ? badgeEl.innerHTML : '';
  const prevBadgeClass = badgeEl ? badgeEl.className : '';

  // 1. Display saving / loading state
  if (btn) {
    btn.disabled = true;
    btn.innerHTML = `<i class="fa-solid fa-spinner fa-spin me-1"></i> Saving...`;
  }

  const user = getCurrentUser();
  const staffId = user?.staffId || user?.staff_id || 1;
  const userRole = user?.role || 'Receptionist';
  const notes = (customNotes !== undefined && customNotes !== null)
    ? customNotes
    : `Status updated to ${newStatus} by ${user?.name || 'Reception Staff'}.`;

  try {
    // 2. Send selected status to existing Flask API (PUT /api/lost-and-found/<id>)
    const res = await fetch(`${API_BASE}/lost-and-found/${reportId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'X-User-Role': userRole,
        'X-Staff-Id': String(staffId)
      },
      body: JSON.stringify({
        status: newStatus,
        staff_id: staffId,
        role: userRole,
        notes: notes
      })
    });

    const data = await res.json().catch(() => ({}));

    if (res.ok) {
      // 3. Show success alert
      showAlert(`Report #${reportId} status updated to "${newStatus}" successfully!`, 'success');

      // 4. Update the item's visible status badge immediately after success
      if (badgeEl) {
        const cfg = getStatusBadgeConfig(newStatus);
        const isAbsolute = prevBadgeClass.includes('position-absolute');
        badgeEl.className = isAbsolute
          ? `badge ${cfg.badgeClass} position-absolute top-0 end-0 m-3 shadow-sm px-3 py-2 rounded-pill`
          : `badge ${cfg.badgeClass} px-3 py-1.5 rounded-pill shadow-sm`;
        badgeEl.innerHTML = `<i class="fa-solid ${cfg.icon} me-1"></i> <span>${newStatus}</span>`;
      }

      // 5. Refresh / reload item data so saved status remains correct
      await loadLostAndFoundReports();
    } else {
      // 6. Meaningful error message & restore previous status if save fails
      showAlert(data.error || `Failed to update status for Report #${reportId}.`, 'danger');
      if (badgeEl) {
        badgeEl.className = prevBadgeClass;
        badgeEl.innerHTML = prevBadgeHtml;
      }
      if (btn) {
        btn.disabled = false;
        btn.innerHTML = prevBtnHtml;
      }
    }
  } catch (err) {
    console.error(err);
    showAlert('Network error while updating status. Please verify the Flask backend is running.', 'danger');
    if (badgeEl) {
      badgeEl.className = prevBadgeClass;
      badgeEl.innerHTML = prevBadgeHtml;
    }
    if (btn) {
      btn.disabled = false;
      btn.innerHTML = prevBtnHtml;
    }
  } finally {
    pendingStatusUpdates.delete(reportId);
    if (btn) {
      btn.disabled = false;
    }
  }
}
