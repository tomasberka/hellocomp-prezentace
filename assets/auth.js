// Lightweight in-site password gate.
(function(){
  const SECRET = 'prezentace2026'; // change this string if you want a different password
  const STORAGE_KEY = 'hc_presentations_auth_v1';

  function createOverlay(){
    const overlay = document.createElement('div'); overlay.id = 'auth-overlay';
    overlay.innerHTML = `
      <div class="auth-box">
        <h2>Pro vstup zadejte heslo</h2>
        <input id="auth-password" type="password" placeholder="Heslo" aria-label="Heslo">
        <div class="auth-actions"><button id="auth-submit" class="btn">Odeslat</button></div>
        <div class="auth-help">Kontaktujte administrátora pro heslo.</div>
      </div>
    `;
    document.documentElement.appendChild(overlay);
    const submit = () => {
      const v = document.getElementById('auth-password').value || '';
      if (v === SECRET) { sessionStorage.setItem(STORAGE_KEY,'1'); overlay.remove(); }
      else { alert('Heslo je špatné.'); }
    };
    document.getElementById('auth-submit').addEventListener('click', submit);
    document.getElementById('auth-password').addEventListener('keypress', (e)=>{ if(e.key==='Enter') submit(); });
  }

  document.addEventListener('DOMContentLoaded', () => {
    try {
      if (!sessionStorage.getItem(STORAGE_KEY)) createOverlay();
    } catch (e) { /* sessionStorage may be disabled */ createOverlay(); }
  });
})();
