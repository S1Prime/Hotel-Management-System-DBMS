/* ==========================================================================
   Crowne Plaza Hotel Management System - Auth Helper Utilities
   ========================================================================== */

function getCurrentUser() {
  const userData = sessionStorage.getItem('cp_user');
  if (!userData) return null;
  try {
    return JSON.parse(userData);
  } catch (e) {
    return null;
  }
}

function checkAuth(requiredRole) {
  const user = getCurrentUser();
  if (!user) {
    if (requiredRole && ['receptionist', 'admin', 'staff'].includes(requiredRole.toLowerCase())) {
      window.location.href = 'reception-login.html';
    } else if (requiredRole && requiredRole.toLowerCase() === 'customer') {
      window.location.href = 'customer-login.html';
    } else {
      window.location.href = 'login.html';
    }
    return false;
  }

  const userRole = (user.role || '').toLowerCase();
  const reqRole = (requiredRole || '').toLowerCase();

  // If page requires Admin, only Admin role is allowed
  if (reqRole === 'admin') {
    if (userRole !== 'admin') {
      window.location.href = 'unauthorized.html';
      return false;
    }
    return true;
  }

  // If page requires Receptionist/Staff, allow Receptionist OR Admin
  if (reqRole === 'receptionist' || reqRole === 'staff') {
    if (userRole !== 'receptionist' && userRole !== 'admin') {
      window.location.href = 'unauthorized.html';
      return false;
    }
    return true;
  }

  // If page requires Customer, allow Customer OR Admin
  if (reqRole === 'customer') {
    if (userRole !== 'customer' && userRole !== 'admin') {
      window.location.href = 'unauthorized.html';
      return false;
    }
    return true;
  }

  return true;
}

function loginUser(email, role, name, extraData = {}) {
  const user = {
    email: email,
    role: role,
    name: name || email.split('@')[0],
    loggedInAt: new Date().toISOString(),
    ...extraData
  };
  sessionStorage.setItem('cp_user', JSON.stringify(user));
  return user;
}

function logoutUser() {
  sessionStorage.removeItem('cp_user');
  window.location.href = 'index.html';
}

async function performStaffLogin(email, password) {
  try {
    const res = await fetch('http://127.0.0.1:5000/api/staff/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });
    const data = await res.json();
    if (res.ok && data.staff) {
      loginUser(data.staff.email, data.staff.role, data.staff.name, { staffId: data.staff.staff_id });
      return { success: true, staff: data.staff };
    } else {
      return { success: false, error: data.error || 'Invalid credentials' };
    }
  } catch (e) {
    return { success: false, error: 'Cannot connect to backend server. Please ensure Flask server is running.' };
  }
}

