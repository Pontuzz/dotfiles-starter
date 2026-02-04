#!/usr/bin/env bash
# Tool initialization for Bash

# Homebrew on Linux (Linuxbrew)
if command -v brew &>/dev/null; then
    eval "$(brew shellenv bash)"
fi

# zoxide - smart cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# fzf - fuzzy finder
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
    export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.*'"
fi

# atuin - shell history
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash)"
fi
