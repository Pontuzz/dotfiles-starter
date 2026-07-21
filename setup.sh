#!/usr/bin/env bash
# ============================================================================
# Dotfiles Starter — Setup & Bootstrap
# ============================================================================
# Usage:
#   ./setup.sh              # Full setup (idempotent)
#   ./setup.sh --check      # Only check status, don't install anything
#   ./setup.sh --minimal    # Skip optional tools, just shell + symlinks
#
# Works on: Ubuntu/Debian, Arch, Fedora, macOS (brew), Alpine
# ============================================================================
set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
REPO_URL="https://github.com/Pontuzz/dotfiles-starter.git"
REPO_PATH="${DOTFILES:-$HOME/dotfiles}"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; GRAY='\033[0;90m'; NC='\033[0m'

step()   { echo -e "\n${CYAN}➜${NC} $1"; }
ok()     { echo -e "  ${GREEN}✓${NC} $1"; }
warn()   { echo -e "  ${YELLOW}✗${NC} $1"; }
info()   { echo -e "  ${GRAY}·${NC} $1"; }
fail()   { echo -e "  ${RED}✗${NC} $1"; }

# ─── Flags ───────────────────────────────────────────────────────────────────
CHECK_ONLY=false
MINIMAL=false
for arg in "$@"; do
    case "$arg" in
        --check) CHECK_ONLY=true ;;
        --minimal) MINIMAL=true ;;
    esac
done

# ─── Package Manager Detection ──────────────────────────────────────────────
detect_pkg_manager() {
    if command -v apt-get &>/dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt-get install -y"
        PKG_UPDATE="sudo apt-get update -qq"
    elif command -v pacman &>/dev/null; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        PKG_UPDATE="sudo pacman -Sy"
    elif command -v dnf &>/dev/null; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
        PKG_UPDATE="sudo dnf check-update -qq || true"
    elif command -v brew &>/dev/null; then
        PKG_MANAGER="brew"
        PKG_INSTALL="brew install"
        PKG_UPDATE="brew update"
    elif command -v apk &>/dev/null; then
        PKG_MANAGER="apk"
        PKG_INSTALL="sudo apk add"
        PKG_UPDATE="sudo apk update -q"
    else
        PKG_MANAGER="unknown"
        PKG_INSTALL=""
        PKG_UPDATE=""
    fi
}

install_pkg() {
    if [ "$CHECK_ONLY" = true ]; then
        for pkg in "$@"; do
            info "Would install: $pkg"
        done
        return
    fi
    if [ -n "$PKG_INSTALL" ]; then
        $PKG_INSTALL "$@" 2>/dev/null || warn "Install failed for some packages (may already be installed)"
    else
        warn "No package manager found — install manually: $*"
    fi
}

