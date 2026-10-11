const LF_API = 'http://127.0.0.1:5000/api/lost-found';
const lfUser = getCurrentUser();
const lfRole = (lfUser?.role || '').toLowerCase();
checkAuth(lfRole === 'customer' ? 'customer' : 'receptionist');

const lfEsc = value => String(value ?? '').replace(/[&<>"']/g, ch => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[ch]));
const lfToken = () => lfUser?.authToken || '';
const lfStaff = ['receptionist', 'admin'].includes(lfRole);

document.getElementById('lfBackLink').href = lfStaff ? (lfRole === 'admin' ? 'admin.html' : 'reception-dashboard.html') : 'customer-dashboard.html';
if (!lfStaff) document.getElementById('lfCreatePanel').classList.remove('d-none');
if (lfToken()) loadLostFound();
else showLfAlert('Please log in again from the email and password login page to use Lost & Found.', 'warning');

function showLfAlert(message, kind = 'success') {
  const box = document.getElementById('lfAlert');
  box.className = `alert alert-${kind}`;
  box.textContent = message;
  box.classList.remove('d-none');
}

async function lfRequest(url, options = {}) {
  const headers = new Headers(options.headers || {});
  headers.set('Authorization', `Bearer ${lfToken()}`);
  const response = await fetch(url, {...options, headers});
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(data.error || 'The request could not be completed.');
  return data;
}

async function loadLostFound() {
  const container = document.getElementById('lfReports');
  container.innerHTML = '<div class="col-12 text-muted">Loading reports...</div>';
  try {
    const reports = await lfRequest(LF_API);
    if (!reports.length) {
      container.innerHTML = '<div class="col-12"><div class="card p-4 border-0 shadow-sm rounded-4 text-center text-muted">No Lost &amp; Found reports yet.</div></div>';
      return;
    }
    container.innerHTML = reports.map(renderLfReport).join('');
  } catch (error) {
    container.innerHTML = '';
    showLfAlert(error.message, 'danger');
  }
}

function renderLfReport(report) {
  const image = report.image_path ? `<img src="http://127.0.0.1:5000${lfEsc(report.image_path)}" class="img-fluid rounded-3 mb-3" alt="Photo of ${lfEsc(report.item_name)}" style="max-height:260px;object-fit:contain;width:100%;background:#f1f3f5">` : '';
  const updates = (report.updates || []).map(update => `<div class="border-start border-2 border-warning ps-3 py-1 mb-2"><div class="small text-muted">${lfEsc(update.actor_role)} &bull; ${lfEsc(new Date(update.created_at).toLocaleString())}${update.status ? ` &bull; ${lfEsc(update.status)}` : ''}</div><div>${lfEsc(update.message)}</div></div>`).join('') || '<div class="small text-muted">No further updates.</div>';
  const ownerActions = !lfStaff && report.is_mine ? `<button class="btn btn-sm btn-outline-navy rounded-pill" onclick="editLfReport(${report.report_id})"><i class="fa-solid fa-pen me-1"></i>Edit details</button><form class="lf-update-form mt-3" onsubmit="submitLfUpdate(event,${report.report_id})"><label class="form-label-custom" for="lfMsg${report.report_id}">Add an update</label><div class="input-group"><input id="lfMsg${report.report_id}" class="form-control" maxlength="2000" required placeholder="Add a helpful detail..."><button class="btn btn-outline-navy">Post</button></div></form>` : '';
  const staffActions = lfStaff ? `<form class="lf-update-form mt-3" onsubmit="submitLfUpdate(event,${report.report_id})"><label class="form-label-custom" for="lfMsg${report.report_id}">Front desk update</label><div class="row g-2"><div class="col-md-8"><input id="lfMsg${report.report_id}" class="form-control" maxlength="2000" required placeholder="Add a remark or progress update..."></div><div class="col-md-4"><select id="lfStatus${report.report_id}" class="form-select"><option value="">Keep ${lfEsc(report.status)}</option><option>Lost</option><option>Found</option><option>Returned</option><option>Closed</option></select></div><div class="col-12"><button class="btn btn-sm btn-outline-navy rounded-pill px-3">Save Update</button></div></div></form>` : '';
  return `<div class="col-12 col-xl-6"><article class="card p-4 border-0 shadow-sm rounded-4 bg-white h-100">${image}<div class="d-flex justify-content-between align-items-start gap-2 mb-2"><h2 class="font-serif fs-4 mb-0">${lfEsc(report.item_name)}</h2><span class="badge ${lfEsc(statusClass(report.status))} rounded-pill">${lfEsc(report.status)}</span></div><p class="text-secondary mb-2">${lfEsc(report.description)}</p><div class="small text-muted mb-3"><div><i class="fa-solid fa-location-dot me-2"></i>${lfEsc(report.lost_location)}</div><div><i class="fa-regular fa-clock me-2"></i>${lfEsc(new Date(report.lost_at).toLocaleString())}</div></div>${report.remarks ? `<div class="alert alert-light py-2"><strong>Latest remark:</strong> ${lfEsc(report.remarks)}</div>` : ''}<details class="mb-2"><summary class="fw-semibold text-navy">Updates</summary><div class="mt-3">${updates}</div></details>${ownerActions}${staffActions}<div class="small text-muted border-top mt-3 pt-2">Report #${report.report_id} &bull; Updated ${lfEsc(new Date(report.updated_at).toLocaleString())}</div></article></div>`;
}

function statusClass(status) {
  return ({Lost:'bg-danger',Found:'bg-warning text-dark',Returned:'bg-success',Closed:'bg-secondary'})[status] || 'bg-secondary';
}

function lfFormData() {
  const form = new FormData();
  form.append('item_name', document.getElementById('lfItem').value.trim());
  form.append('description', document.getElementById('lfDescription').value.trim());
  form.append('lost_location', document.getElementById('lfLocation').value.trim());
  form.append('lost_at', document.getElementById('lfLostAt').value);
  const image = document.getElementById('lfImage').files[0];
  if (image) form.append('image', image);
  return form;
}

document.getElementById('lfCreateForm').addEventListener('submit', async event => {
  event.preventDefault();
  const image = document.getElementById('lfImage').files[0];
  if (image && (image.size > 5 * 1024 * 1024 || !['image/jpeg','image/png','image/gif','image/webp'].includes(image.type))) {
    showLfAlert('Choose a JPG, PNG, GIF, or WebP image no larger than 5 MB.', 'danger'); return;
  }
  try {
    const form = event.target;
    const editingId = form.dataset.editing;
    const formData = lfFormData();
    if (editingId) formData.append('message', 'Guest updated report details.');
    await lfRequest(editingId ? `${LF_API}/${editingId}` : LF_API, {method:editingId ? 'PUT' : 'POST', body:formData});
    form.reset(); delete form.dataset.editing;
    form.querySelector('button[type="submit"]').innerHTML = '<i class="fa-solid fa-paper-plane me-2"></i>Submit Report';
    showLfAlert(editingId ? 'Report details updated.' : 'Your report has been submitted and is visible to other guests.'); await loadLostFound();
  } catch (error) { showLfAlert(error.message, 'danger'); }
});

async function editLfReport(reportId) {
  const reports = await lfRequest(LF_API);
  const report = reports.find(item => item.report_id === reportId && item.is_mine);
  if (!report) return showLfAlert('You can only edit your own reports.', 'danger');
  document.getElementById('lfItem').value = report.item_name;
  document.getElementById('lfLocation').value = report.lost_location;
  document.getElementById('lfDescription').value = report.description;
  const date = new Date(report.lost_at); date.setMinutes(date.getMinutes() - date.getTimezoneOffset());
  document.getElementById('lfLostAt').value = date.toISOString().slice(0,16);
  const form = document.getElementById('lfCreateForm');
  form.dataset.editing = reportId;
  form.querySelector('button[type="submit"]').innerHTML = '<i class="fa-solid fa-floppy-disk me-2"></i>Save Report Changes';
  window.scrollTo({top:0,behavior:'smooth'});
}

async function submitLfUpdate(event, reportId) {
  event.preventDefault();
  const message = document.getElementById(`lfMsg${reportId}`).value.trim();
  const status = document.getElementById(`lfStatus${reportId}`)?.value || '';
  try {
    await lfRequest(`${LF_API}/${reportId}/updates`, {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({message,status})});
    showLfAlert('Your update has been added.'); await loadLostFound();
  } catch (error) { showLfAlert(error.message, 'danger'); }
}
