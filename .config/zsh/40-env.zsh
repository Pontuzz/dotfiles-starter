#!/usr/bin/env zsh
# Non-sensitive environment variables
export EDITOR=nano
export VISUAL="$EDITOR"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
export FZF_DEFAULT_OPTS="--height 70% --reverse --inline-info --cycle"
export DOTNET_ROOT="$HOME/.dotnet"

# Dotfiles repo path (override in 99-local.zsh if cloned elsewhere)
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# ── Clean Windows PATH entries (WSL) ──
# WSL inherits the full Windows PATH (~66 entries), most of which are app-specific
# noise (Razer, NVIDIA, Steam, etc.) that nobody calls from WSL.
# We strip those and keep only the ones actually useful from the Linux side.
# Whitelist: system32, WindowsApps, PowerShell, scoop, npm, VS Code, dotnet, Git
if [[ -n "$WT_SESSION" ]]; then
  typeset -a _clean_path
  for _p in "${(@s/:/)PATH}"; do
    case "$_p" in
      /mnt/[a-z]/*)
        case "$_p" in
          # Keep entries that are genuinely useful from WSL
          */WINDOWS/system32|*/WINDOWS|*/WINDOWS/*)                _clean_path+=("$_p") ;;
          */WindowsApps|*/Microsoft\ VS\ Code/bin|*/PowerShell/7*)  _clean_path+=("$_p") ;;
          */scoop/*|*/npm|*/Roaming/npm*)                           _clean_path+=("$_p") ;;
          */Git/cmd|*/dotnet/*|*/Warp/bin)                          _clean_path+=("$_p") ;;
          */OpenSSH*)                                               _clean_path+=("$_p") ;;
          # Drop everything else (Razer, NVIDIA, Steam, Python, Perl, winget packages, etc.)
        esac
        ;;
      *)
        _clean_path+=("$_p")
        ;;
    esac
  done
  export PATH="${(j/:/)_clean_path}"
  unset _clean_path _p
fi
