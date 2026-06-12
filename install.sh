#!/usr/bin/env bash

RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'

info()    { echo -e "  ${CYAN}${BOLD}::${RESET}  $1"; }
success() { echo -e "  ${GREEN}${BOLD}✓${RESET}   $1"; }
error()   { echo -e "  ${RED}${BOLD}✗${RESET}   $1" >&2; }
step()    { echo -e "\n${BOLD}${BLUE}━━ $1 ${DIM}────────────────────────────────${RESET}"; }
pkg()     { echo -e "  ${DIM}▸${RESET} $1"; }

echo -e "\n${BOLD}${BG_BLUE}${WHITE}  dotfiles  ${RESET}${BOLD}  dependency installer${RESET}\n"

step "AUR helper"
if command -v paru >/dev/null 2>&1; then
    HELPER="paru"
    success "found ${BOLD}paru${RESET}"
elif command -v yay >/dev/null 2>&1; then
    HELPER="yay"
    success "found ${BOLD}yay${RESET}"
else
    error "no AUR helper found — install yay or paru first"
    exit 1
fi

PACKAGES=(
    hyprland kitty thunar rofi-wayland
    cliphist wl-clipboard gawk hyprshot
    satty hyprpicker waybar awww python-pywalfox
    brightnessctl wireplumber playerctl wlogout
    swaync matugen-bin
)

step "packages (${#PACKAGES[@]} total)"
for p in "${PACKAGES[@]}"; do pkg "$p"; done

step "installing via ${BOLD}$HELPER${RESET}"
echo ""
$HELPER -S --needed "${PACKAGES[@]}"

echo ""
success "all done!"
echo -e "  ${DIM}restart your session to apply changes${RESET}\n"