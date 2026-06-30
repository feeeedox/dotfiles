#!/usr/bin/env bash
#
# Interactive helper around GNU stow for this dotfiles repo.
# Every top-level folder (hypr, kitty, waybar, ...) is a stow package.
#
# Usage:
#   ./stow.sh              interactive menu
#   ./stow.sh hypr kitty   stow only the given packages
#   ./stow.sh --all        stow everything
#   ./stow.sh -D hypr      unstow (remove symlinks) for a package

set -euo pipefail

RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BG_BLUE='\033[44m'
WHITE='\033[0;37m'

info()    { echo -e "  ${CYAN}${BOLD}::${RESET}  $1"; }
success() { echo -e "  ${GREEN}${BOLD}✓${RESET}   $1"; }
error()   { echo -e "  ${RED}${BOLD}✗${RESET}   $1" >&2; }
warn()    { echo -e "  ${YELLOW}${BOLD}!${RESET}   $1"; }
step()    { echo -e "\n${BOLD}${BLUE}━━ $1 ${DIM}────────────────────────────────${RESET}"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${STOW_TARGET:-$HOME}"

# folders that are stow packages (top-level dirs, minus anything that isn't one)
EXCLUDE=("assets" ".git" "scripts")
mapfile -t PACKAGES < <(
    find "$REPO_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort
)
# scripts/ is also a real package (it installs into ~/.local/bin), so don't
# actually exclude it — keeping the list above for non-package dirs only.
FILTERED=()
for p in "${PACKAGES[@]}"; do
    case "$p" in
        assets|.git) ;;
        *) FILTERED+=("$p") ;;
    esac
done
PACKAGES=("${FILTERED[@]}")

if ! command -v stow >/dev/null 2>&1; then
    error "GNU stow is not installed — install it first (e.g. ${BOLD}sudo pacman -S stow${RESET})"
    exit 1
fi

do_stow() {
    local mode="$1"; shift
    for pkg in "$@"; do
        if [[ ! -d "$REPO_DIR/$pkg" ]]; then
            error "no such package: $pkg"
            continue
        fi
        if [[ "$mode" == "D" ]]; then
            if stow -D -d "$REPO_DIR" -t "$TARGET" "$pkg" 2>/tmp/stow_err; then
                success "unlinked ${BOLD}$pkg${RESET}"
            else
                error "failed to unlink $pkg"
                cat /tmp/stow_err >&2
            fi
            continue
        fi

        if stow -d "$REPO_DIR" -t "$TARGET" "$pkg" 2>/tmp/stow_err; then
            success "linked ${BOLD}$pkg${RESET}"
        else
            if grep -q "existing target is" /tmp/stow_err; then
                warn "${BOLD}$pkg${RESET} conflicts with existing files in $TARGET"
                read -rp "      adopt them into the repo instead (overwrites tracked files!) [y/N] " ans
                if [[ "$ans" =~ ^[Yy]$ ]]; then
                    stow --adopt -d "$REPO_DIR" -t "$TARGET" "$pkg"
                    success "adopted and linked ${BOLD}$pkg${RESET} — check 'git diff'"
                else
                    error "skipped $pkg (resolve the conflict manually, then re-run)"
                fi
            else
                error "failed to stow $pkg"
                cat /tmp/stow_err >&2
            fi
        fi
    done
    rm -f /tmp/stow_err
}

echo -e "\n${BOLD}${BG_BLUE}${WHITE}  dotfiles  ${RESET}${BOLD}  stow helper${RESET}\n"

# non-interactive modes
if [[ "${1:-}" == "--all" ]]; then
    step "stowing all packages into $TARGET"
    do_stow S "${PACKAGES[@]}"
    exit 0
elif [[ "${1:-}" == "-D" ]]; then
    shift
    step "unstowing: $*"
    do_stow D "$@"
    exit 0
elif [[ $# -gt 0 ]]; then
    step "stowing into $TARGET"
    do_stow S "$@"
    exit 0
fi

# interactive menu
step "available packages"
for i in "${!PACKAGES[@]}"; do
    printf "  ${DIM}%2d)${RESET} %s\n" "$((i+1))" "${PACKAGES[$i]}"
done

echo
read -rp "  select packages (numbers separated by space, 'a' for all, 'q' to quit): " selection
echo

if [[ "$selection" == "q" ]]; then
    exit 0
elif [[ "$selection" == "a" ]]; then
    chosen=("${PACKAGES[@]}")
else
    chosen=()
    for n in $selection; do
        idx=$((n-1))
        if [[ -n "${PACKAGES[$idx]:-}" ]]; then
            chosen+=("${PACKAGES[$idx]}")
        fi
    done
fi

if [[ ${#chosen[@]} -eq 0 ]]; then
    warn "nothing selected"
    exit 0
fi

step "stowing into $TARGET"
do_stow S "${chosen[@]}"

echo
success "done! restart hyprland or relevant apps to pick up changes"
echo