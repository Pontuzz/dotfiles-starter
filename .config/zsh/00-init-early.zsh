#!/usr/bin/env zsh
# Early initialization - must run before instant prompt
# Platform-aware and non-breaking across different systems

# Ensure DOTFILES is set early (40-env.zsh sets it too but runs after this)
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# ── Detect if Zellij will auto-start (WSL Windows Terminal) ──
# Used to decide whether to show MOTD in the outer shell (it'd be eaten)
local _zellij_will_start=false
if [[ -n "$WT_SESSION" ]] && command -v zellij >/dev/null 2>&1 && [[ -z "$ZELLIJ" ]]; then
    _zellij_will_start=true
fi

# ── Display MOTD ──
# Strategy:
#   - Outside Zellij (SSH, etc.): show MOTD every time   (DF_MOTD_SHOWN tracked)
#   - Inside Zellij: show MOTD once per 6h per session   (stamp with mtime check)
#   - When Zellij will start (outer WSL shell): suppress  (would be eaten)
# Uses DF_MOTD_SHOWN (not MOTD_SHOWN) to avoid collision with PAM pam_motd
# This is NOT exported — each Zellij pane evaluates independently.
if [[ -z "$DF_MOTD_SHOWN" ]]; then
    # Suppress in outer shell if Zellij will take over
    if ! $_zellij_will_start; then
        local _show_motd=true

        # If inside Zellij, show MOTD at most once per 6h per session
        # Uses stamp file mtime for cooldown tracking
        if [[ -n "$ZELLIJ" ]]; then
            local _stamp_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zellij-motd"
            local _stamp="$_stamp_dir/${ZELLIJ_SESSION_NAME}"
            if [[ -f "$_stamp" ]]; then
                local _age=$(( $(date +%s) - $(date -r "$_stamp" +%s) ))
                (( _age > 21600 )) || _show_motd=false
            fi
        fi

        if $_show_motd; then
            typeset -a _motd_scripts

            # 1. User's local MOTD scripts (~/.config/motd/)
            _motd_local="${XDG_CONFIG_HOME:-$HOME/.config}/motd"
            if [[ -d "$_motd_local" ]]; then
                _motd_scripts=( "$_motd_local"/[0-9][0-9]-*.sh(N) )
                for _motd_file in "${_motd_scripts[@]}"; do
                    [[ -f "$_motd_file" && -x "$_motd_file" ]] && source "$_motd_file"
                done
            fi

            # 2. Shared dotfiles MOTD scripts (~/dotfiles/.config/motd/)
            if [[ -d "$DOTFILES/.config/motd" ]]; then
                _motd_scripts=( "$DOTFILES/.config/motd"/[0-9][0-9]-*.sh(N) )
                for _motd_file in "${_motd_scripts[@]}"; do
                    [[ -f "$_motd_file" && -x "$_motd_file" ]] && source "$_motd_file"
                done
            fi

            unset _motd_scripts _motd_local _motd_file

            # Create/update stamp if inside Zellij (mtime tracks last MOTD shown)
            if [[ -n "$ZELLIJ" ]]; then
                mkdir -p "${_stamp_dir}"
                touch "$_stamp"
                unset _stamp_dir _stamp
            fi
        fi

        # Mark shown in current shell (prevent repeat if .zshrc reloaded)
        # Inside Zellij: local only (sibling panes check stamp independently)
        # Outside Zellij: exported (child shells inherit)
        if [[ -n "$ZELLIJ" ]]; then
            DF_MOTD_SHOWN=1
        else
            export DF_MOTD_SHOWN=1
        fi
    fi
fi
unset _zellij_will_start

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
