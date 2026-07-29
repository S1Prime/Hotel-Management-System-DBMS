/* ==========================================================================
   Grand Horizon Hotel Management System - Auth Helper Utilities
   ========================================================================== */

function getCurrentUser() {
  const userData = sessionStorage.getItem('user');
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
    window.location.href = '../login.html';
    return false;
  }
  if (requiredRole && user.role !== requiredRole) {
    window.location.href = '../unauthorized.html';
    return false;
  }
  return true;
}

function logoutUser() {
  sessionStorage.removeItem('user');
  window.location.href = '../login.html';
}