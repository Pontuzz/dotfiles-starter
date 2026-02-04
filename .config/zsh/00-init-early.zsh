#!/usr/bin/env zsh
# Early initialization - must run before instant prompt
# Platform-aware and non-breaking across different systems

# Display MOTD (once per session)
if [[ -z "$MOTD_SHOWN" ]]; then
    export MOTD_SHOWN=1
    MOTD_DIR="${XDG_CONFIG_HOME:=$HOME/.config}/motd"
    if [[ -d "$MOTD_DIR" ]]; then
        for motd_file in "$MOTD_DIR"/{00,10,20,30,40,50}-*.sh; do
            [[ -f "$motd_file" && -x "$motd_file" ]] && source "$motd_file"
        done
    fi
fi

# Auto-start Zellij in Windows Terminal (WSL-specific)
if [[ -n "$WT_SESSION" ]] && command -v zellij >/dev/null 2>&1; then 
    eval "$(zellij setup --generate-auto-start zsh)"
fi

# SSH keychain setup (graceful fallback if not available)
# Machine-specific setup should be in 99-local.zsh
if command -v keychain >/dev/null 2>&1; then
    # Only on systems where keychain is configured
    # Default keychain setup moved to 99-local.zsh for portability
    : # Placeholder - actual setup in machine-specific config
fi

# Enable Powerlevel10k instant prompt
# Should stay close to the top of .zshrc
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
