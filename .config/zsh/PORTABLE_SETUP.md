# Portable Zsh Configuration — Reference Guide

**Quick setup:** `~/dotfiles/setup.sh` — one command, auto-detects your distro, handles everything.

This guide covers architecture, platform detection, file structure, and machine-specific config. For actual installation, use `setup.sh` (see [README.md Quick Start](../../README.md#-quick-start)).

---

## Setup Overview

Your zsh configuration is **portable across WSL, Linux, macOS, and Raspberry Pi**. The `setup.sh` script handles installation automatically:

```bash
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
~/dotfiles/setup.sh
```

**What setup.sh does:**
1. Clones/updates the repo and inits submodules
2. Backs up existing config files
3. Creates symlinks: `.zshenv`, `.bashrc`, `.profile`, `.gitconfig`, `.config/zsh`
4. Installs required dependencies (zsh, git, curl) via your distro's package manager
5. Installs optional tools: fzf, zoxide, bat, ripgrep, jq, lsd
6. Changes your default shell to zsh
7. Detects bundled OMZ — avoids redundant system install

**Flags:**
- `--check` — Read-only preview, no changes
- `--minimal` — Skip optional tools, just shell + symlinks

### What setup.sh DOESN'T do (you do these once per machine)

```bash
# 1. Set up Git config with your identity
cp ~/dotfiles/.gitconfig.example ~/.gitconfig
nano ~/.gitconfig  # Add your name and email

# SSH config - for host management and credentials
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp ~/dotfiles/.ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
# Add your SSH hosts (work servers, Pi, etc.)
```

### 2. Create machine-specific config
```bash
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
nano ~/.config/zsh/99-local.zsh
```

### 3. (Optional) Set up custom MOTD
```bash
cp ~/.config/motd/20-custom.sh.example ~/.config/motd/20-custom.sh
chmod +x ~/.config/motd/20-custom.sh
nano ~/.config/motd/20-custom.sh
```

## File Structure

```
~/.config/zsh/
├── .zshrc                    # Main config file (sources everything else in order)
├── .p10k.zsh                 # Powerlevel10k prompt config
├── .oh-my-zsh/               # Oh My Zsh installation (submodule)
├── 00-init-early.zsh         # Early init (instant prompt, zellij, keychain)
├── 20-machine-detect.zsh     # Platform detection (WSL, Linux, macOS, ARM, Pi)
├── plugins.zsh               # Oh My Zsh plugins and completion setup
├── 40-env.zsh                # Environment variables
├── 50-tools.zsh              # Tool initializations (brew, zoxide, fzf, etc.)
├── aliases.zsh               # Portable aliases (cross-platform)
├── functions.zsh             # Custom functions and helpers
├── 99-local.zsh              # Machine-specific config (GITIGNORED - copy from .example)
├── 99-local.zsh.example      # Template for machine-specific config
└── custom/                   # Custom plugins and themes
    ├── plugins/              # Custom and external plugins
    │   ├── lazy-loader/      # Custom: Lazy loading for heavy tools
    │   ├── performance-monitor/ # Custom: Performance monitoring
    │   ├── fzf-dir-navigator/   # Submodule: Directory fuzzy finder
    │   ├── zsh-autosuggestions/ # Submodule: Command suggestions
    │   ├── zsh-syntax-highlighting/ # Submodule: Syntax highlighting
    │   ├── zsh-bat/          # Submodule: Better cat with bat
    │   └── zsh-lsd/          # Submodule: Better ls with lsd
    └── themes/
        └── powerlevel10k/    # Submodule: Beautiful prompt theme
```

## Platform Detection

The config automatically detects your platform and sets environment flags in `20-machine-detect.zsh`:

```bash
# OS/Architecture Detection
IS_WSL=true/false         # Windows Subsystem for Linux
IS_LINUX=true/false       # Any Linux system
IS_MACOS=true/false       # macOS
IS_ARM=true/false         # ARM architecture (Raspberry Pi, Apple Silicon)

# Machine-Specific Detection (hostname-based)
MACHINE_TYPE=string       # "workstation", "server", "raspberry_pi", or "generic"
IS_RASPBERRY_PI=true/false      # If hostname contains "raspberrypi"
```

You can use these flags in `99-local.zsh` for conditional setup based on your machine.

## Machine-Specific Configuration

Use `~/.config/zsh/99-local.zsh` for:
- **Machine-specific aliases** (internal IPs, work tools, device addresses)
- **SSH key management** (keychain setup)
- **Local environment variables**
- **Secrets and credentials** (API keys, tokens - kept in `.gitignore`)

Example:
```bash
# ~/.config/zsh/99-local.zsh (GITIGNORED - safe for secrets)

# Workstation setup
if [[ "$MACHINE_TYPE" == "workstation" ]]; then
  keychain ~/.ssh/id_rsa --agents ssh -q
  alias devbox='ssh dev.internal'
  alias deploy='./deploy.sh'
fi

# Raspberry Pi setup
if [[ "$MACHINE_TYPE" == "raspberry_pi" ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
  alias piclean='sudo apt autoremove && sudo apt autoclean'
fi

# Generic machine setup
if [[ "$MACHINE_TYPE" == "generic" ]]; then
  # Your default machine settings
  echo "Running on generic machine $(hostname)"
fi

# Personal/private settings (all machines)
export GITHUB_TOKEN="your_token_here"  # If needed
export CUSTOM_API_KEY="secret_value"   # Your secrets
alias myrepo='cd /path/to/my/repo'
```

## Portable Features

✅ **Works everywhere:**
- Aliases (portable ones in `aliases.zsh`)
- Oh My Zsh plugins
- Powerlevel10k theme (needs font installation on each machine)
- FZF, Zoxide, Atuin integrations
- History and completion settings

✅ **Gracefully handles missing tools:**
- If `brew` is not installed → skipped
- If `fzf` is not installed → skipped
- If `keychain` is not installed → skipped
- Tools are checked with `command -v` before use

✅ **Platform-aware:**
- WSL Windows paths (`/mnt/w/`, `/mnt/g/`) only on WSL
- Linuxbrew paths only if Linuxbrew is installed
- SSH agent sockets auto-detected
- Zellij only auto-starts in Windows Terminal

## Tested On

- ✅ **WSL2 (Ubuntu)** — Fully tested and working
- ✅ **Debian 13 (trixie, arm64/armhf)** — setup.sh verified on Raspberry Pi 3
- ✅ **Raspberry Pi OS** — Fully tested and working
- ✅ **Arch Linux** — setup.sh detects pacman
- ✅ **Fedora** — setup.sh detects dnf
- ⚠️ **macOS** — setup.sh detects brew, should work (untested on current version)

If you test on a new platform, please report any issues!

## Troubleshooting

### Config doesn't load on startup
```bash
# Test loading with verbose output
zsh -c "source ~/.zshenv && source ~/.config/zsh/.zshrc && echo 'OK'"

# Or see what errors occur
exec zsh 2>&1 | head -20
```

### Zsh theme (Powerlevel10k) looks broken
```bash
# This usually means you need to install Powerlevel10k fonts
# Download and install from: https://github.com/romkatv/powerlevel10k#fonts
# After installing, your prompt should look correct

# Or temporarily disable Powerlevel10k in 00-init-early.zsh
```

### Platform detection not working correctly
```bash
# Check what platform was detected
zsh -c "source ~/.config/zsh/20-machine-detect.zsh && \
  echo 'WSL='$IS_WSL' LINUX='$IS_LINUX' MACOS='$IS_MACOS' ARM='$IS_ARM' MACHINE='$MACHINE_TYPE"
```

### Tool not initializing (fzf, brew, zoxide, etc.)
```bash
# Check if the tool is installed and available
command -v fzf       # Check fzf
command -v zoxide    # Check zoxide
command -v brew      # Check brew
command -v atuin     # Check atuin

# If not found, install it:
# - Ubuntu/Debian: sudo apt install <package>
# - macOS: brew install <package>
# - Arch: sudo pacman -S <package>
```

### Submodules are empty (Oh My Zsh or plugins missing)
```bash
# If custom/plugins or .oh-my-zsh directories are empty:
cd ~/dotfiles
git submodule update --init --recursive

# Check submodule status
git submodule status
```

**Tip:** After the first fix, the post-merge hook (`hooks/post-merge`) runs automatically on every `git pull`, so submodules stay in sync from then on.

### Missing .gitignore entry
Add to `.gitignore`:
```
.config/zsh/99-local.zsh
.config/secrets/
```

## After Running setup.sh

After `setup.sh` completes, do these once per machine:

1. **Set up your identity in Git:**
   ```bash
   cp ~/dotfiles/.gitconfig.example ~/.gitconfig
   nano ~/.gitconfig   # Add your name and email
   ```

2. **Configure machine-specific settings:**
   ```bash
   cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
   nano ~/.config/zsh/99-local.zsh
   ```

3. **Install Powerlevel10k fonts** (for prompt icons to render correctly):
   - [Meslo Nerd Font](https://github.com/romkatv/powerlevel10k#fonts) (recommended)
   - Or configure `.p10k.zsh` to use your system font

4. **Restart your shell:**
   ```bash
   exec zsh
   ```

## Notes

- `99-local.zsh` is in `.gitignore` — safe for machine-specific settings and secrets
- Use `99-local.zsh.example` as a template
- All tool initializations check for `command -v` before use — missing tools won't break anything
- Configuration is modular: remove files you don't need
- History is shared across all shells (SHARE_HISTORY option in plugins.zsh)
