# Dotfiles Starter

A modular, portable zsh configuration template that works across **WSL2, Linux, macOS, and Raspberry Pi**. Fork it, customize it, make it yours.

## Quick Start

```bash
# Clone and set up — one command does it all
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
~/dotfiles/setup.sh
```

**What `setup.sh` handles automatically:**
- Detects your distro (apt/pacman/dnf/brew/apk) and installs zsh, git, curl if missing
- Inits all git submodules (Oh My Zsh, plugins, powerlevel10k theme)
- Creates symlinks: `.zshenv`, `.bashrc`, `.profile`, `.gitconfig`, `.config/zsh`
- Backs up any existing config before overwriting
- Installs optional tools: fzf, zoxide, bat, ripgrep, jq, lsd
- Changes default shell to zsh

**Flags:**

| Flag | Purpose |
|------|---------|
| `--check` | Read-only preview (no changes) |
| `--minimal` | Skip optional tools, just shell + symlinks |

Then set up your machine-specific config:

```bash
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
cp ~/dotfiles/.gitconfig.example ~/.gitconfig
nano ~/.config/zsh/99-local.zsh   # Add your settings
nano ~/.gitconfig                  # Add your name and email
```

Restart your shell: `exec zsh`

---

## What's Included

| Category | Contents |
|----------|----------|
| **Shell** | Zsh + Bash config, modular `.zshrc` with ordered file sourcing |
| **Prompt** | Powerlevel10k with classic style, Nerd Font icons |
| **Plugins** | Syntax highlighting, autosuggestions, fzf, bat, lsd integrations |
| **Tools** | fzf, zoxide, atuin, thefuck, navi, fnm — all gracefully handled if missing |
| **MOTD** | Adaptive-width system dashboard (figlet banner, host info, resource bars) |
| **Platform detection** | Auto-detects WSL2, Linux, macOS, ARM, Raspberry Pi |
| **Git** | Templated `.gitconfig` and `.ssh/config` (credentials stay local) |

---

## Architecture

```
dotfiles/
├── setup.sh                         # One-command bootstrap
├── .zshenv                          # Global env setup (sourced by all shells)
├── .bashrc                          # Bash config hub
├── .profile                         # Login shell config
├── .gitconfig.example               # Template for ~/.gitconfig
│
├── .config/
│   ├── zsh/                         # Main zsh configuration
│   │   ├── .zshrc                   # Sources all modular files in order
│   │   ├── .p10k.zsh                # Powerlevel10k prompt config
│   │   ├── 00-init-early.zsh        # MOTD, instant prompt, Zellij
│   │   ├── 20-machine-detect.zsh    # Platform detection flags
│   │   ├── plugins.zsh              # Oh My Zsh plugins + completions
│   │   ├── 40-env.zsh               # Environment variables
│   │   ├── 50-tools.zsh             # Tool initializations
│   │   ├── aliases.zsh              # Portable aliases
│   │   ├── functions.zsh            # Helper functions
│   │   ├── 99-local.zsh.example     # Template for machine-specific config
│   │   ├── .oh-my-zsh/              # Oh My Zsh (submodule)
│   │   └── custom/plugins/          # 2 custom + 5 external plugins
│   │
│   └── motd/                        # User-level MOTD scripts
│       ├── 10-motd.sh               # System dashboard (adaptive width)
│       └── 20-custom.sh.example     # Template for custom messages
│
├── .bashrc.d/                       # Modular bash config (mirrors zsh)
├── .ssh/config.example              # Template for ~/.ssh/config
└── hooks/post-merge                 # Auto-updates submodules on pull
```

### Configuration Flow

```
.zshrc → 00-init-early → 20-machine-detect → plugins → 40-env → 50-tools → aliases → functions → 99-local (gitignored)
```

Each file has a specific purpose. Machine-specific overrides go in `99-local.zsh` (gitignored, stays on your machine).

---

## Customizing for Your Machine

### 1. Fork This Repo

Click "Fork" on GitHub, then clone your fork:

```bash
git clone --recursive git@github.com:YOUR_USER/dotfiles.git ~/dotfiles
```

### 2. Set Up Machine-Specific Config

**Required:** Create `~/.config/zsh/99-local.zsh` from the example template:

```bash
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
nano ~/.config/zsh/99-local.zsh
```

This is where you put:
- SSH key management (keychain, ssh-agent)
- Internal IPs or hostnames
- API tokens or credentials
- Work-specific paths and aliases
- Hardware-specific settings

The file is gitignored — safe for secrets, never gets committed.

### 3. Set Up Git

```bash
cp ~/dotfiles/.gitconfig.example ~/.gitconfig
nano ~/.gitconfig   # Add your name and email
```

Your `~/.gitconfig` is gitignored too — each machine can have different credentials.

### 4. Install Powerlevel10k Font

For the prompt icons to render correctly, install a [Nerd Font](https://github.com/romkatv/powerlevel10k#fonts) (Meslo Nerd Font recommended).

---

## Platform Detection

The config automatically detects your environment and sets these flags (usable in `99-local.zsh`):

```bash
IS_WSL=true/false         # Windows Subsystem for Linux
IS_LINUX=true/false       # Any Linux system
IS_MACOS=true/false       # macOS
IS_ARM=true/false         # ARM architecture (Pi, Apple Silicon)
IS_RASPBERRY_PI=true/false
MACHINE_TYPE=string       # "raspberry_pi", "workstation", "server", or "generic"
```

Example usage in `99-local.zsh`:

```bash
if [[ "$IS_RASPBERRY_PI" == true ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
fi

if [[ "$IS_WSL" == true ]]; then
  export BROWSER="explorer.exe"
fi
```

---

## Submodules

This repo uses git submodules for external dependencies:

- **Oh My Zsh** — Plugin framework (`.config/zsh/.oh-my-zsh`)
- **5 plugins** — fzf-dir-navigator, zsh-autosuggestions, zsh-bat, zsh-lsd, zsh-syntax-highlighting
- **1 theme** — powerlevel10k

Clone with `--recursive` to get everything at once. The post-merge hook auto-initializes submodules on every `git pull`, so you never need to remember.

---

## Dependencies

**Required:** zsh, git (both auto-installed by setup.sh)

**Optional (config works without them):**
fzf, zoxide, bat, ripgrep, lsd, eza, atuin, thefuck, navi, brew, keychain, hyperfine, jq

Missing tools won't break anything — every integration uses `command -v` checks. Suppress reminders for known-missing tools by adding to `99-local.zsh`:

```bash
DOTFILES_IGNORE_MISSING_TOOLS="thefuck navi eza"
```

---

## Updating

```bash
cd ~/dotfiles
git pull                             # post-merge hook auto-updates submodules
exec zsh                             # Reload to apply changes
```

---

## Tested On

- WSL2 (Ubuntu)
- Debian 13 (trixie, arm64/armhf)
- Raspberry Pi OS
- Arch Linux
- Fedora
- macOS (brew, untested on current version)

---

## License

MIT — See [LICENSE](LICENSE). Use it freely, fork it, build on it.

---

**Status**: ✅ Stable and portable  
**Tested on**: WSL2, Debian 13, Raspberry Pi OS, Arch, Fedora  
**Last updated**: July 20, 2026