# ─── Symlink Helpers ─────────────────────────────────────────────────────────
backup_and_link() {
    local target=$1
    local link_name=$2

    # Create parent directory if needed
    local parent_dir
    parent_dir=$(dirname "$link_name")
    if [ ! -d "$parent_dir" ]; then
        mkdir -p "$parent_dir"
    fi

    # If link already points to target, skip
    if [ -L "$link_name" ] && [ "$(readlink "$link_name")" = "$target" ]; then
        ok "Symlink exists: $link_name → $target"
        return
    fi

    # If something exists, back it up
    if [ -e "$link_name" ] || [ -L "$link_name" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$link_name" "$BACKUP_DIR/" 2>/dev/null || true
    fi

    ln -s "$target" "$link_name"
    ok "Symlinked: $link_name → $target"
}

# ─── 1. Clone / Update Repo ─────────────────────────────────────────────────
setup_repo() {
    step "1. Cloning / updating dotfiles repo"

    if [ -d "$REPO_PATH/.git" ]; then
        info "Repo exists at $REPO_PATH — pulling latest"
        git -C "$REPO_PATH" pull --rebase 2>/dev/null && ok "Repo updated" || warn "Git pull failed"
    else
        if [ "$CHECK_ONLY" = true ]; then
            info "Repo not cloned yet (would clone to $REPO_PATH)"
            return
        fi
        info "Cloning to $REPO_PATH..."
        if git clone "$REPO_URL" "$REPO_PATH" 2>/dev/null; then
            ok "Repo cloned"
        else
            fail "Clone failed — make sure you have access to $REPO_URL"
            fail "Or clone manually and re-run this script from $REPO_PATH"
            exit 1
        fi
    fi

    # Init/update submodules (oh-my-zsh plugins + p10k)
    info "Updating submodules..."
    git -C "$REPO_PATH" submodule update --init --recursive 2>/dev/null && ok "Submodules initialized" || warn "Submodule init failed (git may be outdated)"

    # Configure hooks path for pre-commit validation
    git -C "$REPO_PATH" config core.hooksPath hooks/
    ok "Git hooks configured (hooks/)"
}

# ─── 2. Install Shell & Dependencies ──────────────────────────────────────
install_shell() {
    step "2. Installing shell dependencies"

    if [ "$CHECK_ONLY" = true ]; then
        for cmd in zsh git curl; do
            command -v "$cmd" &>/dev/null && ok "$cmd — installed" || warn "$cmd — missing"
        done
        return
    fi

    # Core dependencies (required)
    local core_pkgs=()
    command -v zsh &>/dev/null || core_pkgs+=("zsh")
    command -v curl &>/dev/null || core_pkgs+=("curl")
    command -v git &>/dev/null || core_pkgs+=("git")

    if [ ${#core_pkgs[@]} -gt 0 ]; then
        info "Installing: ${core_pkgs[*]}"
        install_pkg "${core_pkgs[@]}"
    fi

    command -v zsh &>/dev/null && ok "zsh — installed" || fail "zsh — MISSING"
    command -v curl &>/dev/null && ok "curl — installed" || warn "curl — missing"
    command -v git &>/dev/null && ok "git — installed" || warn "git — missing"
}

# ─── 3. Install Oh My Zsh ──────────────────────────────────────────────────
install_omz() {
    step "3. Setting up Oh My Zsh"

    # Dotfiles include OMZ as a submodule — check both bundled and system paths
    local bundled_omz="$REPO_PATH/.config/zsh/.oh-my-zsh"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        ok "Oh My Zsh — already installed (system)"
        return
    fi

    if [ -d "$bundled_omz" ]; then
        ok "Oh My Zsh — bundled in dotfiles submodule"
        return
    fi

    if [ "$CHECK_ONLY" = true ]; then
        info "Oh My Zsh not found (would install)"
        return
    fi

    info "Installing Oh My Zsh..."
    # Non-interactive install (just runs the installer, skips chsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null && \
        ok "Oh My Zsh installed" || warn "Oh My Zsh install failed (may already exist)"
}

# ─── 4. Create Symlinks ────────────────────────────────────────────────────
create_symlinks() {
    step "4. Creating dotfiles symlinks"

    if [ ! -d "$REPO_PATH" ]; then
        fail "Repo not found at $REPO_PATH — run full setup first"
        return
    fi

    backup_and_link "$REPO_PATH/.zshenv"          "$HOME/.zshenv"
    backup_and_link "$REPO_PATH/.bashrc"          "$HOME/.bashrc"
    backup_and_link "$REPO_PATH/.profile"         "$HOME/.profile"
    backup_and_link "$REPO_PATH/.config/zsh"      "$HOME/.config/zsh"
    backup_and_link "$REPO_PATH/.gitconfig"       "$HOME/.gitconfig"
    backup_and_link "$REPO_PATH/.gitignore_global" "$HOME/.gitignore_global"

    if [ -d "$BACKUP_DIR" ]; then
        info "Backups saved to: $BACKUP_DIR"
    fi
}

# ─── 5. Install Tools ──────────────────────────────────────────────────────

# Check if a tool is installed, handling distro quirks:
#   bat  → also checks batcat (Debian packages bat as batcat)
#   rg   → also checks ripgrep (some distros use different names)
_tool_installed() {
    local cmd=$1
    command -v "$cmd" &>/dev/null && return 0
    # Fallback checks for known aliases
    case "$cmd" in
        bat)     command -v batcat &>/dev/null && return 0 ;;
        ripgrep) command -v rg &>/dev/null && return 0 ;;
    esac
    return 1
}

install_tools() {
    if [ "$MINIMAL" = true ]; then
        step "5. Skipping optional tools (--minimal mode)"
        return
    fi

    step "5. Installing tools"

    local tool_list=()

    # Build tool list for the detected package manager
    case "$PKG_MANAGER" in
        brew)  tool_list=(fzf zoxide lsd bat ripgrep eza hyperfine jq) ;;
        apt)   tool_list=(fzf zoxide bat ripgrep jq) ;;
        pacman) tool_list=(fzf zoxide lsd bat ripgrep eza jq) ;;
        dnf)   tool_list=(fzf zoxide lsd bat ripgrep jq) ;;
        *)     tool_list=() ;;
    esac

    # Report what's available vs missing
    local missing_list=()
    for pkg in "${tool_list[@]}"; do
        if _tool_installed "$pkg"; then
            ok "$pkg — installed"
        else
            warn "$pkg — missing"
            missing_list+=("$pkg")
        fi
    done

    # Note tools not covered by package manager
    case "$PKG_MANAGER" in
        apt)
            _tool_installed lsd || info "lsd — install via: https://github.com/lsd-rs/lsd/releases"
            _tool_installed eza || info "eza — install via: cargo install eza or apt (if available)"
            ;;
    esac

    # Nothing to install
    if [ ${#missing_list[@]} -eq 0 ]; then
        return
    fi

    # Interactive prompt — ask user if running in a terminal
    local do_install=true
    if [ -t 0 ]; then
        echo ""
        read -r -p "  Install missing tools? [Y/n]: " choice </dev/tty
        case "$choice" in
            n|N|no|NO) do_install=false ;;
        esac
    fi

    if [ "$CHECK_ONLY" = true ] || [ "$do_install" = false ]; then
        [ "$do_install" = false ] && info "Skipping tool installation"
        return
    fi

    info "Installing: ${missing_list[*]}"
    install_pkg "${missing_list[@]}"
}

