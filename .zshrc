# Note to self: keep this fairly minimal

# setup a good default prompt
PROMPT='%n: %F{blue}%~%f %# '

# vim style editing
set -o vi

# some useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -alF'
alias la='ls -A'
alias 777='chmod -R 777'
alias 755='chmod -R 755'
alias v='nvim'
alias mkdir='mkdir -p'
mkdircd() { mkdir $1 ; cd $1 }
alias mkcd='mkdircd'

# make alias echo what it's aliasing
a_echo() {
    echo "alias $1='$2'"
    alias $1="$2"
}
# - my scripts
a_echo mdscript '~/mdscript/mdwatch.py'
# - my directories
a_echo school 'cd ~/school'
# for every directory in ~/school, create an alias
for dir in $(ls -d ~/school/*/); do
    dir=${dir%*/}
    a_echo "${dir##*/}" "cd $dir"
done

# colours
source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"

# allow "fuck" to correct typos
eval $(thefuck --alias)

# never make a noise ever please
set visualbell
set t_vb=

clear
