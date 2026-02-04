#!/usr/bin/env bash
# Environment variables for Bash

export EDITOR="nano"
export VISUAL="nano"
export PAGER="less"

# XDG compliance
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"

# Language settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Tools
if command -v nvim &>/dev/null; then
    export EDITOR="nvim"
    export VISUAL="nvim"
elif command -v vim &>/dev/null; then
    export EDITOR="vim"
    export VISUAL="vim"
fi
