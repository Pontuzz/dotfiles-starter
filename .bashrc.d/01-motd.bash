#!/usr/bin/env bash
# Custom MOTD (Message of the Day) for Bash and Zsh
# Sources user-level MOTD files

# Get config directory (works in both bash and zsh)
CONFIG_DIR="${XDG_CONFIG_HOME:=$HOME/.config}"
MOTD_DIR="$CONFIG_DIR/motd"

# Only show once per session
if [[ -z "$MOTD_SHOWN" ]]; then
    export MOTD_SHOWN=1
    
    if [[ -d "$MOTD_DIR" ]]; then
        # Source all motd files in order
        for motd_file in "$MOTD_DIR"/{00,10,20,30,40,50}-*.sh; do
            [[ -f "$motd_file" && -x "$motd_file" ]] && source "$motd_file"
        done
    fi
fi
