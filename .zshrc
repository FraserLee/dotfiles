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
alias loc 'tokei'

# allow "fuck" to correct typos
eval $(thefuck --alias)

# better cd
eval "$(zoxide init zsh)"
alias cd='z'

# fzf integration
source <(fzf --zsh)

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

# use bat to make man pages more colourful
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# autocomplete to history when pressing up
# https://unix.stackexchange.com/a/672892
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

clear
