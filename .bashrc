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
HISTFILE="$HOME/.local/share/history/bash/.bash_history"
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Append to history file, don't overwrite
shopt -s checkwinsize
shopt -s expand_aliases

# Dotfiles repo path
DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# Load modular config files from dotfiles repo
if [[ -d "$DOTFILES/.bashrc.d" ]]; then
    # Load modules in numerical order
    for config in "$DOTFILES/.bashrc.d"/{00,10,20,30,40,50,60,70,80,90}-*.bash; do
        [[ -f "$config" ]] && source "$config"
    done
    
    # Load machine-specific config last (gitignored)
    [[ -f "$DOTFILES/.bashrc.d/99-local.bash" ]] && source "$DOTFILES/.bashrc.d/99-local.bash"
fi
