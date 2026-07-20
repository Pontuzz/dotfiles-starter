# Dotfiles Starter

A portable zsh configuration template for **WSL2, Linux, macOS, and Raspberry Pi**. Fork it, customize it, make it yours.

## Quick Start

```bash
git clone --recursive git@github.com:Pontuzz/dotfiles-starter.git ~/dotfiles
~/dotfiles/setup.sh
```

setup.sh auto-detects your distro (apt/pacman/dnf/brew/apk), installs zsh/git/curl if missing, inits submodules (Oh My Zsh + 5 plugins + p10k), creates symlinks, installs optional tools (fzf, zoxide, bat, ripgrep, jq, lsd), and changes your shell to zsh. Idempotent — `--check` for dry run, `--minimal` for shell-only.

**One-time per machine:**
```bash
cp ~/.config/zsh/99-local.zsh.example ~/.config/zsh/99-local.zsh
cp ~/dotfiles/.gitconfig.example ~/.gitconfig
exec zsh
```

## Layout

```
dotfiles/
├── setup.sh                         # Bootstrap
├── .zshenv                          # Global env (all shells) — XDG dirs, PATH
├── .bashrc → .bashrc.d/             # Bash hub — 6 modular files
├── .profile                         # Login shell
│
├── .config/zsh/                     # Primary zsh configuration
│   ├── .zshrc                       #   Sources in order + health checks + tools check
│   ├── .p10k.zsh                    #   Powerlevel10k prompt
│   ├── 00-init-early.zsh            #   MOTD, Zellij, instant prompt
│   ├── 20-machine-detect.zsh        #   Platform flags (IS_WSL, IS_LINUX, MACHINE_TYPE, etc.)
│   ├── plugins.zsh                  #   OMZ + 5 external + 2 custom plugins, completions
│   ├── 40-env.zsh                   #   EDITOR, NVM_DIR, WSL PATH filter
│   ├── 50-tools.zsh                 #   brew, zoxide, atuin, thefuck, fzf, fnm
│   ├── aliases.zsh                  #   40+ aliases (lsd/eza/cd guarded)
│   ├── functions.zsh                #   Helper functions
│   ├── 99-local.zsh                 #   [GITIGNORED] Machine override
│   └── 99-local.zsh.example         #   Template
│
├── .bashrc.d/                       # Bash mirrors zsh structure
├── .config/motd/                    # Adaptive-width system dashboard
├── .gitconfig.example               # Template (real .gitconfig gitignored)
├── .ssh/config.example              # Template (real config gitignored)
└── hooks/post-merge                 # Auto-inits submodules on pull
```

### Sourcing Order

```
.zshrc → 20-machine-detect → 00-init-early → plugins.zsh → 40-env → 50-tools → aliases → functions → 99-local
```

Each file handles one concern — platform detection, plugins, env vars, tool init, aliases, functions. Machine overrides in `99-local.zsh` (gitignored, sourced last).

## Configuration

### Platform Detection

Available in `99-local.zsh`:

```bash
IS_WSL              IS_LINUX            IS_MACOS            IS_ARM
IS_RASPBERRY_PI     MACHINE_TYPE        # "raspberry_pi", "workstation", "server", or "generic"
```

### Key .zshrc Behaviors

| Feature | What | Frequency |
|---------|------|-----------|
| **Startup guard** | Warns if shell init > 3s | Every shell |
| **Tool check** | Lists missing optional tools | 1x/day (stamp file) |
| **Tool suppression** | `DOTFILES_IGNORE_MISSING_TOOLS` | Per-machine in 99-local.zsh |
| **Symlink health** | Verifies critical symlinks | Every shell |
| **Git hooks** | Auto-configures post-merge for submodules | 1x ever |
| **MOTD** | Adaptive dashboard (3 width tiers) | Once/session |
| **History** | SHARE_HISTORY, XDG path, 50k entries | Persistent |

### Machine-Specific Config

`99-local.zsh` is gitignored and sourced last — for SSH key management, internal IPs, API tokens, work-specific aliases, hardware settings. `.gitconfig` and `.ssh/config` are also gitignored — copy from `.example` templates.

### Submodules

| Component | Path |
|-----------|------|
| Oh My Zsh | `.config/zsh/.oh-my-zsh` |
| fzf-dir-navigator, zsh-autosuggestions, zsh-bat, zsh-lsd, zsh-syntax-highlighting | `.config/zsh/custom/plugins/` |
| powerlevel10k | `.config/zsh/custom/themes/` |
| lazy-loader, performance-monitor | Embedded (in-repo) |

Clone with `--recursive`. Post-merge hook auto-inits on `git pull`.

## Documentation

| Doc | Covers |
|-----|--------|
| [ARCHITECTURE.md](.config/zsh/ARCHITECTURE.md) | Design, file purposes, portable vs personal separation |
| [PORTABLE_SETUP.md](.config/zsh/PORTABLE_SETUP.md) | Setup reference, platform detection, file structure |
| [SYMLINK_WORKFLOW.md](.config/zsh/SYMLINK_WORKFLOW.md) | Editing workflow, symlink mechanics |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Auth, slow startup, submodule issues |

**Dependencies:** Required — zsh, git. Optional (config survives without) — fzf, zoxide, bat, ripgrep, lsd, eza, atuin, thefuck, navi, brew, keychain, jq. All tool integrations use `command -v` guards.

## Updating

```bash
cd ~/dotfiles && git pull          # post-merge inits submodules
exec zsh
```

---

**License:** MIT  
**Tested on:** WSL2 (Ubuntu), Debian 13, Raspberry Pi OS, Arch, Fedora  
**Last updated:** July 20, 2026
