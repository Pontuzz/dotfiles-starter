# Dotfiles Starter Template - Portable Zsh Configuration

A modular, portable zsh configuration template designed to work seamlessly across **WSL2, Linux, macOS, and Raspberry Pi**. Clean architecture with machine-specific overrides and proper separation of concerns.

**What This Is:** A public, sanitized template for sharing portable zsh configuration. All sensitive infrastructure data (hostnames, IP addresses, usernames) has been replaced with placeholders. This is not a finished product—it's a starting point you'll customize by creating your own version (fork or copy) and filling in your actual values.

## ⚠️ Security & Setup Checklist

**IMPORTANT: Before using, read this section carefully!**

### This is a Template - Create Your Own Version

This repository is a **public template** meant for you to fork or copy. You should create your own version to track your personal configuration:

**Option 1: Create Your Own Repo (Recommended)**
```bash
# Create a new GitHub repo (e.g., "my-dotfiles"), then:
git clone --recursive https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles
git remote set-url origin git@github.com:YOUR-USERNAME/my-dotfiles.git
git push -u origin main
```

**Option 2: Fork This Repo**
```bash
# Click "Fork" on GitHub, then clone your fork
git clone --recursive git@github.com:YOUR-USERNAME/dotfiles-starter.git ~/dotfiles
```

**Why create your own?**
- Your configuration is version-controlled across multiple machines
- Changes are tracked in your own repository
- You maintain complete control over your setup
- Easy to sync dotfiles between WSL2, Linux, macOS, Raspberry Pi, etc.

See [TEMPLATE-README.md](TEMPLATE-README.md) for detailed comparison of both approaches.

### New User Setup Checklist

- [ ] **Create your own version** (fork or create new repo - see above)
- [ ] Clone YOUR repository to `~/dotfiles`
- [ ] **REQUIRED: Create `~/.config/zsh/99-local.zsh`** from the template
  ```bash
  cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
  nano ~/.config/zsh/99-local.zsh
  ```
- [ ] **Add your machine-specific settings** to `99-local.zsh` (see Machine-Specific Settings section)
- [ ] **Keep `99-local.zsh` private** - it's gitignored for a reason (don't commit it!)
- [ ] Test the configuration: `exec zsh`
- [ ] Verify no warnings on startup

### What's Machine-Specific?

The `99-local.zsh` file is where YOU add sensitive/personal settings that shouldn't be in version control:

**Examples of things that go in `99-local.zsh`:**
- SSH key passphrases or keychain setup
- Personal/internal IP addresses or hostnames (e.g., `[your-internal-ip]`)
- API tokens or credentials
- Private aliases or functions
- Work-specific paths or configurations
- Hardware-specific settings (device mount points, etc.)

**DO NOT put in the repo:**
- SSH private keys (use `~/.ssh/`)
- API tokens or passwords
- Personal network information
- Anything you wouldn't want on GitHub

### Security Guarantee

✅ This repository is **security-audited** and **secret-proof**:
- No hardcoded credentials anywhere
- SSH keys, tokens, and credentials are properly gitignored
- `99-local.zsh` is gitignored (machine-specific, never commits)
- `.env` files are gitignored
- All sensitive patterns blocked by `.gitignore`

See [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) for detailed audit results.

## 🆕 Recent Updates

### June 2026 — Auto-Recovery & Diagnostics

- **Startup time guard**: If your shell takes longer than 3 seconds to load, you'll see a warning with the exact time. Helps identify slow plugins or tools.
- **Daily tool availability check**: Once per day, checks for optional tools (fzf, bat, ripgrep, etc.) and reports which are missing with install instructions. Silent when all tools are present.
- **Tool check suppression**: Set `DOTFILES_IGNORE_MISSING_TOOLS` in `99-local.zsh` to silence reminders for tools you know are missing on a particular machine (e.g., `DOTFILES_IGNORE_MISSING_TOOLS="thefuck navi"`).
- **Symlink health check**: On each startup, verifies `~/.config/zsh`, `~/.zshenv`, `~/.bashrc` are properly linked. Silent when healthy; prints fix commands if broken.
- **Zcompdump auto-rotation**: Stale `.zcompdump` files are pruned automatically (once per day), keeping the cache directory clean.
- **HISTFILE migration**: Shell history is stored at `$XDG_STATE_HOME/history/zsh/` (`~/.local/state/history/zsh/`), not in `ZDOTDIR` or `~/`.

