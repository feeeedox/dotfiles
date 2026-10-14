(function () {
  const accent  = "{{ colors.primary.default.hex }}";
  const bg      = "{{ colors.background.default.hex }}";
  const surface = "{{ colors.surface_container.default.hex }}";
  const text    = "{{ colors.on_background.default.hex }}";
  const muted   = "{{ colors.on_surface_variant.default.hex }}";
  const divider = "{{ colors.outline_variant.default.hex }}";


  function hexToRgb(hex) {
    const h = hex.replace("#", "");
    return [0, 2, 4].map((i) => parseInt(h.slice(i, i + 2), 16));
  }
  const accentRgb = hexToRgb(accent);
  const textRgb   = hexToRgb(text);

  const settings = {
    "spotui:input-bg":                    accent,
    "spotui:input-bg-hover":              surface,
    "spotui:input-text":                  bg,
    "spotui:input-border":                divider,
    "spotui:player-bar-bg":               bg,
    "spotui:player-bar-border":           accent,
    "spotui:player-bar-text":             text,
    "spotui:progress-bar-bg":             surface,
    "spotui:progress-bar-fg":             accent,
    "spotui:lyrics-color-active":         accent,
    "spotui:lyrics-color-inactive":       muted,
    "spotui:lyrics-color-light-inactive": text,
    "spotui:visualizer-color":            accent,
    "spotui:panel-border":                accent,
    "spotui:panel-text":                  accent,
  };
  try {
    Object.entries(settings).forEach(([k, v]) => localStorage.setItem(k, v));
  } catch (e) {}

  const cssVars = {
    "--input-bg-color":              accent,
    "--input-bg-hover-color":        surface,
    "--input-text-color":            bg,
    "--input-border-color":          divider,
    "--player-bar-background":       bg,
    "--player-bar-border-color":     accent,
    "--player-bar-text-color":       text,
    "--progress-bar-background":     surface,
    "--progress-bar-foreground":     accent,
    "--lyrics-color-active":         accent,
    "--lyrics-color-inactive":       muted,
    "--lyrics-color-light-inactive": text,
    "--visualizer-color":            accent,
    "--panel-border-color":          accent,
    "--panel-text-color":            accent,
    "--panel-text-hover-color":      muted,
    "--spotui-accent":               accent,
    "--spotui-accent-rgb":           accentRgb.join(", "),
  };

  function applyVars() {
    const r = document.documentElement;
    for (const [k, v] of Object.entries(cssVars)) {
      if (r.style.getPropertyValue(k).trim() !== v) r.style.setProperty(k, v);
    }
  }

  function watchRoot() {
    let busy = false;
    new MutationObserver(() => {
      if (busy) return;
      busy = true;
      applyVars();
      busy = false;
    }).observe(document.documentElement, { attributes: true, attributeFilter: ["style"] });
  }

  function injectCSS() {
    const old = document.getElementById("matugen-spotui-overrides");
    if (old) old.remove();
    const style = document.createElement("style");
    style.id = "matugen-spotui-overrides";
    style.textContent = `
      #spotui-tui { background: ${bg} !important; color: ${text} !important; }
      #spotui-top-fade { background: linear-gradient(to bottom, ${bg} 30%, transparent) !important; }
      .spotui-lyrics-fade-bottom { background: linear-gradient(0deg, ${bg}, transparent) !important; }
      #spotui-standby-overlay { background: ${bg} !important; }

      #spotui-input, .prompt { color: ${accent} !important; }
      #spotui-input::placeholder { color: ${muted} !important; }
      .spotui-control-btn:hover { color: ${text} !important; }

      .spotui-help-fieldset,
      #spotui-about-panel,
      #spotui-theme-panel,
      #spotui-onboarding-panel,
      .help-item .command { border-color: ${divider} !important; }
      .help-item .description,
      .spotui-onboarding-kicker,
      .spotui-lyrics-meta,
      .spotui-lyrics-empty,
      .spotui-lyrics-lines.unsynced .spotui-lyrics-line,
      #spotui-update-banner p { color: ${muted} !important; }
      .spotui-lyrics-track { color: ${text} !important; }
      .spotui-lyrics-header { border-bottom-color: ${divider} !important; }

      .selected,
      .playlist-item.selected, .song-item.selected,
      .result.selected, .spotui-search-item.selected,
      .spotui-search-item.selected .spotui-search-type { color: ${bg} !important; }
      .selected, .playlist-item.selected, .song-item.selected,
      .result.selected, .spotui-search-item.selected { background: ${accent} !important; }

      #spotui-playlist-sort,
      #spotui-playlist-find,
      #spotui-playlist-info-popup,
      #spotui-queue-info-popup,
      #spotui-search-info-popup { background: ${bg} !important; color: ${text} !important; }
      #spotui-search-bar { background: ${surface} !important; }
      #spotui-search-input::placeholder,
      #spotui-search-ghost,
      .spotui-search-empty { color: ${muted} !important; }
      .spotui-search-item { color: ${text} !important; }

      .theme-card { background: ${surface} !important; }
      .theme-card button { color: ${bg} !important; }

      .spotui-lyrics-kicker,
      .spotui-lyrics-empty strong,
      .spotui-onboarding-copy h2,
      .spotui-onboarding-callout .arrow,
      .spotui-onboarding-theme span,
      #spotui-update-banner h3,
      .spotui-banner-link-btn:hover { color: ${accent} !important; }
      .spotui-onboarding-copy p,
      .spotui-onboarding-primer,
      .spotui-onboarding-actions,
      .spotui-onboarding-callout,
      .spotui-onboarding-theme { color: ${text} !important; }
      .spotui-onboarding-copy code,
      .spotui-onboarding-primer code,
      .spotui-onboarding-callout code {
        color: ${accent} !important;
        background: ${surface} !important;
        border-color: ${divider} !important;
      }
      .spotui-onboarding-primer,
      .spotui-onboarding-callout,
      .spotui-onboarding-theme { border-color: ${divider} !important; }
      .spotui-onboarding-callout, .spotui-onboarding-theme { background: ${surface} !important; }
      #spotui-update-banner { background: ${bg} !important; color: ${text} !important; border-color: ${accent} !important; }
    `;
    document.head.appendChild(style);
  }

  const ASCII_ROWS = 8;  
  const ASCII_COLS = 65; 
  const ASCII_PAD  = 20; 

  function logoColor(row, col) {
    const rn = row / (ASCII_ROWS - 1);
    const cn = col / (ASCII_COLS - 1);
    const t = Math.min(1, Math.max(0, Math.pow(rn, 1.8) * 0.9 + cn * 0.1));
    const c = accentRgb.map((a, i) => Math.round(a + (textRgb[i] - a) * t));
    return `rgb(${c[0]},${c[1]},${c[2]})`;
  }

  function patchLogoCanvas() {
    const proto = window.CanvasRenderingContext2D && CanvasRenderingContext2D.prototype;
    if (!proto) return;
    const orig = proto.__matugenOrigFillText || proto.fillText;
    proto.__matugenOrigFillText = orig;

    proto.fillText = function (str, x, y, maxWidth) {
      const cv = this.canvas;
      if (cv && cv.classList && cv.classList.contains("spotui-ascii-canvas")) {
        const cssW = parseFloat(cv.style.width) || cv.clientWidth;
        const cssH = parseFloat(cv.style.height) || cv.clientHeight;
        const cellW = (cssW - ASCII_PAD * 2) / ASCII_COLS;
        const cellH = (cssH - ASCII_PAD * 2) / ASCII_ROWS;
        if (cellW > 0 && cellH > 0) {
          const col = Math.round((x - ASCII_PAD) / cellW);
          const row = Math.round((y - ASCII_PAD) / cellH);
          const color = logoColor(row, col);
          this.fillStyle = color;
          this.shadowColor = color;
        }
      }
      return maxWidth === undefined ? orig.call(this, str, x, y) : orig.call(this, str, x, y, maxWidth);
    };
  }

  function applyAll() {
    applyVars();
    injectCSS();
  }

  patchLogoCanvas();

  function waitForTui() {
    if (document.getElementById("spotui-tui")) {
      applyAll();
      watchRoot();
      return;
    }
    const observer = new MutationObserver(() => {
      if (document.getElementById("spotui-tui")) {
        observer.disconnect();
        setTimeout(() => {
          applyAll();
          watchRoot();
        }, 100);
      }
    });
    observer.observe(document.body || document.documentElement, { childList: true, subtree: true });
  }

  if (document.body) waitForTui();
  else document.addEventListener("DOMContentLoaded", waitForTui);
})();