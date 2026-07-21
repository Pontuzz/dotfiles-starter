#!/usr/bin/env zsh
# Optional integrations — each guarded with existence checks
# Extracted from .zshrc for cleaner separation.
# ============================================================================

# ── Git Hooks Auto-Configuration ──────────────────────────────────────────────
# Ensures submodules stay in sync after git pull on any machine.
# Runs exactly once — subsequent starts are instant.
if [[ -d "$DOTFILES/.git" ]]; then
  local _stamp="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.dotfiles_hooks_stamp"
  if [[ ! -f "$_stamp" ]]; then
    git -C "$DOTFILES" config core.hooksPath "$DOTFILES/hooks"
    mkdir -p "$(dirname "$_stamp")"
    touch "$_stamp"
  fi
  unset _stamp
fi

# ── Warp Terminal Integration ─────────────────────────────────────────────────
# Informs Warp of shell readiness for its UI features.
if [[ -n "$WT_SESSION" ]]; then
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'
fi
