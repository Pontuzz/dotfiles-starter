#!/usr/bin/env zsh
# Oh My Zsh and plugin initialization

export ZSH="$HOME/.config/zsh/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH_CUSTOM="$HOME/.config/zsh/custom"

# Plugin list organized by category
# All custom plugins + standard Oh My Zsh plugins
plugins=(
  # Core functionality
  git
  # Custom working plugins
  lazy-loader
  performance-monitor
  my-alias
  my-ssh
  # Visual enhancements
  zsh-syntax-highlighting
  zsh-bat
  zsh-lsd
  # Navigation & search
  fzf
  fzf-dir-navigator
  zsh-autosuggestions
  # Productivity
  taskwarrior
  thefuck
  vscode
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Completion and zstyle configuration
autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' ignore-patterns '*.exe'
zstyle ':completion:*:ssh:*' hosts on
zstyle ':completion:*:ssh:*' tag-order hosts users
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:commands' ignored-patterns '/mnt/c/*'

# Oh My Zsh settings
zstyle ':omz:update' frequency 13
HIST_STAMPS="dd/mm/yyyy"