## 🎯 Quick Start

### Installation

**Choose your authentication method:**

**Option 1: SSH (Recommended)**
```bash
# Clone using SSH (requires SSH key configured on GitHub)
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles
```

**Option 2: HTTPS with Personal Access Token**
```bash
# Clone using HTTPS (requires GitHub PAT, not password)
# Get PAT from: https://github.com/settings/tokens (scope: repo)
git clone --recursive https://<PAT>@github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
cd ~/dotfiles
```

**Full installation steps (continue with either method above):**

```bash
# If you already cloned, continue from here:
cd ~/dotfiles

# If you already cloned without --recursive, init submodules now:
# git submodule update --init --recursive

# Backup your current config (optional)
cp -r ~/.config/zsh ~/backups/zsh.backup
cp ~/.zshenv ~/backups/.zshenv.backup

# Create symlinks to this repo
rm -rf ~/.config/zsh
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
ln -s ~/dotfiles/.zshenv ~/.zshenv

# Set up Git config (optional but recommended)
cp ~/dotfiles/.gitconfig.example ~/.gitconfig
nano ~/.gitconfig  # Add your name, email, and settings

# Set up SSH config (optional but recommended)
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cp ~/dotfiles/.ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config  # Add your SSH hosts

# Create machine-specific config from template
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
nano ~/.config/zsh/99-local.zsh  # Edit with your machine-specific settings

# Set up custom MOTD (optional)
cp ~/.config/motd/20-custom.sh.example ~/.config/motd/20-custom.sh
nano ~/.config/motd/20-custom.sh  # Add custom messages
chmod +x ~/.config/motd/20-custom.sh

# Restart your shell
exec zsh
```

### For Cloning to Another Machine (Pi, different WSL, etc.)

Same installation steps above (make sure to use `--recursive` flag!). The config auto-detects platform and hostname, so machine-specific settings automatically enable/disable based on your environment. Just customize `99-local.zsh` for each machine.

### Managing Submodules

This repo uses **git submodules** for external dependencies:

**Core Framework:**
- Oh My Zsh (`.config/zsh/.oh-my-zsh`)

**External Plugins (5 submodules):**
- fzf-dir-navigator (KulkarniKaustubh/fzf-dir-navigator)
- zsh-autosuggestions (zsh-users/zsh-autosuggestions)
- zsh-bat (fdellwing/zsh-bat)
- zsh-lsd (z-shell/zsh-lsd)
- zsh-syntax-highlighting (zsh-users/zsh-syntax-highlighting)

**Theme (1 submodule):**
- powerlevel10k (romkatv/powerlevel10k)

**Custom Embedded Plugins (stay in repo):**
- lazy-loader, my-alias, my-ssh, performance-monitor

**Important:** Always clone with `--recursive`:
```bash
git clone --recursive https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
```

**Update all submodules to latest versions:**
```bash
cd ~/dotfiles
git submodule update --remote --merge
git add .gitmodules .config/zsh/.oh-my-zsh .config/zsh/custom/plugins/ .config/zsh/custom/themes/
git commit -m "Update all submodules to latest versions"
git push
```

**Update a specific submodule (e.g., powerlevel10k):**
```bash
cd ~/dotfiles
git submodule update --remote .config/zsh/custom/themes/powerlevel10k
git add .config/zsh/custom/themes/powerlevel10k
git commit -m "Update powerlevel10k theme"
git push
```

