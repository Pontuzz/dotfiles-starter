# Quick Start Guide for Friends

Welcome! This is a portable dotfiles template designed for **WSL2, Linux, macOS, and Raspberry Pi**.

## ⚠️ FIRST: Create Your Own Repo

**This is a template.** You should create your own version to track your personal configuration!

### Option 1: Create Your Own (Recommended) ⭐

```bash
# 1. Create a new GitHub repo (e.g., "my-dotfiles")
# 2. Clone THIS template locally
git clone --recursive https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles

# 3. Change the remote to YOUR repository
git remote set-url origin git@github.com:YOUR-USERNAME/my-dotfiles.git

# 4. Push to your repo
git push -u origin main
```

**Why?** Your config is version-controlled, easy to sync across machines, and shows as your own project on GitHub.

### Option 2: Fork This Repo (Alternative)

If you want easy access to template updates:
```bash
# 1. Click "Fork" at https://github.com/Pontuzz/dotfiles-starter
# 2. Clone your fork
git clone --recursive git@github.com:YOUR-USERNAME/dotfiles-starter.git ~/dotfiles
```

---

## ⚡ TL;DR - Get Started in 5 Minutes

After creating your repo (above), continue here:

```bash
# Navigate to your cloned repo
cd ~/dotfiles

# Backup your current config (optional)
[ -d ~/.config/zsh ] && cp -r ~/.config/zsh ~/backups/zsh.backup
[ -f ~/.zshenv ] && cp ~/.zshenv ~/backups/.zshenv.backup

# Create symlinks
rm -rf ~/.config/zsh 2>/dev/null
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
ln -s ~/dotfiles/.zshenv ~/.zshenv

# Start zsh
exec zsh
```

## 📋 Before You Customize

**IMPORTANT:** Read these sections in order:

1. **[README.md](README.md)** - Full documentation and configuration options
2. **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - Step-by-step personalization guide
3. **[SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)** - What's safe and what's not

## 🔧 What You Need to Customize

### Machine Detection (Required)

Edit `.config/zsh/20-machine-detect.zsh` to detect **your** machine type:

```zsh
# Find this section:
case "$HOSTNAME" in
  [work-machine]*)
    export IS_WORK_MACHINE=true
    export MACHINE_TYPE="work_machine"
    ;;
```

Replace `[work-machine]` with patterns that match **your actual hostname**:

```bash
# Check your hostname:
hostname
# Example output: my-laptop, ubuntu-server, pi-zero, etc.
```

### Machine-Specific Config (Required)

Create `~/.config/zsh/99-local.zsh` with YOUR settings:

```bash
# Copy the template:
cp .config/zsh/99-local.zsh ~/.config/zsh/99-local.zsh

# Edit it:
nano ~/.config/zsh/99-local.zsh
```

This file is **gitignored** - it's safe to put personal/sensitive stuff here:
- SSH key setup
- Internal IP addresses and hostnames
- Personal aliases and functions
- Work-specific paths

### Git Config (Recommended)

```bash
cp .gitconfig.example ~/.gitconfig
nano ~/.gitconfig
# Add your name, email, and editor preferences
```

### SSH Config (Optional)

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cp .ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
# Add your SSH hosts (GitHub, servers, etc.)
```

## 🧪 Verify It Works

After setup, test the configuration:

```bash
# Open a new shell
exec zsh

# Check for errors (should be clean)
# Should see prompt with git status, machine info, etc.

# Verify detection:
echo $MACHINE_TYPE      # Should be "work_machine", "raspberry_pi", or "generic"
echo $IS_WSL            # Should be "true" or "false"
```

## 📱 Multi-Machine Setup

If you're cloning to multiple machines:

1. Clone the repo on each machine (with `--recursive` flag)
2. On **each machine**, customize `99-local.zsh` differently
3. On **each machine**, update `.config/zsh/20-machine-detect.zsh` with that machine's hostname pattern
4. The config auto-detects everything else (OS, architecture, WSL, etc.)

## 🆘 Troubleshooting

### "command not found" errors
- Install missing tools with your package manager (brew, apt, etc.)
- Many tools are optional - config gracefully skips them if missing

### Plugins aren't loading
- Ensure you cloned with `--recursive` flag
- Update submodules: `git submodule update --init --recursive`

### Symlinks don't work on Windows
- Use WSL2 instead of native Windows
- In WSL2, everything works fine

### Need to revert?
- Restore backups: `cp ~/backups/zsh.backup ~/.config/zsh`
- Or remove symlinks and use your old config

## 📚 Learn More

- **[README.md](README.md)** - Full feature list and architecture
- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - Detailed personalization guide
- **[ARCHITECTURE.md](.config/zsh/ARCHITECTURE.md)** - How the config is organized
- **[SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)** - Security audit results

## ❓ Questions?

Check the docs above first - most answers are there! 

Key files:
- `99-local.zsh` - Your personal config (gitignored)
- `.config/zsh/20-machine-detect.zsh` - Machine detection patterns
- `.config/zsh/50-tools.zsh` - Tool initialization (Brew, FZF, Zoxide, etc.)
- `.config/motd/` - MOTD (message of the day) on shell startup

---

**Happy configuring!** 🚀
