// Lightweight in-site password gate.
(function(){
  // In-site password gate.
  // Publicly-allowed pages (content hub) are bypassed; all other pages show a password overlay.
  const SECRET = 'prezentace+'; // updated password per request
  const STORAGE_KEY = 'hc_presentations_auth_v1';
  const ALLOWED_PATTERNS = [/content-?hub/i, /hellocomp[_-]?content[_-]?hub/i];

  function shouldBypass() {
    try {
      const path = (location.pathname || '').toLowerCase();
      const file = path.split('/').pop() || '';
      if (ALLOWED_PATTERNS.some(r => r.test(file))) return true;
      // Allow explicit preview query param if needed
      if (location.search && /[?&]public=1/.test(location.search)) return true;
      return false;
    } catch (e) { return false; }
  }

  function createOverlay(){
    const overlay = document.createElement('div'); overlay.id = 'auth-overlay';
    overlay.innerHTML = `
      <style>
        #auth-overlay{position:fixed;inset:0;background:rgba(2,6,23,.85);display:flex;align-items:center;justify-content:center;z-index:99999}
        .auth-box{background:#0f1724;color:#e6eef8;padding:20px;border-radius:10px;max-width:380px;width:92%;box-shadow:0 10px 40px rgba(2,6,23,.6);font-family:system-ui,-apple-system,Segoe UI,Roboto}
        .auth-box h2{margin:0 0 12px;font-size:1.05rem}
        .auth-box input{width:100%;padding:10px;border-radius:8px;border:1px solid rgba(255,255,255,.06);background:rgba(255,255,255,.02);color:#e6eef8;margin-bottom:10px}
        .auth-actions{display:flex;justify-content:flex-end}
        .auth-actions .btn{background:#2563eb;color:#fff;border:none;padding:8px 12px;border-radius:8px;cursor:pointer}
        .auth-help{font-size:0.82rem;color:#94a3b8;margin-top:10px}
      </style>
      <div class="auth-box">
        <h2>Pro vstup zadejte heslo</h2>
        <input id="auth-password" type="password" placeholder="Heslo" aria-label="Heslo">
        <div class="auth-actions"><button id="auth-submit" class="btn">Odeslat</button></div>
        <div class="auth-help">Kontaktujte administrátora pro heslo.</div>
      </div>
    `;
    document.documentElement.appendChild(overlay);
    const submit = () => {
      const v = (document.getElementById('auth-password') || {}).value || '';
      if (v === SECRET) { try { sessionStorage.setItem(STORAGE_KEY,'1'); } catch(e){}; overlay.remove(); }
      else { alert('Heslo je špatné.'); }
    };
    const btn = document.getElementById('auth-submit');
    if (btn) btn.addEventListener('click', submit);
    const inp = document.getElementById('auth-password');
    if (inp) inp.addEventListener('keypress', (e)=>{ if(e.key==='Enter') submit(); });
  }

  document.addEventListener('DOMContentLoaded', () => {
    try {
      if (shouldBypass()) return; // allow content hub pages
      if (!sessionStorage.getItem(STORAGE_KEY)) createOverlay();
    } catch (e) { createOverlay(); }
  });
})();
