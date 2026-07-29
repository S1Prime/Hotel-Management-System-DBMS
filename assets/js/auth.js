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
    if (requiredRole === 'receptionist') {
      window.location.href = 'reception-login.html';
    } else if (requiredRole === 'customer') {
      window.location.href = 'customer-login.html';
    } else {
      window.location.href = 'login.html';
    }
    return false;
  }
  if (requiredRole && user.role !== requiredRole) {
    window.location.href = 'unauthorized.html';
    return false;
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

function quickDemoLogin(role) {
  if (role === 'receptionist' || role === 'reception') {
    loginUser('reception@crowneplaza.com', 'receptionist', 'Arthur Pendelton', { staffId: 'CP-STAFF-902', title: 'Senior Front Desk Officer' });
    window.location.href = 'reception-dashboard.html';
  } else if (role === 'customer') {
    loginUser('guest@crowneplaza.com', 'customer', 'Eleanor Vance', { phone: '+1 (555) 234-5678', roomNumber: '101', bookingId: 'BK-1001' });
    window.location.href = 'customer-dashboard.html';
  }
}
