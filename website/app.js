// Mobile menu toggle
const btn = document.getElementById('menuBtn');
const menu = document.getElementById('mobileMenu');
if (btn && menu) {
  btn.addEventListener('click', () => {
    const open = menu.classList.toggle('open');
    btn.setAttribute('aria-expanded', String(open));
  });

  // Close menu on link click (mobile)
  menu.querySelectorAll('a').forEach(a =>
    a.addEventListener('click', () => {
      if (menu.classList.contains('open')) {
        menu.classList.remove('open');
        btn.setAttribute('aria-expanded', 'false');
      }
    })
  );
}

// Set year in footer
const yearEl = document.getElementById('year');
if (yearEl) yearEl.textContent = new Date().getFullYear();
