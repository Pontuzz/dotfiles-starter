#!/usr/bin/env zsh

# ============================================================================
# Modular Zsh Configuration — Orchestrator
# ============================================================================
# Sources split config files in a specific order.
# Portable across WSL, Linux, macOS, and Raspberry Pi.
# ============================================================================

# Startup timer — must be first for accurate measurement
zmodload zsh/datetime 2>/dev/null
typeset _dotfiles_start=$EPOCHREALTIME

# ── Configuration Modules ─────────────────────────────────────────────────────
# Each file handles one concern. Guarded with -f so missing files are silent.

# 0. Platform detection (sets IS_WSL, IS_LINUX, MACHINE_TYPE, etc.)
[ -f "$ZDOTDIR/10-machine-detect.zsh" ] && source "$ZDOTDIR/10-machine-detect.zsh"

# 1. Early init (MOTD, Zellij auto-start, p10k instant prompt)
[ -f "$ZDOTDIR/20-init-early.zsh" ] && source "$ZDOTDIR/20-init-early.zsh"

# 2. Oh My Zsh and plugin loading
[ -f "$ZDOTDIR/30-plugins.zsh" ] && source "$ZDOTDIR/30-plugins.zsh"

# 3. Environment variables
[ -f "$ZDOTDIR/40-env.zsh" ] && source "$ZDOTDIR/40-env.zsh"

# 4. Tool initializations (brew, zoxide, fzf, atuin, navi, thefuck, fnm)
[ -f "$ZDOTDIR/50-tools.zsh" ] && source "$ZDOTDIR/50-tools.zsh"

# 5. Diagnostics — health checks, tool verification, cache maintenance
[ -f "$ZDOTDIR/55-diagnostics.zsh" ] && source "$ZDOTDIR/55-diagnostics.zsh"

# 6. Optional integrations (Warp, git hooks, keychain)
[ -f "$ZDOTDIR/57-integrations.zsh" ] && source "$ZDOTDIR/57-integrations.zsh"

# 7. Aliases
[ -f "$ZDOTDIR/80-aliases.zsh" ] && source "$ZDOTDIR/80-aliases.zsh"

# 8. Functions (portable helpers)
[ -f "$ZDOTDIR/85-functions.zsh" ] && source "$ZDOTDIR/85-functions.zsh"

# 9. Machine-specific override (gitignored — secrets, infra, local settings)
[ -f "$ZDOTDIR/99-local.zsh" ] && source "$ZDOTDIR/99-local.zsh"

# ── Core Settings ─────────────────────────────────────────────────────────────

# History — XDG-compliant, deduplicated, shared across shells
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/history/zsh/.zsh_history"
[[ ! -d "$(dirname "$HISTFILE")" ]] && mkdir -p "$(dirname "$HISTFILE")"
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# Performance and behavior
setopt NO_BEEP
setopt AUTO_CD
setopt GLOB_COMPLETE
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# SSH agent via keychain
[[ -f ~/.keychain/$HOST-sh ]] && source ~/.keychain/$HOST-sh

# Powerlevel10k prompt
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# ── Startup Timer Guard ───────────────────────────────────────────────────────
# Warns if total shell init exceeds 3 seconds. Silent when healthy.
local _elapsed=$(( EPOCHREALTIME - _dotfiles_start ))
if (( _elapsed > 3.0 )); then
  printf "⚠️  Shell startup took %.1fs — check for slow plugins or tools\n" $_elapsed
fi
unset _dotfiles_start
