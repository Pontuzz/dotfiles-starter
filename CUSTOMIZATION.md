# Customization Guide

This guide walks you through personalizing the dotfiles for your specific machine(s).

## 1. Hostname-Based Machine Detection

The config automatically detects your machine type based on hostname patterns. You need to customize this for your setup.

### Step 1a: Check Your Hostname

```bash
# On each machine, run:
hostname
# Example outputs:
# my-laptop
# work-machine
# ubuntu-server
# pi-zero
# MacBook-Pro.local
```

### Step 1b: Edit Machine Detection (`.config/zsh/20-machine-detect.zsh`)

Find this section in `.config/zsh/20-machine-detect.zsh`:

```zsh
# Hostname-based detection for specific machines
# Customize the hostname patterns below for your environment
HOSTNAME=$(hostname)
case "$HOSTNAME" in
  [work-machine]*)
    export IS_WORK_MACHINE=true
    export MACHINE_TYPE="work_machine"
    ;;
  raspberrypi*)
    export IS_RASPBERRY_PI=true
    export MACHINE_TYPE="raspberry_pi"
    ;;
  *)
    export MACHINE_TYPE="generic"
    ;;
esac
```

Replace the patterns with YOUR actual hostnames. Examples:

**If you have a work machine and home machine:**

```zsh
case "$HOSTNAME" in
  my-work-laptop*)
    export IS_WORK_MACHINE=true
    export MACHINE_TYPE="work_machine"
    ;;
  home-ubuntu*)
    export IS_HOME_MACHINE=true
    export MACHINE_TYPE="home_machine"
    ;;
  raspberrypi*|pi-zero*)
    export IS_RASPBERRY_PI=true
    export MACHINE_TYPE="raspberry_pi"
    ;;
  *)
    export MACHINE_TYPE="generic"
    ;;
esac
```

### Step 1c: Update Bash Detection Too (`.bashrc.d/10-detect.bash`)

Do the same for `.bashrc.d/10-detect.bash`:

```bash
# Detect machine type
# Customize the hostname patterns below for your environment
MACHINE_TYPE="generic"
if [[ -n "$HOSTNAME" ]]; then
    case "$HOSTNAME" in
        *my-work-laptop*|*work*)
            MACHINE_TYPE="work_machine"
            ;;
        *home-ubuntu*|*home*)
            MACHINE_TYPE="home_machine"
            ;;
        *pi*|*raspberry*)
            MACHINE_TYPE="raspberry_pi"
            ;;
    esac
fi
```

## 2. Machine-Specific Configuration

Once detection is set up, create your personal config file that runs on specific machines.

### Step 2a: Create `99-local.zsh`

```bash
# This file is gitignored - safe for personal/sensitive data
nano ~/.config/zsh/99-local.zsh
```

### Step 2b: Add Your Machine-Specific Settings

Here are common examples:

```zsh
#!/usr/bin/env zsh
# Machine-specific and secret configuration (NOT COMMITTED TO GIT)

# ============================================================================
# SSH Key Management (Personalize for your keys)
# ============================================================================
if [[ -f ~/.ssh/id_ed25519 ]]; then
    if ! ssh-add -l 2>/dev/null | grep -q "id_ed25519"; then
        ssh-add -t 3600 ~/.ssh/id_ed25519 2>/dev/null || true
    fi
fi

# ============================================================================
# Work Machine Specific
# ============================================================================
if [[ "$IS_WORK_MACHINE" == true ]]; then
  # Add your work-specific aliases here
  alias work-tool='ssh user@[your-internal-ip]'
  alias deploy='./scripts/deploy.sh'
fi

# ============================================================================
# Home Machine Specific
# ============================================================================
if [[ "$IS_HOME_MACHINE" == true ]]; then
  # Add your home-specific aliases here
  alias nas='ssh user@192.168.1.5'
  alias media-server='ssh user@192.168.1.10'
fi

# ============================================================================
# Raspberry Pi Specific
# ============================================================================
if [[ "$IS_RASPBERRY_PI" == true ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
  alias pireboot='sudo reboot'
fi

# ============================================================================
# Personal Aliases (Any Machine)
# ============================================================================
alias myproject='cd ~/projects/my-project'
alias dotfiles='cd ~/dotfiles'

# ============================================================================
# Environment Variables (Personal)
# ============================================================================
export CUSTOM_VAR="value"
export API_KEY="your-key-here"  # Keep sensitive stuff here, NOT in repo!
```

## 3. Git Configuration

### Step 3a: Create Your Git Config

```bash
cp .gitconfig.example ~/.gitconfig
nano ~/.gitconfig
```

### Step 3b: Update with Your Information

