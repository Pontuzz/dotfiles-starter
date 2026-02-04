# Portable Zsh Configuration Setup Guide

**For complete setup instructions, see [README.md Quick Start section](../../README.md#-quick-start) (lines 52-116).**

This guide provides additional context and details for the setup process. If you're setting up this dotfiles repo on a new machine, follow the steps in README.md first, then refer to this guide for explanations.

---

## Setup Overview

Your zsh configuration is **portable across WSL, Linux, macOS, and Raspberry Pi**. The setup process has 6 main steps:

## Quick Setup on New Machine

### 1. Clone the dotfiles repo (WITH submodules!)
```bash
# Clone with --recursive flag to get all submodules
git clone --recursive https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles
```

**Important**: The `--recursive` flag is essential because the config uses git submodules for:
- Oh My Zsh framework
- External plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-dir-navigator, etc.)
- Powerlevel10k theme

If you forgot `--recursive`:
```bash
cd ~/dotfiles
git submodule update --init --recursive
```

### 2. Create symlinks (or copy files)
```bash
# Symlink approach (recommended)
ln -s ~/dotfiles/.zshenv ~/.zshenv
ln -s ~/dotfiles/.config/zsh ~/.config/zsh

# Or copy if symlinks don't work on your system
cp -r ~/dotfiles/.config/zsh ~/.config/zsh
cp ~/dotfiles/.zshenv ~/.zshenv
```

### 3. Set up Git and SSH config (optional but recommended)
```bash
# Git config - for version control credentials
cp ~/dotfiles/.gitconfig.example ~/.gitconfig
nano ~/.gitconfig
# Add your name, email, and any machine-specific Git settings

# SSH config - for host management and credentials
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp ~/dotfiles/.ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
# Add your SSH hosts (work servers, Pi, etc.)
```

### 4. Set up machine-specific Zsh config
```bash
# Copy the example local config
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh

# Edit it with your machine-specific settings
nano ~/.config/zsh/99-local.zsh
```

### 5. Set up custom MOTD (optional)
```bash
# Copy the example custom message file
cp ~/.config/motd/20-custom.sh.example ~/.config/motd/20-custom.sh

# Edit to add your own messages
nano ~/.config/motd/20-custom.sh

# Make it executable
chmod +x ~/.config/motd/20-custom.sh
```

### 6. Restart your shell
```bash
exec zsh
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
    │   ├── my-alias/         # Custom: Alias management
    │   ├── my-ssh/           # Custom: SSH setup
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
MACHINE_TYPE=string       # "hivenet_client", "raspberry_pi", or "generic"
IS_HIVENET_CLIENT=true/false    # If hostname starts with HC01-D
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

# HiveNet Client setup
if [[ "$MACHINE_TYPE" == "hivenet_client" ]] || [[ "$IS_HIVENET_CLIENT" == true ]]; then
  keychain ~/.ssh/id_rsa --agents ssh -q
  alias [internal-tool]='telnet [your-internal-ip] 3335'
  alias avdump='dotnet /mnt/g/path/to/avdump2'
fi

# Raspberry Pi setup
if [[ "$MACHINE_TYPE" == "raspberry_pi" ]] || [[ "$IS_RASPBERRY_PI" == true ]]; then
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

- ✅ **WSL2 (Ubuntu)** - Fully tested and working
- ✅ **Raspberry Pi 3 (Raspbian/Debian)** - Fully tested and working
- ⚠️ **macOS** - Should work but untested on current version
- ⚠️ **Generic Linux** - Should work but untested on current version

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

### Missing .gitignore entry
Add to `.gitignore`:
```
.config/zsh/99-local.zsh
.config/secrets/
```

## Next Steps

1. **Install required tools** (optional but recommended):
   ```bash
   # On Linux/WSL with apt
   sudo apt install zsh fzf ripgrep bat

   # On macOS
   brew install zsh fzf ripgrep bat

   # On Pi with apt
   sudo apt install zsh fzf ripgrep bat
   ```

2. **Install Oh My Zsh** (if not already cloned):
   ```bash
   git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.config/zsh/.oh-my-zsh
   ```

3. **Install custom plugins** (if not in repo):
   ```bash
   cd ~/.config/zsh/custom/plugins
   git clone https://github.com/zsh-users/zsh-autosuggestions.git
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
   ```

4. **Install Powerlevel10k fonts** (for prompt to look right):
   - Download from: https://github.com/romkatv/powerlevel10k#manual-font-installation
   - Or use system fonts and update `.p10k.zsh`

5. **Set up machine-specific config** in `99-local.zsh`

## Notes

- Keep `99-local.zsh` out of git (it's already in `.gitignore`)
- Use `99-local.zsh.example` as a template
- All tool initializations check for command availability first
- Configuration is modular: remove files you don't need
- History is shared across all shells (SHARE_HISTORY option)
