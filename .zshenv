#!/usr/bin/env zsh
# XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Python history (keep out of home dir)
export PYTHON_HISTORY="${PYTHON_HISTORY:-$XDG_STATE_HOME/python_history}"

# ============================================================================
# PATH setup using zsh `path` array with deduplication
# Platform-aware and portable across WSL, Linux, macOS, and Raspberry Pi
# ============================================================================
typeset -U path

# Essential paths - universal
path=(
  "$HOME/.cargo/bin"
  "$HOME/.config/emacs/bin"
  "$HOME/.local/bin"
  "$PYENV_ROOT/bin"
  $path
)

# WSL-specific: Export PATH first, then filter Windows paths
export PATH

# ============================================================================
# Windows path filtering (WSL-specific)
# Remove any Windows paths that can cause WSL translation errors
# ============================================================================
if grep -qi microsoft /proc/version 2>/dev/null; then
  old_IFS="$IFS"
  IFS=':'
  filtered=""
  for p in $PATH; do
    # Skip Windows-style paths (backslashes or drive letters)
    if [[ "$p" == *\\* ]] || [[ "$p" == [A-Za-z]:\\* ]]; then
      continue
    fi
    # Skip /mnt/* Windows drive paths (too noisy)
    if [[ "$p" == /mnt/[a-z]/* ]] || [[ "$p" == /mnt/[a-z] ]]; then
      continue
    fi
    # Keep Linux native paths (including /home/linuxbrew)
    filtered="${filtered:+$filtered:}$p"
  done
  IFS="$old_IFS"
  PATH="$filtered"
fi

# ============================================================================
# Add Homebrew and tool paths (preserved after filtering)
# ============================================================================
# Homebrew paths (works on Linux via Linuxbrew and on macOS)
if [[ -d "/home/linuxbrew/.linuxbrew/bin" ]]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

if [[ -d "/home/linuxbrew/.linuxbrew/sbin" ]]; then
  PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
fi

# FZF binary path (if fzf was installed to custom location)
if [[ -d "$HOME/.config/fzf/bin" ]]; then
  PATH="$HOME/.config/fzf/bin:$PATH"
fi

export PATH

# ============================================================================
# SSH Agent Configuration (portable)
# ============================================================================
# systemd ssh-agent socket (Linux with systemd)
if [ -n "$XDG_RUNTIME_DIR" ] && [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# ============================================================================
# Optional environment helper scripts
# ============================================================================
if [ -x "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
