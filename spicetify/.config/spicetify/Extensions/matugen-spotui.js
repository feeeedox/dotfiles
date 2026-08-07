(function () {
  const scheme = {
    accent:  "#adc6ff",
    bg:      "#111318",
    surface: "#1e1f25",
    text:    "#e2e2e9",
    muted:   "#c4c6d0",
    divider: "#44474f",
    error:   "#ffb4ab",
    font:    "JetBrains Mono",
  };

  localStorage.setItem("spotui:custom-scheme", JSON.stringify(scheme));
  localStorage.setItem("spotui:scheme", "custom");
})();