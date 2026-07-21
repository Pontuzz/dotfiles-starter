# Troubleshooting Guide

Common issues with the dotfiles configuration and how to fix them.

---

## GitHub Authentication Failed

```bash
# ❌ This no longer works (GitHub disabled password auth):
git clone https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles

# ✅ Use SSH instead (recommended):
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
# Requires SSH key configured: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

# ✅ Or use Personal Access Token (PAT):
git clone --recursive https://<PAT>@github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
# Get PAT: https://github.com/settings/tokens (check "repo" scope)
```

## Shell Won't Start

```bash
# Check for syntax errors
zsh -n ~/.zshrc

# Load with verbose output
zsh -x ~/.zshrc 2>&1 | head -20
```

## Powerlevel10k Theme Looks Broken

```bash
# This usually means you need to install Powerlevel10k fonts
# Download from: https://github.com/romkatv/powerlevel10k#fonts

# Or temporarily disable Powerlevel10k in 20-init-early.zsh
```

## Tools Not Initializing (fzf, brew, zoxide, etc.)

```bash
# Check if tool is installed
command -v fzf       # Check fzf
command -v zoxide    # Check zoxide
command -v brew      # Check brew

# If not found, install it:
# - Ubuntu/Debian: sudo apt install <package>
# - macOS: brew install <package>
# - Arch: sudo pacman -S <package>
```

## Symlink Issues

```bash
# Verify symlink is correct
ls -l ~/.config/zsh
# Should show: ~/.config/zsh -> ~/dotfiles/.config/zsh

# If broken, recreate it
rm ~/.config/zsh
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
```

## Submodule Issues

### Empty directories after clone
```bash
# If you cloned without --recursive
cd ~/dotfiles
git submodule update --init --recursive

# Or re-clone properly
rm -rf ~/dotfiles
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
```

**Note:** The post-merge hook auto-initializes submodules on future pulls, so this should be a one-time issue.

### Submodules not updating after `git pull`
```bash
cd ~/dotfiles
git pull origin master
git submodule update --remote --merge

# Or as a single command:
git pull origin master && git submodule update --remote --merge
```

### Check submodule status
```bash
git submodule status
# Example output:
# 67cd8c4 .config/zsh/.oh-my-zsh (heads/master)
# 0fb5488 .config/zsh/custom/plugins/fzf-dir-navigator (v1.2.2-5-g0fb5488)
```

### Update a specific submodule
```bash
# Update just one plugin/theme
git submodule update --remote .config/zsh/custom/plugins/zsh-bat
git add .config/zsh/custom/plugins/zsh-bat
git commit -m "Update zsh-bat plugin"
git push
```

### Update all submodules at once
```bash
git submodule update --remote --merge
git add .gitmodules .config/zsh/
git commit -m "Update all submodules"
git push
```

## Platform Detection Not Working

```bash
# Check what platform was detected
zsh -c "source ~/.config/zsh/10-machine-detect.zsh && \
  echo 'IS_WSL='\$IS_WSL' IS_ARM='\$IS_ARM' MACHINE_TYPE='\$MACHINE_TYPE"
```

## Startup Time Too Slow

If you see a "Shell startup took Xs" warning:

1. Check for missing plugins or tools
2. Run `zsh -x ~/.zshrc 2>&1 | head -40` to see what's slow
3. Common culprits: keychain, slow tool initialization, large plugin sets
4. The daily tool check will tell you which optional tools are missing

## setup.sh Issues

### setup.sh fails with "command not found: sudo"
The script needs sudo for package installation. Run it as a normal user (not root) — it will prompt for sudo password when needed.

### setup.sh says "unsupported package manager"
The script supports apt, pacman, dnf, brew, and apk. If you're on something else (emerge, xbps, etc.), use the [Manual Setup](../README.md#manual-setup) approach or run `setup.sh --check` to see what would be done, then install deps yourself.

### setup.sh doesn't change my shell
`chsh` may prompt for a password. Run it manually if the script's `chsh` attempt is skipped:
```bash
chsh -s "$(which zsh)"
```

### Symlinks not created (permission denied)
The script backs up existing files to `~/.dotfiles-backup-*` before creating symlinks. If a file is owned by root, run setup.sh without `sudo` but with your user — it handles user-level files. System-level zsh install (~200ms check) is the only sudo-dependent step.

---

## Tool Check Flags Missing Tools

The daily tool check looks for: `fzf zoxide bat lsd eza ripgrep thefuck navi`

```bash
# Install missing tools via brew (Linux/macOS)
brew install fzf zoxide bat lsd eza ripgrep thefuck navi

# Or via apt (Debian/Ubuntu)
sudo apt install fzf ripgrep bat
```

**To silence reminders for tools you know are missing** (e.g., Raspberry Pi doesn't have `thefuck`), add this to `~/.config/zsh/99-local.zsh`:

```bash
DOTFILES_IGNORE_MISSING_TOOLS="thefuck navi eza"
```

The check will still run daily for other tools — only the listed ones are suppressed.

---

**Last updated:** July 19, 2026  
**See also:** [README.md](README.md), [setup.sh](setup.sh), [PORTABLE_SETUP.md](.config/zsh/PORTABLE_SETUP.md)
