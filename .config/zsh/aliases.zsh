#!/usr/bin/env zsh
# Custom portable aliases extracted from my-alias plugin
# Cross-platform and machine-agnostic aliases only
# Machine-specific aliases belong in 99-local.zsh (gitignored)
#
# References:
# - https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.vh7hhm6th
# - https://github.com/webpro/dotfiles/blob/master/system/.alias
# - https://github.com/mathiasbynens/dotfiles/blob/master/.aliases

## Configuration ##
alias ref="source ~/.config/zsh/.zshrc"

## Navigation ##
alias cd='z'
alias zz='z -'
alias cht="cht.sh --shell"

## List utilities (lsd/eza) ##
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias ll="eza -alh"
alias ett="eza --tree"

## Editors ##
alias enw='emacs -nw'
alias vi=vim
alias nv=nvim

## Fun utilities ##
alias wttr="curl https://wttr.in/Norrköping"

## Single character shortcuts ##
alias _="sudo"
alias g="git"

## Better defaults ##
alias ping='ping -c 5'
alias grep="command grep --exclude-dir={.git,.vscode}"

## Directories ##
alias secrets="cd ${XDG_DATA_HOME:-~/.local/share}/secrets"

## Typo fixes ##
alias get=git
alias quit='exit'
alias cd..='cd ..'
alias qq='exit'

## Archive utilities ##
alias tarls="tar -tvf"
alias untar="tar -xf"

## Date/Time ##
alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"
alias isodate="date +%Y-%m-%dT%H:%M:%S%z"
alias utc="date -u +%Y-%m-%dT%H:%M:%SZ"
alias unixepoch="date +%s"

## Homebrew ##
alias brewup="brew update && brew upgrade && brew cleanup"
alias brewinfo="brew leaves | xargs brew desc --eval-all"

## Disk usage ##
alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
alias dux='du -x --max-depth=1 | sort -n'
alias dud='du -d 1 -h'
alias duf='du -sh *'

## URL encoding/decoding ##
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

## Misc utilities ##
alias please=sudo
alias zshrc='${EDITOR:-nano} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'
alias cls="clear && printf '\e[3J'"

## Print diagnostics ##
alias print-fpath='for fp in $fpath; do echo $fp; done; unset fp'
alias print-path='echo $PATH | tr ":" "\n"'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

## Image utilities ##
alias autorotate="jhead -autorot"

## Dotfiles ##
alias dotf='cd "$DOTFILES"'
alias dotfed='cd "$DOTFILES" && ${VISUAL:-${EDITOR:-nano}} .'
alias dotfl="cd \$DOTFILES/local"
alias zdot='cd $ZDOTDIR'

## Java ##
alias setjavahome="export JAVA_HOME=\`/usr/libexec/java_home\`"

## Todo utilities ##
alias t="todo.sh"
alias todos="$VISUAL $HOME/Desktop/todo.txt"

## Cat replacement (bat/batcat) ##
if command -v bat > /dev/null; then
    alias cat="bat"
elif command -v batcat > /dev/null; then
    alias cat="batcat"
fi
