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

# ============================================================================
# Git hooks — auto-configure shared hooks for dotfiles repo
# Ensures submodules stay in sync after git pull on any machine
# ============================================================================
if [[ -d "$DOTFILES/.git" ]]; then
  local _hooks
  _hooks=$(git -C "$DOTFILES" config --get core.hooksPath 2>/dev/null || true)
  if [[ "$_hooks" != "$DOTFILES/hooks" ]]; then
    git -C "$DOTFILES" config core.hooksPath "$DOTFILES/hooks"
  fi
  unset _hooks
fi

# ============================================================================
# Symlink health check — warns if critical dotfiles symlinks are missing/broken
# Silent when healthy; only prints actionable messages on problems
# ============================================================================
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
    echo "   Fix: git clone git@github.com:Pontuzz/dotfiles.git $DOTFILES"
    (( _issues++ ))
  fi

  if (( _issues > 0 )); then
    echo "🔧 $_issues dotfiles issue(s) found — see above"
  fi
}
_dotfiles_check_links

# ============================================================================
# Zcompdump rotation — prunes stale completion cache files
# Runs at most once per day to avoid slowdown on every shell start
# ============================================================================
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
