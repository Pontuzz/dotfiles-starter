# Dotfiles Template - Ready to Use

**This is a template repository** for sharing portable zsh/bash configuration with friends and team members.

## What This Is

A carefully crafted, **sanitized, and portable dotfiles template** that works across:
- **WSL2** (Windows Subsystem for Linux 2)
- **Linux** (Ubuntu, Debian, Fedora, etc.)
- **macOS** (Intel and Apple Silicon)
- **Raspberry Pi** (ARM-based Linux)

All sensitive data (IP addresses, hostnames, usernames) has been replaced with placeholders like `[your-internal-ip]` and `[username]`.

## What You Get

✅ **Portable zsh configuration** that auto-detects your platform and machine type  
✅ **Oh-my-zsh** pre-configured with best practices  
✅ **6 carefully selected plugins/themes** managed as git submodules:
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-bat
- zsh-lsd
- fzf-dir-navigator
- powerlevel10k theme

✅ **Optional tool integrations** (all gracefully skip if not installed):
- FZF (fuzzy finder)
- Zoxide (z command)
- Atuin (history search)
- TheFuck (command correction)
- Brew (macOS/Linux package manager)

✅ **Security-audited** - properly gitignored, no hardcoded secrets  
✅ **Machine-specific customization** - easy override system for per-machine settings  
✅ **Clean architecture** - modular design with clear separation of concerns  

## Getting Started

**IMPORTANT:** This is a template for you to customize! You should create your own version to track your personal configuration.

### Option 1: Create Your Own Repo (Recommended) ⭐

This gives you a completely independent dotfiles repo that's yours to customize:

```bash
# 1. Create a new repository on GitHub (e.g., "my-dotfiles")
# 2. Clone THIS template to your local machine
git clone --recursive https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles

# 3. Update the git remote to point to YOUR repo (replace with your username/repo):
git remote set-url origin git@github.com:YOUR-USERNAME/my-dotfiles.git

# 4. Push to your own repository
git push -u origin main

# 5. Follow the setup guide
cat SETUP.md
```

**Why this approach?**
- ✅ Your repo looks like your own project (not a fork)
- ✅ Complete independence—customize as much as you want
- ✅ Your configuration is version-controlled and easy to sync across machines
- ✅ Clean GitHub profile (shows your dotfiles, not a fork)

### Option 2: Fork This Repo (If you want to track updates)

If you want to easily pull in updates from the original template:

```bash
# 1. Click "Fork" on https://github.com/Pontuzz/dotfiles-starter
# 2. Clone your fork
git clone --recursive git@github.com:YOUR-USERNAME/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles

# 3. Customize and push your changes to your fork
# 4. Follow the setup guide
cat SETUP.md
```

**Why this approach?**
- ✅ Easier to sync with template updates (git pull)
- ✅ Can contribute improvements back via pull requests
- ❌ GitHub shows "forked from Pontuzz/dotfiles-starter"

---

**Pick one approach above, then continue with [SETUP.md](SETUP.md)** ✨

## Documentation

- **[SETUP.md](SETUP.md)** - Start here! 5-minute quick start
- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - How to personalize for your machine(s)
- **[README.md](README.md)** - Full feature reference and detailed installation
- **[SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)** - What's secure and why

## Key Files to Customize

1. **`.config/zsh/20-machine-detect.zsh`** - Update hostname patterns for your machines
2. **`~/.config/zsh/99-local.zsh`** - Your personal settings (gitignored, safe for secrets)
3. **`~/.gitconfig`** - Your git user information
4. **`~/.ssh/config`** - Your SSH hosts (optional)

## For Multiple Machines

```bash
# Clone on each machine
git clone --recursive <REPO_URL> ~/dotfiles

# On each machine, customize:
# 1. .config/zsh/20-machine-detect.zsh (for that machine's hostname)
# 2. ~/.config/zsh/99-local.zsh (for that machine's specific settings)

# Then symlink
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
ln -s ~/dotfiles/.zshenv ~/.zshenv
```

All your per-machine customizations stay local and never get committed.

## Security

- No SSH private keys
- No API tokens or credentials
- No personal information
- All `.env`, `.pem`, `.key` files properly gitignored
- `99-local.zsh` is gitignored (machine-specific settings)

See [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) for the full audit.

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| WSL2 | ✅ Fully Supported | Recommended for Windows users |
| Ubuntu/Debian | ✅ Fully Supported | Primary development platform |
| Fedora/RHEL | ✅ Fully Supported | Use `dnf` instead of `apt` |
| macOS | ✅ Fully Supported | Works on Intel and Apple Silicon |
| Raspberry Pi | ✅ Fully Supported | Uses Raspberry Pi OS (Debian-based) |
| Native Windows | ❌ Not Supported | Use WSL2 instead |

## Architecture

The configuration is organized into logical modules:

```
.config/zsh/
├── 00-init-early.zsh        # Instant prompt, MOTD
├── 20-machine-detect.zsh    # Platform/machine detection
├── 50-tools.zsh             # Tool initialization
├── functions.zsh            # Custom functions
├── plugins.zsh              # Plugin loading
├── 99-local.zsh             # YOUR personal config (gitignored)
├── custom/
│   ├── plugins/             # Git submodules (zsh plugins)
│   └── themes/              # Git submodules (zsh themes)
└── .oh-my-zsh/              # Oh-my-zsh (now tracked directly, not submodule)
```

For more details, see [ARCHITECTURE.md](.config/zsh/ARCHITECTURE.md).

## Tips

1. **Start with [SETUP.md](SETUP.md)** - it's the fastest way to get running
2. **Read [CUSTOMIZATION.md](CUSTOMIZATION.md)** - understand what to personalize
3. **Keep `99-local.zsh` private** - it's gitignored on purpose
4. **Test on one machine first** before deploying to multiple machines
5. **Update oh-my-zsh regularly** with `omz update` (it's now included, not a submodule!)

## Questions?

All common questions are answered in:
- [SETUP.md](SETUP.md) - Quick start and basic setup
- [CUSTOMIZATION.md](CUSTOMIZATION.md) - How to personalize
- [README.md](README.md) - Full reference
- [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) - What's safe

---

**Ready to get started?** → Read [SETUP.md](SETUP.md)!
