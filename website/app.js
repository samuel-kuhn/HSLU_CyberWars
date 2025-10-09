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

document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById("serviceModal");
  const modalMessage = document.getElementById("modalMessage");
  const closeModal = document.getElementById("closeModal");
  const overlay = document.getElementById("modalOverlay");
  const serviceButton = document.querySelector('a[href="#schedule"]');
  const bookingForm = document.getElementById("bookingForm");
  const nameInput = document.getElementById("nameInput");
  const dateInput = document.getElementById("dateInput");

  let clickCount = 0;

  function openModal() {
    modal.classList.add("active");
    modal.setAttribute("aria-hidden", "false");
    modalMessage.textContent = "";
    bookingForm.style.display = "flex";
  }

  function closeModalWindow() {
    modal.classList.remove("active");
    modal.setAttribute("aria-hidden", "true");
  }

  function mockBackendCall(name, date) {
    modalMessage.textContent = "Bitte warten, wir verarbeiten Ihre Anfrage...";
    bookingForm.style.display = "none";

    setTimeout(() => {
      clickCount++;
      if (clickCount >= 3) {
        modalMessage.textContent = "Danke für Ihre Geduld — noch ist nichts passiert. 😉";
      } else {
        modalMessage.innerHTML = `
          Vielen Dank, <strong>${name}</strong>!<br>
          Wir haben Ihren Wunschtermin am <strong>${date}</strong> erhalten.
        `;
      }
    }, 3000);
  }

  serviceButton.addEventListener("click", (e) => {
    e.preventDefault();
    openModal();
  });

  bookingForm.addEventListener("submit", (e) => {
    e.preventDefault();
    const name = nameInput.value.trim() || "Unbekannt";
    const date = dateInput.value || "kein Datum gewählt";
    mockBackendCall(name, date);
  });

  closeModal.addEventListener("click", closeModalWindow);
  overlay.addEventListener("click", closeModalWindow);
});

