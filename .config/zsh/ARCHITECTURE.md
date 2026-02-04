# Dotfiles Architecture: Personal Configuration Pattern

## Overview

This dotfiles repository uses a **clear separation between portable and personal configuration**.

**Personal (Gitignored):**
- Machine-specific setup
- Infrastructure aliases and service references
- Local environment variables
- Sensitive paths and tool locations
- Anything that doesn't make sense on other machines

**Portable (Tracked):**
- Cross-platform aliases and functions
- Tool initialization and setup
- Generic environment variables
- Documentation and templates
- Setup guides

## File Structure & Purpose

### Portable Configuration (Tracked in Git)

```
.config/zsh/
├── .zshrc                    # Main config hub (sources everything)
├── 00-init-early.zsh         # Early initialization (instant prompt, keychain)
├── 20-machine-detect.zsh     # Platform detection flags
├── plugins.zsh               # Plugin configuration
├── 40-env.zsh                # Environment variables (portable)
├── 50-tools.zsh              # Tool initialization (fzf, zoxide, atuin, etc.)
├── aliases.zsh               # Portable aliases (ll, la, grep, etc.)
├── functions.zsh             # Custom helper functions
├── .p10k.zsh                 # Powerlevel10k theme config
├── 99-local.zsh.example      # TEMPLATE: Shows what goes in personal config
└── custom/plugins/
    ├── lazy-loader/          # Custom lazy loader plugin
    ├── my-alias/             # Only portable aliases (no service-specific refs)
    ├── my-ssh/               # SSH helper functions
    └── performance-monitor/  # Performance monitoring plugin
```

### Personal Configuration (Gitignored)

```
~/.config/zsh/
├── 99-local.zsh              # YOUR MACHINE: Machine-specific config (GITIGNORED)
│
├── .local/                    # Optional: Personal function overrides
│   ├── aliases-services.zsh  # Service aliases ([internal-tool], avdump, etc.)
│   ├── functions-personal.zsh # Personal function implementations
│   └── env-local.zsh         # Local environment variables
│
└── .secrets/                  # Optional: Credentials and secrets (GITIGNORED)
    ├── credentials.env        # API keys, tokens, passwords
    └── ssh-config.local       # SSH host-specific settings
```

## Configuration Flow

When you start a zsh session:

```
1. .zshrc                  # Sources all modular files
   ├── 20-machine-detect.zsh   # Sets: IS_HIVENET_CLIENT, IS_RASPBERRY_PI, etc.
   ├── 00-init-early.zsh       # Early setup (instant prompt, keychain)
   ├── plugins.zsh             # Loads Oh My Zsh + plugins
   ├── 40-env.zsh              # Portable environment variables
   ├── 50-tools.zsh            # Tool initialization (brew, zoxide, fzf)
   ├── aliases.zsh             # Portable aliases
   ├── functions.zsh           # Portable functions
   ├── 99-local.zsh            # [YOUR MACHINE CONFIG - if exists]
   │   ├── Machine-specific aliases ([internal-tool], avdump, etc.)
   │   ├── Local environment setup
   │   └── Service-specific configuration
   │
   └── .local/**/*.zsh         # [OPTIONAL: Personal overrides - if exist]
       ├── Custom function implementations
       └── Additional service configurations
```

## What Goes Where?

### ✅ Portable Configuration (track in git)

**`aliases.zsh` - Cross-platform aliases:**
```bash
alias ll='ls -lh'
alias la='ls -A'
alias cd='z'
alias grep='grep --exclude-dir={.git,.vscode}'
alias please=sudo
```

**`functions.zsh` - Helper functions:**
```bash
# Extract any archive
extract() {
  case $1 in
    *.zip) unzip "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    # ... other formats
  esac
}

# Find and cd into directory
fcd() {
  cd "$(find . -type d -name "*$1*" | head -1)"
}
```

**`40-env.zsh` - Standard environment:**
```bash
export EDITOR="nano"
export LANG="en_US.UTF-8"
export HISTSIZE=50000
```

**`50-tools.zsh` - Tool initialization:**
```bash
# fzf fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# zoxide smart cd
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
```

### ⚠️ Personal Configuration (gitignored)

**`99-local.zsh` - Machine-specific setup:**
```bash
# Machine-specific aliases
if [[ "$IS_HIVENET_CLIENT" == true ]]; then
  alias [internal-tool]='telnet [your-internal-ip] 3335'
  alias avdump='dotnet /mnt/g/02\ -\ Utilities/[media-tool]/...'
fi

# Machine-specific environment
export WORK_PATH="/path/to/work"
export LOCAL_TOOLS="/usr/local/tools"

# Machine-specific functions
my_deploy() {
  # Internal infrastructure deployment
}
```

