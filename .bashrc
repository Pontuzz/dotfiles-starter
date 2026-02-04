#!/usr/bin/env bash
# Modular Bash Configuration
# Portable across WSL2, Linux, macOS, and Raspberry Pi

# If not running interactively, source only minimal config
case $- in
    *i*) ;;
      *) return;;
esac

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"

# History settings
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Append to history file, don't overwrite
shopt -s checkwinsize
shopt -s expand_aliases

# Load modular config files in order
BASHRC_DIR="${XDG_CONFIG_HOME}/bash"

# Source files in order of precedence
if [[ -d "$BASHRC_DIR" ]]; then
    # Load modules in numerical order
    for config in "$BASHRC_DIR"/{00,10,20,30,40,50,60,70,80,90}-*.bash; do
        [[ -f "$config" ]] && source "$config"
    done
    
    # Load machine-specific config last (gitignored)
    [[ -f "$BASHRC_DIR/99-local.bash" ]] && source "$BASHRC_DIR/99-local.bash"
fi
