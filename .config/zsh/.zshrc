#!/usr/bin/env zsh

# ============================================================================
# Modular Zsh Configuration
# ============================================================================
# This file sources split config files in a specific order for proper
# initialization, especially important for prompt and tool loading.
# Designed to be portable across WSL, Linux, macOS, and Raspberry Pi.
# ============================================================================

# 0. Machine detection (platform and hostname-based flags)
[ -f "$ZDOTDIR/20-machine-detect.zsh" ] && source "$ZDOTDIR/20-machine-detect.zsh"

# 1. Early initialization (instant prompt, keychain, zellij)
# Must run early but after machine detection
[ -f "$ZDOTDIR/00-init-early.zsh" ] && source "$ZDOTDIR/00-init-early.zsh"

# 2. Oh My Zsh and plugin loading
[ -f "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh"

# 3. Environment variables
[ -f "$ZDOTDIR/40-env.zsh" ] && source "$ZDOTDIR/40-env.zsh"

# 4. Tool initializations (brew, zoxide, fzf, atuin, etc.)
[ -f "$ZDOTDIR/50-tools.zsh" ] && source "$ZDOTDIR/50-tools.zsh"

# 5. Aliases (extracted from my-alias plugin)
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# 6. Functions and additional setup
[ -f "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"

# 7. Machine-specific or secret settings (should be gitignored)
[ -f "$ZDOTDIR/99-local.zsh" ] && source "$ZDOTDIR/99-local.zsh"

# ============================================================================
# Core settings (kept here for visibility)
# ============================================================================

# History settings - optimized for performance
HISTSIZE=50000
SAVEHIST=50000
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

# Performance options
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

# ============================================================================
# SSH and additional setup
# ============================================================================

# Source keychain for SSH agent management
[[ -f ~/.keychain/$HOST-sh ]] && source ~/.keychain/$HOST-sh

# Powerlevel10k prompt configuration
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# ============================================================================
# Optional integrations (guard with existence checks)
# ============================================================================

# Greeting/motd if available
if [[ -f "$HOME/hive/zsh/.config/mygreeting.sh" ]]; then
  source "$HOME/hive/zsh/.config/mygreeting.sh"
fi

# WARP shell integration
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