**`.local/services.zsh` - Service configurations:**
```bash
# Internal service aliases
alias myservice='ssh myservice.internal'
alias internaldb='mysql -h [your-internal-ip] -u admin'

# Service-specific helper
connect_to_work() {
  ssh -p 2222 user@work.internal
}
```

**`.secrets/credentials.env` - Secrets (NEVER commit):**
```bash
export GITHUB_TOKEN="ghp_xxxxx..."
export INTERNAL_API_KEY="sk_live_xxx..."
export DB_PASSWORD="secret123"
```

## Setting Up on a New Machine

**For complete setup instructions, see [README.md Quick Start section](../../README.md#-quick-start) (lines 52-116).**

This section explains the design; for step-by-step setup, refer to README.md.

### Quick Reference

The setup process in README.md covers:
1. Clone with `--recursive` (gets submodules)
2. Create symlinks to repo files
3. Set up git and SSH config (optional)
4. Create personal config from `99-local.zsh.example`
5. Set up MOTD (optional)
6. Restart shell

After following README.md setup, the configuration flow works as documented in this file (lines 60-80).

## Design Principles

### 1. **Portable First**
Everything in tracked files should work on any machine where zsh is installed. Use platform detection flags, not hardcoded paths.

### 2. **Personal by Exception**
Only put machine-specific config in `99-local.zsh` and `.local/`. Everything else should be portable.

### 3. **Clear Separation**
Comments in portable files indicate what goes where:
```bash
# In aliases.zsh (portable):
# Personal service aliases belong in ~/.config/zsh/99-local.zsh

# In my-alias plugin (portable):
# Note: Infrastructure aliases are in 99-local.zsh (not tracked)
```

### 4. **Template-Based Customization**
Users customize by copying examples:
```bash
cp 99-local.zsh.example 99-local.zsh
# Edit with your personal setup
```

### 5. **Platform Detection**
Portable config adapts using detection flags:
```bash
if [[ "$IS_HIVENET_CLIENT" == true ]]; then
  # HiveNet-specific setup
fi

if [[ "$IS_RASPBERRY_PI" == true ]]; then
  # Pi-specific setup
fi
```

## Maintenance

### Adding Portable Features
When adding something that should work on all machines:
1. Add to appropriate tracked file (`aliases.zsh`, `functions.zsh`, etc.)
2. Test on multiple platforms if possible
3. Use `command -v` checks for optional tools
4. Add platform detection if machine-specific

### Adding Personal Features
When adding machine-specific functionality:
1. Add to `99-local.zsh` (automatically gitignored)
2. Or create files in `.local/` directory (also gitignored)
3. Always source from `.zshrc` or `99-local.zsh`
4. Document in comments what's personal vs. portable

### Updating Across Machines
```bash
# On machine with changes
cd ~/dotfiles
git add .config/zsh/aliases.zsh  # Only portable changes
git commit -m "Update portable aliases"
git push

# On other machines
cd ~/dotfiles
git pull
exec zsh  # Reload
```

## Files Overview

| File | Purpose | Scope | Track? |
|------|---------|-------|--------|
| `.zshrc` | Config hub, sources everything | All machines | ✅ |
| `00-init-early.zsh` | Early initialization | All machines | ✅ |
| `20-machine-detect.zsh` | Platform/hostname detection | All machines | ✅ |
| `plugins.zsh` | Plugin loading | All machines | ✅ |
| `40-env.zsh` | Standard environment variables | All machines | ✅ |
| `50-tools.zsh` | Tool initialization | All machines | ✅ |
| `aliases.zsh` | Portable aliases | All machines | ✅ |
| `functions.zsh` | Portable functions | All machines | ✅ |
| `99-local.zsh.example` | Template for personal setup | Example/template | ✅ |
| `99-local.zsh` | Personal machine setup | This machine only | ❌ |
| `.local/` | Personal overrides | This machine only | ❌ |
| `.secrets/` | Credentials/secrets | This machine only | ❌ |

## Troubleshooting

### Personal aliases not loading
Check that `99-local.zsh` exists and is sourced:
```bash
[ -f ~/.config/zsh/99-local.zsh ] && source ~/.config/zsh/99-local.zsh
# This line should be in .zshrc
```

### Portable aliases conflicting with personal
Keep personal versions in `99-local.zsh` (loaded after portable config):
```bash
# Portable (in aliases.zsh)
alias myalias='command1'

# Personal override (in 99-local.zsh)
alias myalias='command2'  # This takes precedence (loaded later)
```

### Git tracking the wrong files
Check `.gitignore` is correct:
```bash
cat .config/zsh/.gitignore | grep 99-local
# Should show: 99-local.zsh (without the !99-local.zsh.example exception)
```

---

**Summary**: This dotfiles repo is personal and designed for personal use. Portable configuration is tracked in git and works across machines. Personal/infrastructure config stays in gitignored files (`99-local.zsh`, `.local/`, `.secrets/`) and never leaves your machines.
