/* ==========================================================================
   Grand Horizon Hotel Management System - Login JavaScript Logic
   ========================================================================== */

function login() {
  const emailInput = document.getElementById('email');
  const passwordInput = document.getElementById('password');
  const roleInput = document.querySelector('input[name="role"]:checked');
  const alertBox = document.getElementById('login-alert');

  if (!emailInput || !emailInput.value.trim()) {
    showError('Please enter a valid email address.');
    return;
  }

  if (!passwordInput || !passwordInput.value.trim()) {
    showError('Please enter your password.');
    return;
  }

  const role = roleInput ? roleInput.value : 'customer';
  const name = emailInput.value.split('@')[0];

  // Save session info
  sessionStorage.setItem('user', JSON.stringify({
    email: emailInput.value,
    role: role,
    name: name.charAt(0).toUpperCase() + name.slice(1)
  }));

  // Redirect based on role
  if (role === 'customer') {
    window.location.href = 'customer/dashboard.html';
  } else if (role === 'receptionist') {
    window.location.href = 'receptionist/dashboard.html';
  } else {
    window.location.href = 'unauthorized.html';
  }
}

function showError(msg) {
  const alertBox = document.getElementById('login-alert');
  if (alertBox) {
    alertBox.textContent = msg;
    alertBox.classList.remove('d-none');
  }
}