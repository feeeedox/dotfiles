(function () {
  const scheme = {
    accent:  "{{ colors.primary.default.hex }}",
    bg:      "{{ colors.background.default.hex }}",
    surface: "{{ colors.surface_container.default.hex }}",
    text:    "{{ colors.on_background.default.hex }}",
    muted:   "{{ colors.on_surface_variant.default.hex }}",
    divider: "{{ colors.outline_variant.default.hex }}",
    error:   "{{ colors.error.default.hex }}",
    font:    "JetBrains Mono",
  };

  localStorage.setItem("spotui:custom-scheme", JSON.stringify(scheme));
  localStorage.setItem("spotui:scheme", "custom");
})();