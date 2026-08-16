(function () {
  const accent  = "{{ colors.primary.default.hex }}";
  const bg      = "{{ colors.background.default.hex }}";
  const surface = "{{ colors.surface_container.default.hex }}";
  const text    = "{{ colors.on_background.default.hex }}";
  const muted   = "{{ colors.on_surface_variant.default.hex }}";
  const divider = "{{ colors.outline_variant.default.hex }}";

  // localStorage persistent setzen
  localStorage.setItem("spotui:input-bg",                    accent);
  localStorage.setItem("spotui:input-bg-hover",              surface);
  localStorage.setItem("spotui:input-text",                  bg);
  localStorage.setItem("spotui:input-border",                divider);
  localStorage.setItem("spotui:player-bar-bg",               bg);
  localStorage.setItem("spotui:player-bar-border",           divider);
  localStorage.setItem("spotui:player-bar-text",             text);
  localStorage.setItem("spotui:progress-bar-bg",             surface);
  localStorage.setItem("spotui:progress-bar-fg",             accent);
  localStorage.setItem("spotui:lyrics-color-active",         accent);
  localStorage.setItem("spotui:lyrics-color-inactive",       muted);
  localStorage.setItem("spotui:lyrics-color-light-inactive", text);

  function applyVars() {
    const r = document.documentElement;
    r.style.setProperty("--input-bg-color",              accent);
    r.style.setProperty("--input-bg-hover-color",        surface);
    r.style.setProperty("--input-text-color",            bg);
    r.style.setProperty("--input-border-color",          divider);
    r.style.setProperty("--player-bar-background",       bg);
    r.style.setProperty("--player-bar-border-color",     divider);
    r.style.setProperty("--player-bar-text-color",       text);
    r.style.setProperty("--progress-bar-background",     surface);
    r.style.setProperty("--progress-bar-foreground",     accent);
    r.style.setProperty("--lyrics-color-active",         accent);
    r.style.setProperty("--lyrics-color-inactive",       muted);
    r.style.setProperty("--lyrics-color-light-inactive", text);
  }

  function injectCSS() {
    const existing = document.getElementById("matugen-spotui-overrides");
    if (existing) existing.remove();
    const style = document.createElement("style");
    style.id = "matugen-spotui-overrides";
    style.textContent = `
      #spotui-tui { background: ${bg} !important; color: ${text} !important; }
      #spotui-logo { color: ${accent} !important; }
      .prompt { color: ${accent} !important; }
      #spotui-input { color: ${accent} !important; }
      #spotui-input::placeholder { color: ${muted} !important; }
      #spotui-footer { border-top-color: ${divider} !important; }
      .spotui-control-btn { background: ${accent} !important; color: ${bg} !important; }
      .spotui-control-btn:hover { background: ${surface} !important; color: ${text} !important; }
      #spotui-help-panel,
      #spotui-about-panel,
      #spotui-theme-panel,
      #spotui-onboarding-panel { border-color: ${divider} !important; }
      .help-item .command { color: ${accent} !important; }
      .help-item .description { color: ${muted} !important; }
      #spotui-playlist-list, #spotui-song-list { border-color: ${accent} !important; }
      #spotui-playlist-list legend, #spotui-song-list legend { color: ${accent} !important; }
      .playlist-item.selected, .song-item.selected { background: ${accent} !important; color: ${bg} !important; }
      .theme-card { border-color: ${accent} !important; }
      .theme-card h3 { color: ${accent} !important; }
      .theme-card button { background: ${accent} !important; color: ${bg} !important; }
      .theme-card button:hover { background: ${surface} !important; }
      .spotui-lyrics-kicker { color: ${accent} !important; }
      .spotui-lyrics-line.active { color: ${accent} !important; }
      .spotui-onboarding-copy h2 { color: ${accent} !important; }
      .spotui-onboarding-copy code,
      .spotui-onboarding-primer code,
      .spotui-onboarding-callout code { color: ${accent} !important; background: ${surface} !important; border-color: ${divider} !important; }
      .spotui-onboarding-callout { border-color: ${divider} !important; }
      .spotui-onboarding-callout .arrow { color: ${accent} !important; }
      .spotui-onboarding-theme { border-color: ${divider} !important; }
      .spotui-onboarding-theme span { color: ${accent} !important; }
      .spotui-onboarding-kicker { color: ${muted} !important; }
      .result.selected { background: ${accent} !important; color: ${bg} !important; }

      .main-connectBar-connectBar,
      .main-connectBar-connectBarInner,
      .main-connectBar-connectBar * {
        background: ${bg} !important;
        background-color: ${bg} !important;
        border-top-color: ${divider} !important;
        color: ${text} !important;
        fill: ${text} !important;
      }
      .main-connectBar-connectBar button,
      .main-connectBar-connectBar [role="button"] {
        color: ${accent} !important;
        border-radius: 0 !important;
      }
      .main-connectBar-connectBar button:hover,
      .main-connectBar-connectBar [role="button"]:hover {
        color: ${text} !important;
      }
    `;
    document.head.appendChild(style);
  }

  function applyAll() {
    applyVars();
    injectCSS();
  }

  // Stärkerer Gradient: accent oben → text unten, kubische Kurve
  function getRowColor(row, col) {
    const totalRows = 7;
    const totalCols = 64;
    // Nur row bestimmt den Gradient, col minimal
    const t = Math.pow(row / totalRows, 1.8) * 0.9 + (col / totalCols) * 0.1;
    const clamped = Math.min(1, Math.max(0, t));

    const r1 = parseInt(accent.slice(1,3), 16);
    const g1 = parseInt(accent.slice(3,5), 16);
    const b1 = parseInt(accent.slice(5,7), 16);
    const r2 = parseInt(text.slice(1,3), 16);
    const g2 = parseInt(text.slice(3,5), 16);
    const b2 = parseInt(text.slice(5,7), 16);

    return `rgb(${Math.round(r1+(r2-r1)*clamped)},${Math.round(g1+(g2-g1)*clamped)},${Math.round(b1+(b2-b1)*clamped)})`;
  }

  // Farb-Map einmal vorberechnen
  const colorMap = new Map();

  function buildColorMap() {
    document.querySelectorAll(".spotui-ascii-char").forEach((span) => {
      const row = parseInt(span.dataset.row || 0);
      const col = parseInt(span.dataset.col || 0);
      const key = `${row},${col}`;
      if (!colorMap.has(key)) colorMap.set(key, getRowColor(row, col));
      span.dataset.origColor = colorMap.get(key);
      span.style.color = colorMap.get(key);
    });
  }

  // MutationObserver der sofort auf jede style-Änderung reagiert
  let asciiObserver = null;
  function startAsciiObserver() {
    if (asciiObserver) return;
    const logo = document.getElementById("spotui-logo");
    if (!logo) return;

    asciiObserver = new MutationObserver((mutations) => {
      // requestAnimationFrame damit wir nach der Animation-Schreiboperation kommen
      requestAnimationFrame(() => {
        mutations.forEach((m) => {
          if (m.type === "attributes" && m.attributeName === "style") {
            const span = m.target;
            const row = span.dataset?.row;
            const col = span.dataset?.col;
            if (row === undefined) return;
            const key = `${row},${col}`;
            const color = colorMap.get(key);
            if (color && span.style.color !== color) {
              span.style.color = color;
              span.dataset.origColor = color;
            }
          }
        });
      });
    });

    asciiObserver.observe(logo, {
      subtree: true,
      attributes: true,
      attributeFilter: ["style"],
    });
  }

  function waitForAscii() {
    const spans = document.querySelectorAll(".spotui-ascii-char");
    if (spans.length) {
      buildColorMap();
      startAsciiObserver();
      return;
    }
    const obs = new MutationObserver(() => {
      if (document.querySelectorAll(".spotui-ascii-char").length) {
        obs.disconnect();
        setTimeout(() => {
          buildColorMap();
          startAsciiObserver();
        }, 50);
      }
    });
    obs.observe(document.body, { childList: true, subtree: true });
  }

  function waitForTui() {
    if (document.getElementById("spotui-tui")) {
      applyAll();
      setTimeout(waitForAscii, 300);
      return;
    }
    const observer = new MutationObserver(() => {
      if (document.getElementById("spotui-tui")) {
        observer.disconnect();
        setTimeout(() => {
          applyAll();
          setTimeout(waitForAscii, 300);
        }, 100);
      }
    });
    observer.observe(document.body || document.documentElement, {
      childList: true,
      subtree: true,
    });
  }

  if (document.body) {
    waitForTui();
  } else {
    document.addEventListener("DOMContentLoaded", waitForTui);
  }

})();