```ini
[user]
    name = "Your Name"
    email = "your.email@example.com"

[core]
    editor = nano
    # Change to: vim, nvim, emacs, etc.

[init]
    defaultBranch = main
    # Or: master, develop, etc.

[push]
    default = current

[alias]
    st = status
    co = checkout
    br = branch
    # Add your own aliases here
```

## 4. SSH Configuration

### Step 4a: Create Your SSH Config

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cp .ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
```

### Step 4b: Add Your SSH Hosts

```
# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

# Work Server
Host work-server
    HostName [your-internal-ip]
    User [username]
    IdentityFile ~/.ssh/id_rsa
    # Port 22  # uncomment if custom port

# Home NAS
Host nas
    HostName 192.168.1.5
    User admin
    IdentityFile ~/.ssh/id_ed25519
```

## 5. Shell Tools Configuration

Many tools are optional and auto-skip if not installed. To customize them, edit `.config/zsh/50-tools.zsh` or add to `99-local.zsh`:

### FZF (Fuzzy Finder)

```zsh
# In 99-local.zsh:
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --reverse'
```

### Atuin (History Search)

```zsh
# Already configured, but customize if needed:
export ATUIN_NOBIND=true  # If you want to bind keys manually
```

### Zoxide (z command)

```zsh
# Already configured, no customization needed usually
# But you can add to 99-local.zsh if you want custom behavior
```

## 6. Customizing the MOTD (Message of the Day)

The MOTD displays when you start a shell. Customize it in `.config/motd/`:

```bash
# Add your own MOTD file
nano ~/.config/motd/30-custom.sh
```

Example:

```bash
#!/bin/bash
echo "🚀 Welcome to $(hostname)!"
echo "📅 Today is $(date +%A)"
```

Make it executable:

```bash
chmod +x ~/.config/motd/30-custom.sh
```

## 7. Platform-Specific Tweaks

### Windows Subsystem for Linux (WSL2)

The config automatically detects WSL. If you need WSL-specific settings:

```zsh
# In 99-local.zsh:
if [[ "$IS_WSL" == true ]]; then
  # WSL-specific aliases
  alias winhome='cd /mnt/c/Users/[windows-username]'
  alias winmount='explorer.exe .'  # Open Windows Explorer
fi
```

### macOS

```zsh
if [[ "$IS_MACOS" == true ]]; then
  # macOS-specific aliases
  alias finder='open .'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false'
fi
```

### Raspberry Pi

```zsh
if [[ "$IS_RASPBERRY_PI" == true ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
  alias pireboot='sudo reboot now'
fi
```

## 8. Verifying Your Setup

After customization, test everything:

```bash
# Start a new shell
exec zsh

# Check for errors (should be clean)
# Watch for the MOTD and prompt

# Verify machine detection
echo "Machine Type: $MACHINE_TYPE"
echo "Is WSL: $IS_WSL"
echo "Is macOS: $IS_MACOS"
echo "Is Linux: $IS_LINUX"
echo "Is ARM: $IS_ARM"

# Test your aliases
# (whatever you added to 99-local.zsh)
```

## 9. Managing Across Multiple Machines

### Scenario: Same repo, different machines

```bash
# Clone on each machine:
git clone --recursive <REPO_URL> ~/dotfiles

# On EACH machine, customize:
1. .config/zsh/20-machine-detect.zsh  (detect that specific machine's hostname)
2. ~/.config/zsh/99-local.zsh          (machine-specific settings)

# Symlink on each machine:
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
ln -s ~/dotfiles/.zshenv ~/.zshenv
```

### Scenario: Shared machine (multiple users)

Each user gets their own `99-local.zsh`:

```bash
# User 1:
nano ~/.config/zsh/99-local.zsh

# User 2:
nano ~/.config/zsh/99-local.zsh
# Different settings!
```

## 10. Troubleshooting Customization

### "99-local.zsh not found" error
- Create it: `touch ~/.config/zsh/99-local.zsh`
- The config gracefully handles missing files

### Machine detection not working
- Verify hostname: `hostname`
- Check pattern matches: `echo $HOSTNAME | grep -E "[your-pattern]"`
- Edit the pattern in `.config/zsh/20-machine-detect.zsh`

### Aliases aren't loading
- Check 99-local.zsh is being sourced: `source ~/.config/zsh/99-local.zsh`
- Verify no syntax errors: `bash -n ~/.config/zsh/99-local.zsh`

### Want to disable a tool?
- Edit `.config/zsh/50-tools.zsh` and comment out the section
- Or set an environment variable: `export TOOL_DISABLED=true` in 99-local.zsh

---

**Need help?** Check [README.md](README.md) or [ARCHITECTURE.md](.config/zsh/ARCHITECTURE.md) for more details.
