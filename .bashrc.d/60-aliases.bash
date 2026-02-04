#!/usr/bin/env bash
# Portable Bash aliases

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -CF'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Better alternatives if available
command -v lsd &>/dev/null && alias ls='lsd' && alias ll='lsd -lh' && alias la='lsd -lah'
command -v bat &>/dev/null && alias cat='bat'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