**Initialize submodules if you forgot `--recursive`:**
```bash
cd ~/dotfiles
git submodule update --init --recursive
```

**Check submodule status:**
```bash
git submodule status
# Shows commit hashes for all submodules
```

## 📁 Repository Structure

```
dotfiles/
├── .gitmodules                      # Git submodule configuration
├── .zshenv                          # Global environment setup (sourced by all shells)
├── .bashrc                          # Bash configuration hub (symlink to repo)
├── .gitignore                       # Git ignore patterns
├── README.md                        # This file
├── LICENSE                          # MIT License
│
├── .bashrc.d/                       # Modular Bash configuration
│   ├── 01-motd.bash                 # MOTD display setup
│   ├── 10-detect.bash               # Platform detection
│   ├── 20-env.bash                  # Environment variables
│   ├── 50-tools.bash                # Tool initializations
│   ├── 60-aliases.bash              # Portable aliases
│   └── 99-local.bash.example        # Template for machine-specific config
│
├── .gitconfig.example               # Template for ~/.gitconfig (use as reference)
├── .ssh/config.example              # Template for ~/.ssh/config (use as reference)
│
├── .config/
│   ├── zsh/                         # Main zsh configuration
│   │   ├── .zshrc                   # Main zshrc (sources all modular files)
│   │   ├── .p10k.zsh                # Powerlevel10k prompt configuration
│   │   ├── 00-init-early.zsh        # Early init (MOTD, instant prompt)
│   │   ├── 20-machine-detect.zsh    # Platform detection
│   │   ├── plugins.zsh              # Oh My Zsh plugins
│   │   ├── 40-env.zsh               # Environment variables
│   │   ├── 50-tools.zsh             # Tool initializations
│   │   ├── aliases.zsh              # Portable aliases
│   │   ├── functions.zsh            # Custom functions
│   │   ├── 99-local.zsh.example     # Template for machine-specific config
│   │   ├── .oh-my-zsh/              # Oh My Zsh (submodule)
│   │   ├── custom/
│   │   │   ├── plugins/             # Zsh plugins (4 custom + 5 submodules)
│   │   │   └── themes/              # Themes (powerlevel10k submodule)
│   │   └── .gitignore
│   │
│   └── motd/                        # User-level MOTD (Message of the Day)
│       ├── 10-system.sh             # System information display
│       └── 20-custom.sh.example     # Template for custom messages
│
```

## 🖥️ Machine-Specific Settings (99-local.zsh)

The `99-local.zsh` file is your private configuration that never gets committed. It's sourced LAST, so it can override anything.

**Quick start:**
```bash
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
nano ~/.config/zsh/99-local.zsh
```

### Examples by Machine Type

```bash
# ~/.config/zsh/99-local.zsh (GITIGNORED - safe to add secrets here)

# ===== Work Machine (hostname [work-machine]) =====
if [[ "$MACHINE_TYPE" == "workstation" ]]; then
  # SSH key setup
  keychain ~/.ssh/id_rsa --agents ssh -q
  
  # Internal service aliases (replace IPs with your actual values)
  alias internal-tool='telnet [your-internal-ip] 3335'
  
  # Work-specific PATH
  export WORK_ROOT="$HOME/work"
fi

# ===== Raspberry Pi (hostname raspberrypi*) =====
if [[ "$IS_RASPBERRY_PI" == true ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
  alias piclean='sudo apt autoremove && sudo apt autoclean'
  export HISTSIZE=10000  # Smaller history on limited storage
fi

# ===== Generic fallback (any other machine) =====
if [[ "$MACHINE_TYPE" == "generic" ]]; then
  echo "Running on generic machine"
fi

# ===== Personal/Private Settings (all machines) =====
export GITHUB_TOKEN="your_token_here"
export CUSTOM_API_KEY="secret_value"
alias myrepo='cd $HOME/projects/repo'
```

### Platform Detection Variables Available