# ─── 6. Set Zsh as Default Shell ───────────────────────────────────────────
set_default_shell() {
    step "6. Setting default shell"

    local zsh_path
    zsh_path=$(command -v zsh 2>/dev/null || true)

    if [ -z "$zsh_path" ]; then
        warn "zsh not installed — skip shell change"
        return
    fi

    local current_shell
    current_shell=$(basename "$SHELL" 2>/dev/null || echo "unknown")

    if [ "$current_shell" = "zsh" ]; then
        ok "zsh is already the default shell"
        return
    fi

    if [ "$CHECK_ONLY" = true ]; then
        info "Default shell is $current_shell (would change to zsh)"
        return
    fi

    if chsh -s "$zsh_path" 2>/dev/null; then
        ok "Default shell changed to zsh (log out and back in)"
    else
        warn "Could not change shell — try: chsh -s $(which zsh)"
    fi
}

# ─── 7. Summary ────────────────────────────────────────────────────────────
print_summary() {
    step "7. Summary"

    echo ""
    if [ -f "$HOME/.zshenv" ] && [ -L "$HOME/.zshenv" ]; then
        echo -e "  ${GREEN}✅${NC} Dotfiles installed and configured"
    else
        echo -e "  ${YELLOW}⚠${NC} Dotfiles partially set up — some symlinks may be missing"
    fi

    echo ""
    echo -e "  ${GRAY}Next steps:${NC}"
    echo -e "  ${GRAY}  1. Restart your shell: exec zsh${NC}"
    echo -e "  ${GRAY}  2. Or source the config:  . ~/.zshenv${NC}"
    echo -e "  ${GRAY}  3. Update 99-local.zsh for machine-specific config${NC}"

    if [ -f "$HOME/.p10k.zsh" ]; then
        echo -e "  ${GRAY}  4. Run 'p10k configure' to tune the prompt${NC}"
    fi

    echo ""
    if [ "$CHECK_ONLY" = true ]; then
        echo -e "  ${YELLOW}Check complete — no changes made${NC}"
    else
        echo -e "  ${GREEN}✓${NC} Setup complete!"
    fi
}

# ─── Main ──────────────────────────────────────────────────────────────────
main() {
    echo ""
    echo -e "  ${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║      Dotfiles Starter — Setup        ║${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════════╝${NC}"
    echo ""

    detect_pkg_manager
    info "Detected package manager: ${PKG_MANAGER:-unknown}"
    [ "$MINIMAL" = true ] && info "Minimal mode: skipping optional tools"
    [ "$CHECK_ONLY" = true ] && info "Check mode: no changes will be made"

    setup_repo
    install_shell
    install_omz
    create_symlinks
    install_tools
    set_default_shell
    print_summary
}

main "$@"
