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

**Repository Structure Notes:**
- `.config/secrets/` - User-created directory for storing local credentials (doesn't exist by default - create as needed)
- `.zcompdump*` - Auto-generated Zsh completion dump files (regenerated each shell session)
- `.zsh_history` - Auto-generated Zsh history file (regenerated each shell session)

## �️ Machine-Specific Settings (99-local.zsh)

The `99-local.zsh` file is your private configuration that never gets committed. It's sourced LAST, so it can override anything.

### Example: Setting Up for Different Machines

```bash
# ~/.config/zsh/99-local.zsh (GITIGNORED - safe to add secrets here)

# ===== HiveNet Client Machine (hostname [work-machine]) =====
if [[ "$IS_HIVENET_CLIENT" == true ]]; then
  # SSH key setup
  keychain ~/.ssh/id_rsa --agents ssh -q
  
  # Internal service aliases (replace IPs with your actual values)
  alias [internal-tool]='telnet [your-internal-ip] 3335'
  alias avdump='dotnet /mnt/g/02\ -\ Utilities/[media-tool]/[media-tool]CL.dll ...'
  
  # Work-specific PATH
  export WORK_ROOT="$HOME/work"
fi

# ===== Raspberry Pi (hostname raspberrypi*) =====
if [[ "$IS_RASPBERRY_PI" == true ]]; then
  # Pi-specific setup
  alias piupdate='sudo apt update && sudo apt upgrade -y'
  alias piclean='sudo apt autoremove && sudo apt autoclean'
  
  # Pi performance settings
  export HISTSIZE=10000  # Smaller history on limited storage
fi

# ===== Generic fallback (any other machine) =====
if [[ "$MACHINE_TYPE" == "generic" ]]; then
  # Default machine setup
  echo "Running on generic machine"
fi

# ===== Personal/Private Settings (all machines) =====
# API keys, tokens, credentials (never commit these!)
export GITHUB_TOKEN="your_token_here"  # If needed
export CUSTOM_API_KEY="secret_value"   # Your secrets

# Personal aliases
alias myrepo='cd $HOME/projects/repo'
alias work='cd $HOME/work'
```

### Platform Detection Variables Available

You can use these variables in `99-local.zsh` for conditional setup. Both `MACHINE_TYPE` and specific flags are available:

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
2. Sets the appropriate flags based on what it finds:
   - Always sets: `IS_WSL`, `IS_LINUX`, `IS_MACOS`, `IS_ARM` (true/false)
   - Hostname-based: If hostname matches, sets `IS_HIVENET_CLIENT` or `IS_RASPBERRY_PI`
   - Always sets: `MACHINE_TYPE` ("hivenet_client", "raspberry_pi", or "generic")
3. Your `99-local.zsh` can check these flags to enable machine-specific setup
4. Everything else stays the same across machines

This means **one repo, unlimited machines** - just customize `99-local.zsh` per machine by checking the appropriate flags!

## 🔧 Symlink Workflow

When using symlinks, **all edits happen in the dotfiles repo**. Edit files at `~/dotfiles/.config/zsh/` and changes take effect immediately via the symlink. For detailed workflow information, see [SYMLINK_WORKFLOW.md](SYMLINK_WORKFLOW.md).


## 📋 Configuration Files Explained

### `.zshenv` (Home directory)
- **Purpose**: Sourced by ALL shells (login, interactive, and non-interactive)
- **Contains**: XDG paths, PATH setup, essential environment variables
- **Portable**: Platform-aware, guards WSL-specific paths, checks for tool availability
- **Edit**: `~/dotfiles/.zshenv`

### `.zshrc` (Modular sourcing hub)
- **Purpose**: Main zsh configuration that sources all other files in order
- **Order matters**: Early init → machine detect → plugins → env → tools → aliases
- **Modular**: Each file has a specific purpose and can be edited independently
- **Edit**: `~/dotfiles/.config/zsh/.zshrc`

### `00-init-early.zsh`
- **Purpose**: Runs BEFORE instant prompt for critical early setup
- **Contains**: Powerlevel10k instant prompt, Zellij auto-start, keychain initialization
- **Edit**: `~/dotfiles/.config/zsh/00-init-early.zsh`

### `20-machine-detect.zsh`
- **Purpose**: Auto-detect platform and set feature flags
- **Provides**: `$IS_WSL`, `$IS_LINUX`, `$IS_MACOS`, `$IS_ARM`, `$MACHINE_TYPE`
- **Used by**: Other configs and 99-local.zsh for conditional setup
- **Edit**: `~/dotfiles/.config/zsh/20-machine-detect.zsh`

### `plugins.zsh`
- **Purpose**: Oh My Zsh plugin loading and completion configuration
- **Contains**: Plugin list, zstyle completion settings, Oh My Zsh initialization
- **Includes**:
  - **External plugins (git submodules)**: fzf-dir-navigator, zsh-autosuggestions, zsh-bat, zsh-lsd, zsh-syntax-highlighting
  - **Custom embedded plugins**: lazy-loader, my-alias, my-ssh, performance-monitor
  - **Oh My Zsh plugins**: git, taskwarrior, thefuck, vscode, fzf
- **Edit**: `~/dotfiles/.config/zsh/plugins.zsh`

### `40-env.zsh`
- **Purpose**: Environment variables (EDITOR, PYENV_ROOT, NVM_DIR, etc.)
- **Edit**: `~/dotfiles/.config/zsh/40-env.zsh`

### `50-tools.zsh`
- **Purpose**: Tool initialization (brew, zoxide, fzf, atuin, thefuck)
- **Graceful**: Tools are checked with `command -v` before initializing
- **Edit**: `~/dotfiles/.config/zsh/50-tools.zsh`

### `aliases.zsh`
- **Purpose**: Portable, cross-platform aliases (no machine-specific paths)
- **Edit**: `~/dotfiles/.config/zsh/aliases.zsh`

### `functions.zsh`
- **Purpose**: Custom zsh functions and helpers
- **Edit**: `~/dotfiles/.config/zsh/functions.zsh`

### `99-local.zsh` (⚠️ GITIGNORED)
- **Purpose**: Machine-specific configuration (secrets, work-only aliases, local tools)
- **Location**: `~/.config/zsh/99-local.zsh` (NOT in repo, stays on local machine)
- **Template**: Copy from `~/.config/zsh/99-local.zsh.example`
- **Contains**: Keychain setup, work aliases, local overrides, credentials
- **Edit**: `~/.config/zsh/99-local.zsh` (your local machine only, not in repo)

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

### Using Bash
```bash
# Create machine-specific config
cp ~/.bashrc.d/99-local.bash.example ~/.bashrc.d/99-local.bash
nano ~/.bashrc.d/99-local.bash

# Add conditional settings for your machine
if [[ "$MACHINE_TYPE" == "hivenet_client" ]]; then
    export WORK_PATH="/path/to/work"
fi
```

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

**Important**: Your `~/.gitconfig` is **gitignored** and never committed. Each machine can have different settings (credentials, internal repos, etc.).

The `.gitconfig.example` in the repo is a reference template - edit your local `~/.gitconfig` file directly.

## 🔐 SSH Configuration

SSH configuration is also templated to protect sensitive hostnames and keys:

### Setup
```bash
# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Copy template
cp ~/dotfiles/.ssh/config.example ~/.ssh/config

# Edit with your actual hosts
nano ~/.ssh/config

# Secure permissions
chmod 600 ~/.ssh/config
```

### Example SSH Hosts
```bash
# After editing ~/.ssh/config, you can use:
ssh work           # Connects to work.example.com
ssh raspberry-pi   # Connects to pi.example.local
ssh internal-*     # Wildcard pattern with bastion proxy
```

**Important**: Your real `~/.ssh/config` is **gitignored** for security. The `.ssh/config.example` shows templates and patterns.

## 💬 MOTD (Message of the Day)

Custom user-level MOTD displays system information on shell startup:

### Features
- **10-system.sh**: Displays system info (uptime, memory, disk, CPU, architecture)
- **Shared by Bash and Zsh**: Displays once per session in both shells
- **20-custom.sh.example**: Template to add custom messages

### Customizing MOTD
```bash
# Copy example to create custom message
cp ~/.config/motd/20-custom.sh.example ~/.config/motd/20-custom.sh

# Edit your custom message
nano ~/.config/motd/20-custom.sh

# Make it executable
chmod +x ~/.config/motd/20-custom.sh

# Example custom message:
#!/usr/bin/env bash
echo "🚀 Welcome to $(hostname)!"
echo "Today's tasks: Check email, review PRs"
```

### MOTD Files
Each file in `~/.config/motd/` named `{00,10,20,30,40,50}-*.sh` is sourced at shell startup. Files execute in numerical order.

Create new files as needed:
```bash
cat > ~/.config/motd/30-reminders.sh << 'EOF'
#!/usr/bin/env bash
echo "⚠️  Don't forget: Update dependencies this week"
EOF
chmod +x ~/.config/motd/30-reminders.sh
```

## 🎨 Customization

### Add Machine-Specific Aliases
```bash
# Edit your local config (stays on this machine only)
nano ~/.config/zsh/99-local.zsh

# Add conditional aliases
if [[ "$IS_WORK_MACHINE" == true ]]; then
  keychain ~/.ssh/id_rsa --agents ssh -q
  alias workserver='telnet [your-internal-ip] 3335'
fi

if [[ "$IS_RASPBERRY_PI" == true ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
fi
```

### Add Custom Functions
```bash
# Edit functions.zsh in the repo (shared across machines)
nano ~/dotfiles/.config/zsh/functions.zsh

# Add your function
my_function() {
  echo "Custom function"
}

# Commit and push to share with other machines
cd ~/dotfiles && git add .config/zsh/functions.zsh && git commit -m "Add function"
```

### Add New Tools
```bash
# Edit 50-tools.zsh in the repo
nano ~/dotfiles/.config/zsh/50-tools.zsh

# Add your tool initialization (with command check for portability)
if command -v my-tool >/dev/null 2>&1; then
  eval "$(my-tool init zsh)"
fi

# Commit and push
cd ~/dotfiles && git add .config/zsh/50-tools.zsh && git commit -m "Add tool support"
```

### Add Portable Aliases
```bash
# Edit aliases.zsh for aliases that work on all machines
nano ~/dotfiles/.config/zsh/aliases.zsh

# Add alias (no hardcoded paths or IPs)
alias myalias='some-command'

# Commit and push
cd ~/dotfiles && git add .config/zsh/aliases.zsh && git commit -m "Add alias"
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
# After making changes
cd ~/dotfiles
git add .config/zsh/aliases.zsh
git commit -m "Add new aliases"
git push origin master
```

### Pull on Other Machines

```bash
# On another machine (Pi3, etc.), get latest changes
cd ~/dotfiles
git pull origin master
exec zsh  # Restart shell to reload config
```

### Setup New Machine

```bash
# Same as Quick Start above
git clone https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
# ... create symlinks, setup 99-local.zsh, restart shell
```

## 📝 .gitignore Details

Files that are **NOT** tracked by git:

```bash
# Local machine-specific configuration
.config/zsh/99-local.zsh

# Secrets and credentials
.config/secrets/

# Zsh runtime files (auto-generated, regenerated each shell)
.config/zsh/.zcompdump*
.config/zsh/.zsh_history
```

These are generated at runtime and should never be committed.

## 🐛 Troubleshooting

### GitHub authentication failed (password not supported)
```bash
# ❌ This no longer works (GitHub disabled password auth):
git clone https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
# Error: "Password authentication is not supported"

# ✅ Use SSH instead (recommended):
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
# Requires SSH key configured: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

# ✅ Or use Personal Access Token (PAT):
git clone --recursive https://<PAT>@github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
# Get PAT: https://github.com/settings/tokens (check "repo" scope)
# Then replace <PAT> with your actual token
```

### Shell won't start
```bash
# Check for syntax errors
zsh -n ~/.zshrc

# Load with verbose output
zsh -x ~/.zshrc 2>&1 | head -20
```

### Zsh theme (Powerlevel10k) looks broken
```bash
# This usually means you need to install Powerlevel10k fonts
# Download and install from: https://github.com/romkatv/powerlevel10k#fonts
# After installing, your prompt should look correct

# Or temporarily disable Powerlevel10k in 00-init-early.zsh
```

### Tools not initializing (fzf, brew, zoxide, etc.)
```bash
# Check if tool is installed and available
command -v fzf       # Check fzf
command -v zoxide    # Check zoxide
command -v brew      # Check brew
command -v atuin     # Check atuin

# If not found, install it:
# - Ubuntu/Debian: sudo apt install <package>
# - macOS: brew install <package>
# - Arch: sudo pacman -S <package>
```

### Symlink issues
```bash
# Verify symlink is correct
ls -l ~/.config/zsh
# Should show: ~/.config/zsh -> ~/dotfiles/.config/zsh

# If broken, recreate it
rm ~/.config/zsh
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
```

### Submodule Issues

**Submodules not cloned (empty directories)**
```bash
# If you cloned without --recursive
cd ~/dotfiles
git submodule update --init --recursive

# Or re-clone properly
cd ~
rm -rf dotfiles
git clone --recursive https://github.com/Pontuzz/dotfiles-starter.git ~/dotfiles
```

**Submodules not updating after `git pull`**
```bash
# git pull doesn't automatically update submodules
cd ~/dotfiles
git pull origin master
git submodule update --remote --merge

# Or as a single command:
git pull origin master && git submodule update --remote --merge
```

**Check submodule status**
```bash
git submodule status
# Shows: <commit-hash> <path> (<version/branch>)
# Example output:
# 67cd8c4 .config/zsh/.oh-my-zsh (heads/master)
# 0fb5488 .config/zsh/custom/plugins/fzf-dir-navigator (v1.2.2-5-g0fb5488)
```

**Update a specific submodule to latest**
```bash
# Update just one plugin/theme
git submodule update --remote .config/zsh/custom/plugins/zsh-bat
git add .config/zsh/custom/plugins/zsh-bat
git commit -m "Update zsh-bat plugin"
git push

# Or update everything at once
git submodule update --remote --merge
git add .gitmodules .config/zsh/
git commit -m "Update all submodules"
git push
```

### Platform detection not working
```bash
# Check what platform was detected
zsh -c "source ~/.config/zsh/20-machine-detect.zsh && \
  echo \"IS_WSL=\$IS_WSL IS_ARM=\$IS_ARM MACHINE_TYPE=\$MACHINE_TYPE\""
```

## 📚 Additional Resources

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
**Last updated**: February 1, 2026
