#!/usr/bin/env zsh
# Diagnostics — health checks, maintenance, and tool verification
# Extracted from .zshrc for modularity. Runs at most once per day for checks.
# ============================================================================

# ── Symlink Health Check ──────────────────────────────────────────────────────
# Verifies critical dotfiles symlinks are intact.
# Silent when healthy; prints actionable fix commands on problems.
_dotfiles_check_links() {
  local _issues=0

  # ~/.config/zsh must point to the repo's zsh config
  if [[ ! -L "$HOME/.config/zsh" ]]; then
    echo "⚠️  ~/.config/zsh is not a symlink (expected → $DOTFILES/.config/zsh)"
    echo "   Fix: ln -sf $DOTFILES/.config/zsh ~/.config/zsh"
    (( _issues++ ))
  elif [[ ! -e "$HOME/.config/zsh" ]]; then
    echo "⚠️  ~/.config/zsh symlink is broken — target missing"
    echo "   Fix: ln -sf $DOTFILES/.config/zsh ~/.config/zsh"
    (( _issues++ ))
  fi

  # ~/.bashrc should point to the repo's bashrc (optional if bash isn't used)
  if [[ ! -L "$HOME/.bashrc" ]]; then
    echo "⚠️  ~/.bashrc is not a symlink (expected → $DOTFILES/.bashrc)"
    echo "   Fix: ln -sf $DOTFILES/.bashrc ~/.bashrc"
    (( _issues++ ))
  elif [[ ! -e "$HOME/.bashrc" ]]; then
    echo "⚠️  ~/.bashrc symlink is broken"
    echo "   Fix: ln -sf $DOTFILES/.bashrc ~/.bashrc"
    (( _issues++ ))
  fi

  # ~/.zshenv must exist (symlink or regular file — both are valid)
  if [[ ! -f "$HOME/.zshenv" ]]; then
    echo "⚠️  ~/.zshenv is missing — dotfiles env won't load"
    echo "   Fix: ln -s $DOTFILES/.zshenv ~/.zshenv (or copy it)"
    (( _issues++ ))
  fi

  # Dotfiles repo itself
  if [[ ! -d "$DOTFILES/.git" ]]; then
    echo "⚠️  Dotfiles repo not found at $DOTFILES"
    echo "   Fix: git clone git@github.com:Pontuzz/dotfiles-starter.git $DOTFILES"
    (( _issues++ ))
  fi

  if (( _issues > 0 )); then
    echo "🔧 $_issues dotfiles issue(s) found — see above"
  fi
}
_dotfiles_check_links

# ── Zcompdump Rotation ────────────────────────────────────────────────────────
# Prunes stale completion cache files. Runs at most once per day.
_zcompdump_rotate() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local stamp_file="$cache_dir/.zcompdump_rotate_stamp"
  local today="${(%):-%D{%Y%m%d}}"

  # Only run once per day
  if [[ -f "$stamp_file" ]]; then
    local last_run
    last_run=$(<"$stamp_file")
    [[ "$last_run" == "$today" ]] && return
  fi

  # Prune all but the newest .zcompdump in the cache dir
  local -a dumps
  dumps=("$cache_dir"/.zcompdump*(N.om))
  if (( ${#dumps} > 1 )); then
    rm -f "${dumps[@]:1}"
  fi

  # Also clean any stray dumps left in ZDOTDIR (legacy location)
  dumps=("$ZDOTDIR"/.zcompdump*(N.om))
  if (( ${#dumps} > 1 )); then
    rm -f "${dumps[@]:1}"
  fi

  # Ensure cache directory exists, then update stamp
  mkdir -p "$cache_dir"
  print -r -- "$today" >| "$stamp_file"
}
_zcompdump_rotate

# ── Tool Availability Check ────────────────────────────────────────────────────
# Lists missing optional tools once per day. Silent when all present.
# Suppress specific tools via DOTFILES_IGNORE_MISSING_TOOLS in 99-local.zsh.
_dotfiles_check_tools() {
  local _cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local _stamp="$_cache/.tool_check_stamp"
  local _today="${(%):-%D{%Y%m%d}}"

  # Only run once per day
  if [[ -f "$_stamp" ]]; then
    local _last; _last=$(<"$_stamp")
    [[ "$_last" == "$_today" ]] && return
  fi

  local -a _missing
  local _tool

  # Build ignore list from DOTFILES_IGNORE_MISSING_TOOLS (set in 99-local.zsh)
  local -a _ignore
  if [[ -n "$DOTFILES_IGNORE_MISSING_TOOLS" ]]; then
    _ignore=(${(s: :)DOTFILES_IGNORE_MISSING_TOOLS})
  fi

  # Tools that the dotfiles config wraps or aliases
  for _tool in fzf zoxide bat lsd eza rg thefuck navi; do
    if ! command -v "$_tool" >/dev/null 2>&1; then
      if (( ${_ignore[(Ie)$_tool]} )); then
        continue
      fi
      _missing+=("$_tool")
    fi
  done

  if (( ${#_missing} > 0 )); then
    local -A _pkg_names
    _pkg_names=(
      rg        ripgrep
      fzf       fzf
      zoxide    zoxide
      bat       bat
      lsd       lsd
      eza       eza
      thefuck   thefuck
      navi      navi
    )
    local -a _display
    for _tool in "${_missing[@]}"; do
      _display+=("${_pkg_names[$_tool]:-$_tool}")
    done
    echo "💡 Optional tools not found: ${(j:, :)_display}"
    echo "   Install: brew install ${_display[*]}"
    echo "   (or use apt/pacman — see each tool's docs)"
  fi

  mkdir -p "$_cache"
  print -r -- "$_today" >| "$_stamp"
}
_dotfiles_check_tools