Use these variables in `99-local.zsh` for conditional setup:

```bash
IS_WSL=true/false         # Windows Subsystem for Linux
IS_LINUX=true/false       # Generic Linux
IS_MACOS=true/false       # macOS
IS_ARM=true/false         # ARM architecture (Raspberry Pi, Apple Silicon)
MACHINE_TYPE=string       # "hivenet_client", "raspberry_pi", "generic"
HOSTNAME=string           # System hostname

# Machine-specific flags (set based on hostname)
IS_HIVENET_CLIENT=true/false
IS_RASPBERRY_PI=true/false
```

### How Machines Update Automatically

When you clone this repo to a new machine:
1. `20-machine-detect.zsh` runs and detects your platform
2. Sets the appropriate flags: `IS_WSL`, `IS_LINUX`, `IS_MACOS`, `IS_ARM`, `MACHINE_TYPE`
3. Hostname-based flags: `IS_HIVENET_CLIENT`, `IS_RASPBERRY_PI`
4. Your `99-local.zsh` can check these flags for machine-specific setup

**One repo, unlimited machines** — just customize `99-local.zsh` per machine.

## 🔧 Symlink Workflow

When using symlinks, **all edits happen in the dotfiles repo**. Edit files at `~/dotfiles/.config/zsh/` and changes take effect immediately via the symlink. For detailed workflow information, see [SYMLINK_WORKFLOW.md](SYMLINK_WORKFLOW.md).

## 📋 Configuration Overview

The dotfiles use a modular zsh configuration with files sourced in a specific order:

```
.zshrc → 00-init-early → 20-machine-detect → plugins → 40-env → 50-tools → aliases → functions → 99-local (gitignored)
```

Each file has a specific purpose. See [ARCHITECTURE.md](.config/zsh/ARCHITECTURE.md) for the complete file-by-file breakdown.

## 🐚 Bash Configuration

Bash configuration mirrors the Zsh structure with modular files in `.bashrc.d/`:

### Installation
```bash
# Create symlink (same as Zsh)
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
```

### Modular Bash Files

- **01-motd.bash**: MOTD display setup
- **10-detect.bash**: Platform detection (same flags as Zsh)
- **20-env.bash**: Environment variables
- **50-tools.bash**: Tool initialization (brew, zoxide, fzf, atuin)
- **60-aliases.bash**: Portable cross-platform aliases
- **99-local.bash.example**: Template for machine-specific config

Platform detection in Bash works the same as Zsh:
- `$IS_WSL`, `$IS_LINUX`, `$IS_MACOS`, `$IS_ARM`, `$MACHINE_TYPE`

## 🔑 Git Configuration

Git config is templated to prevent accidentally committing credentials:

### Setup
```bash
# Copy template to your home directory
cp ~/dotfiles/.gitconfig.example ~/.gitconfig

# Edit with your details
nano ~/.gitconfig

# Add your name and email (required)
[user]
    name = "Your Name"
    email = "your.email@example.com"
```

**Important**: Your `~/.gitconfig` is **gitignored** and never committed. Each machine can have different settings.

## 🔐 SSH Configuration

SSH configuration is also templated to protect sensitive hostnames and keys:

### Setup
```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cp ~/dotfiles/.ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
```

**Important**: Your real `~/.ssh/config` is **gitignored** for security. The `.ssh/config.example` shows templates and patterns.

## 💬 MOTD (Message of the Day)

Custom user-level MOTD displays content on shell startup. The template includes a figlet-based ASCII art MOTD with auto-detection for container environments (Docker, Zellij).

### Features
- **Figlet ASCII art**: Displays "DOTFILES" with system info on startup
- **Container-aware**: Suppressed inside Docker containers and Zellij panes
- **Once-per-session**: Uses a timestamp stamp to display only once (even across Bash/Zsh switches)
- **20-custom.sh.example**: Template to add custom messages

