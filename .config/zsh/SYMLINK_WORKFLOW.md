# Symlink Workflow - Where to Edit

## TL;DR

- **Real files live in**: `~/dotfiles/.config/zsh/`
- **Symlink lives in**: `~/.config/zsh` (points to above)
- **Always edit**: `~/dotfiles/...` (the repo)
- **Never edit directly**: `~/.config/...` (it's just a symlink)

## Understanding the Setup

```
Your home directory:
~/.config/zsh → symlink pointing to → ~/dotfiles/.config/zsh

Real files:
~/dotfiles/.config/zsh/.zshrc          ← REAL FILE (this is what git tracks)
~/dotfiles/.config/zsh/aliases.zsh     ← REAL FILE
~/dotfiles/.config/zsh/*.zsh           ← REAL FILES

Symlinks (not real files):
~/.config/zsh/.zshrc                   ← symlink to above
~/.config/zsh/aliases.zsh              ← symlink to above
```

## Editing Files

### ✅ Correct Way (Recommended)

Edit files in the repo directly:
```bash
# Edit in the repo
nano ~/dotfiles/.config/zsh/aliases.zsh

# Reload your shell to apply changes
source ~/.zshrc

# Check in git for changes
cd ~/dotfiles && git diff .config/zsh/aliases.zsh
```

### ❌ What NOT to Do

Don't try to edit via the symlink location:
```bash
# This works BUT is confusing
nano ~/.config/zsh/aliases.zsh
# It will edit the file, but through the symlink

# Better to edit directly in repo
nano ~/dotfiles/.config/zsh/aliases.zsh
```

## File Locations Cheat Sheet

| File | Location | Purpose | Edit Here |
|------|----------|---------|-----------|
| Main config | `~/.config/zsh/.zshrc` | Loads all other files | `~/dotfiles/.config/zsh/.zshrc` |
| Early init | `~/.config/zsh/00-init-early.zsh` | Instant prompt, zellij | `~/dotfiles/.config/zsh/00-init-early.zsh` |
| Platform detect | `~/.config/zsh/20-machine-detect.zsh` | Auto-detect OS/machine | `~/dotfiles/.config/zsh/20-machine-detect.zsh` |
| Plugins | `~/.config/zsh/plugins.zsh` | Oh My Zsh setup | `~/dotfiles/.config/zsh/plugins.zsh` |
| Environment | `~/.config/zsh/40-env.zsh` | ENV variables | `~/dotfiles/.config/zsh/40-env.zsh` |
| Tools | `~/.config/zsh/50-tools.zsh` | Tool init (fzf, brew) | `~/dotfiles/.config/zsh/50-tools.zsh` |
| Aliases | `~/.config/zsh/aliases.zsh` | Portable aliases | `~/dotfiles/.config/zsh/aliases.zsh` |
| Functions | `~/.config/zsh/functions.zsh` | Custom functions | `~/dotfiles/.config/zsh/functions.zsh` |
| **Local config** | `~/.config/zsh/99-local.zsh` | Machine-specific | `~/.config/zsh/99-local.zsh` ⚠️ (LOCAL ONLY, NOT IN REPO) |
| Environment | `~/.zshenv` | Global env setup | `~/dotfiles/.zshenv` |

## Workflows

### Workflow 1: Edit & Reload (Most Common)

```bash
# 1. Edit file in repo
nano ~/dotfiles/.config/zsh/aliases.zsh

# 2. Reload shell to apply changes
source ~/.zshrc

# 3. Verify it works
alias | grep myalias

# 4. When satisfied, push to GitHub
cd ~/dotfiles && git add .config/zsh/aliases.zsh && git commit -m "Add alias" && git push
```

### Workflow 2: Machine-Specific Settings

```bash
# 1. Edit local config (ONLY on this machine, not in repo)
nano ~/.config/zsh/99-local.zsh

# 2. Add machine-specific stuff
if [[ "$IS_RASPBERRY_PI" == true ]]; then
  alias piupdate='sudo apt update && sudo apt upgrade -y'
fi

# 3. Reload
source ~/.zshrc

# 4. IMPORTANT: Don't commit this! (.gitignore prevents it)
cd ~/dotfiles && git status  # Should NOT show 99-local.zsh
```

### Workflow 3: Sync to Another Machine

```bash
# On Machine A (original)
cd ~/dotfiles
git add .config/zsh/aliases.zsh
git commit -m "Add new alias"
git push

# On Machine B (Pi3, etc)
cd ~/dotfiles
git pull
exec zsh  # Restart to apply
# Symlink automatically uses updated files!
```

## Behind the Scenes

When you type a command:
```bash
source ~/.zshrc
```

What happens:
1. Shell looks for `~/.zshrc`
2. Finds it's a symlink: `~/.zshrc → ~/dotfiles/.config/zsh/.zshrc`
3. Reads the REAL file: `~/dotfiles/.config/zsh/.zshrc`
4. That file sources other configs, also via symlinks
5. All symlinks point to the repo, so changes in repo are immediately available

## Git & Symlinks

Git doesn't care about symlinks—it tracks the **real files**:

```bash
cd ~/dotfiles

# Git sees changes to real files
git diff .config/zsh/aliases.zsh      # Shows what changed

# Git doesn't track symlinks themselves
ls -l ~/.config/zsh/aliases.zsh       # Is a symlink, but git doesn't care

# Push repo changes
git add .config/zsh/aliases.zsh
git commit -m "Update aliases"
git push
```

## Benefits of This Setup

✅ **Single source of truth**: Only one copy of each file  
✅ **Changes immediately available**: Edit file → reload shell, no copying needed  
✅ **Easy to share across machines**: Just `git pull` and all machines get updates  
✅ **Portable**: Same structure works on WSL, Linux, Pi, macOS  
✅ **Git-friendly**: Easy to commit and push changes  

## Troubleshooting

### "I edited the file but changes didn't take effect"
```bash
# Reload your shell
source ~/.zshrc
# or
exec zsh
```

### "I accidentally edited via the symlink, where's my file?"
```bash
# It's fine! The file was edited in the repo anyway
# Check the real location
cat ~/dotfiles/.config/zsh/aliases.zsh
```

### "I want to know if I changed something"
```bash
cd ~/dotfiles
git status                    # Shows all changes
git diff .config/zsh/aliases.zsh      # Shows exact changes
```

### "How do I verify the symlink is correct?"
```bash
ls -l ~/.config/zsh
# Should show: /home/[username]/.config/zsh -> /home/[username]/dotfiles/.config/zsh

# If not, recreate it:
rm ~/.config/zsh
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
```

## Remember

- 📝 **Edit files in**: `~/dotfiles/.config/zsh/`
- 🔗 **Symlink located in**: `~/.config/zsh/`
- 🔄 **Changes take effect after**: `source ~/.zshrc` or shell restart
- 📤 **Push to GitHub from**: `~/dotfiles/`
- ⚠️ **EXCEPT 99-local.zsh**: Stays local, never in repo
