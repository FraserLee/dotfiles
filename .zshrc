# Note to self: keep this fairly minimal

# setup a good default prompt
PROMPT='%n: %F{blue}%~%f %# '

# vim style editing
set -o vi

# some useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -aAlFG'
alias 777='chmod -R 777'
alias 755='chmod -R 755'
alias e='nvim'
alias crago='cargo' # inside joke
alias krago='cargo'
alias mkdir='mkdir -p'
alias python='python3'
alias py='python3'
alias pip='pip3'

mkdircd() { mkdir $1 ; cd $1 }
alias mkcd='mkdircd'

# make alias echo what it's aliasing
a_echo() {
    echo "alias $1='$2'"
    alias $1="$2"
}
# - my scripts
a_echo mdscript '~/mdscript/mdwatch.py'
a_echo dw '~/dungeon-note-3/target/debug/dungeon-watch'
# - my directories
a_echo school 'cd ~/school'
a_echo gamedev 'cd ~/gamedev'
a_echo keyboard 'cd ~/keyboard'
a_echo resume 'cd ~/resume'
a_echo chinese 'cd ~/Desktop/chinese'
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

# env things
export PATH="/usr/local/opt/node@16/bin:$PATH"
export PATH="/Users/fraser/.nimble/bin:$PATH"
export HAXE_STD_PATH="/usr/local/lib/haxe/std"
export PATH="/usr/local/sbin:$PATH"
# export RUSTC_WRAPPER="/usr/local/bin/sccache"
eval $(opam env)

# use bat to make man pages more colourful
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

clear
