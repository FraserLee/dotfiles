# setup a good default prompt
# https://thucnc.medium.com/how-to-show-current-git-branch-with-colors-in-bash-prompt-380d05a24745
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[%F{cyan}\1%f] /'
}
setopt prompt_subst
export PS1="%n: %F{cyan}%~%f \$(parse_git_branch)%# "
# export PS1='%n: %F{cyan}%~%f %# '

# make directories visible for ls
export LSCOLORS="gxfxcxdxbxegedabagacad"

# vim style editing
# set -o vi
# bindkey -v
bindkey -v '^?' backward-delete-char # fix backspace behaviour

# if command not found, try to cd to it
setopt auto_cd

# include .* in *
set -s dotglob

# don't worry about overwriting files with '>'
set +o noclobber

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
alias pip='python3 -m pip'

# git log but short
alias gl='git log --pretty=format:"%h --- %ae --- %s"'
# git log but short but with file names
alias glf='git log --name-status --pretty=format:"%h --- %ae --- %s"'

# mkdir and cd in one
mkcd() { mkdir $1 ; cd $1 }

# I always forget what tokei is called
a_echo loc 'tokei'

# single command to update everything
update_all() {
    echo "---- Update all: Brew ----"
    brew update
    brew upgrade
    echo "---- Update all: Rust ----"
    rustup self update
    rustup update
    echo "---- Update all: ghcup ----"
    ghcup upgrade
    echo "---- Update all: done ----"
    # possibly add more
}

# colours
source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"

# allow "fuck" to correct typos
eval $(thefuck --alias)

# better cd
eval "$(zoxide init zsh)"
alias cd='z'

# set i "inspect" to be ls if target is a directory, otherwise bat
i() { if [ -d "$1" ]; then ls -aAlFG "$1"; else bat "$1"; fi }

# never make a noise ever please
set visualbell
set t_vb=

# env things
export PATH="/usr/local/opt/node@16/bin:$PATH"
export PATH="/Users/fraser/.nimble/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/openjdk@17/bin:$PATH" 
export HAXE_STD_PATH="/usr/local/lib/haxe/std"
# export RUSTC_WRAPPER="/usr/local/bin/sccache"
eval $(opam env)

export PATH="/usr/local/opt/openjdk@17/bin:$PATH" # manually drop java version
JAVA_HOME=$(/usr/libexec/java_home -v 17)         # down to 17. Delete these lines
export JAVA_HOME                                  # after finishing comp520.

# use bat to make man pages more colourful
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

clear
