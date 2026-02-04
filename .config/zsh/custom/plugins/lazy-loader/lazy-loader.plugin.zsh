# Lazy Loading Plugin for Better Performance
# This delays initialization of heavy tools until first use

# Function to create lazy loading wrapper
_lazy_load () {
    local command="$1"
    local init_command="$2"
    
    eval "$command() {
        unfunction $command
        $init_command
        $command \"\$@\"
    }"
}

# Lazy load pyenv (only when python commands are used)
if command -v pyenv > /dev/null 2>&1; then
    _lazy_load pyenv 'eval "$(pyenv init -)"'
    _lazy_load python 'eval "$(pyenv init -)"; python'
    _lazy_load pip 'eval "$(pyenv init -)"; pip'
fi

# Lazy load rbenv (only when ruby commands are used)
if command -v rbenv > /dev/null 2>&1; then
    _lazy_load rbenv 'eval "$(rbenv init - zsh)"'
    _lazy_load ruby 'eval "$(rbenv init - zsh)"; ruby'
    _lazy_load gem 'eval "$(rbenv init - zsh)"; gem'
fi

# Lazy load nvm (only when node commands are used)
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    _lazy_load nvm '. "$NVM_DIR/nvm.sh"'
    _lazy_load node '. "$NVM_DIR/nvm.sh"; nvm use default > /dev/null 2>&1; node'
    _lazy_load npm '. "$NVM_DIR/nvm.sh"; nvm use default > /dev/null 2>&1; npm'
    _lazy_load npx '. "$NVM_DIR/nvm.sh"; nvm use default > /dev/null 2>&1; npx'
    _lazy_load yarn '. "$NVM_DIR/nvm.sh"; nvm use default > /dev/null 2>&1; yarn'
fi

# Add lazy loading for other common development tools
if command -v cargo > /dev/null 2>&1; then
    _lazy_load rustc '. "$HOME/.cargo/env"; rustc'
    _lazy_load cargo '. "$HOME/.cargo/env"; cargo'
fi

# Clean up helper function
unfunction _lazy_load