### Customizing MOTD
```bash
# Edit the main MOTD script to customize branding
nano ~/.config/motd/10-hivenet-motd.sh

# Or add custom messages
cp ~/.config/motd/20-custom.sh.example ~/.config/motd/20-custom.sh
nano ~/.config/motd/20-custom.sh
chmod +x ~/.config/motd/20-custom.sh
```

## 📦 Dependencies

### Required
- `zsh` - Shell
- `git` - For version control

### Recommended
- `oh-my-zsh` - Plugin framework (auto-cloned to `.config/zsh/.oh-my-zsh/`)
- `powerlevel10k` - Beautiful prompt (in custom/themes/)

### Optional (won't break if missing)
- `fzf` - Fuzzy finder
- `zoxide` - Smart directory navigation
- `ripgrep` - Better grep
- `bat` - Better cat
- `atuin` - Shell history search
- `thefuck` - Command correction
- `navi` - Interactive cheatsheet
- `brew` - Package manager (Linuxbrew on Linux)
- `keychain` - SSH key management

Missing tools don't break the config. Tools are checked with `command -v` before use.

**Suppress reminders for known-missing tools:** Add this to `~/.config/zsh/99-local.zsh`:
```bash
DOTFILES_IGNORE_MISSING_TOOLS="thefuck navi eza"
```

## 🔐 Security & Secrets

### Never commit secrets to this repo!

Machine-specific secrets go in:
```bash
~/.config/zsh/99-local.zsh              # Not tracked by git (stays local)
~/.config/secrets/credentials.env       # Not tracked by git (stays local)
```

These files are gitignored:
```bash
.config/zsh/99-local.zsh
.config/secrets/
```

Example secure setup:
```bash
# In ~/.config/zsh/99-local.zsh (local machine only, not in repo)
if [ -f "$HOME/.config/secrets/credentials.env" ]; then
  source "$HOME/.config/secrets/credentials.env"
fi

# In ~/.config/secrets/credentials.env (gitignored, local machine only)
export GITHUB_TOKEN="your-secret-token"
export API_KEY="your-secret-key"
```

## 🚀 Workflow

### Edit & Reload (Day-to-day)

```bash
# Edit a config file in the repo
nano ~/dotfiles/.config/zsh/aliases.zsh

# Reload your shell (symlink auto-uses updated file)
source ~/.zshrc
# or
exec zsh
```

### Push to GitHub (Share across machines)

```bash
cd ~/dotfiles
git add .config/zsh/aliases.zsh
git commit -m "Add new aliases"
git push origin main
```

### Pull on Other Machines

```bash
cd ~/dotfiles
git pull origin main
exec zsh  # Restart shell to reload config
```

### Setup New Machine

```bash
# Same as Quick Start above
git clone https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
# ... create symlinks, setup 99-local.zsh, restart shell
```

## 🐛 Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions to common issues:

- GitHub authentication failed
- Shell won't start
- Powerlevel10k looks broken
- Tools not initializing
- Symlink issues
- Submodule issues (empty directories, pull problems)
- Platform detection not working
- Slow startup / missing tool warnings

## 📚 Additional Resources

- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Solutions to common issues
- [.config/zsh/ARCHITECTURE.md](.config/zsh/ARCHITECTURE.md) - Configuration flow and design
- [.config/zsh/PORTABLE_SETUP.md](.config/zsh/PORTABLE_SETUP.md) - Detailed portable setup guide
- [.config/zsh/SYMLINK_WORKFLOW.md](.config/zsh/SYMLINK_WORKFLOW.md) - Symlink workflow and best practices
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Prompt theme
- [Oh My Zsh](https://ohmyzsh.sh/) - Plugin framework
- [Zsh Manual](http://zsh.sourceforge.net/Doc/) - Zsh documentation

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

---

**Status**: ✅ Stable and portable  
**Tested on**: WSL2 (Ubuntu), Raspberry Pi 3, Linux  
**Last updated**: June 7, 2026
