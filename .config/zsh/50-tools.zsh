#!/usr/bin/env zsh
# Tool and environment initializations
# Gracefully handles missing tools - doesn't break if not installed
# Portable across all platforms

# Brew initialization (works on both Linux Linuxbrew and macOS)
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
  # Brew alias to avoid pyenv conflicts
  alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
fi

# Zoxide (z command) - modern cd replacement
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Atuin (history search) - optional, won't break if missing
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# Navi (interactive cheatsheet) - lightweight and optional
if command -v navi >/dev/null 2>&1; then
  eval "$(navi widget zsh)"
fi

# TheFuck (command correction) - optional but useful
if command -v thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
  eval $(thefuck --alias FUCK)
fi

# FZF (fuzzy finder) - already sourced in .zshenv but ensure keybindings
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

