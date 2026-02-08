# https://thucnc.medium.com/how-to-show-current-git-branch-with-colors-in-bash-prompt-380d05a24745
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[%F{cyan}\1%f] /'
}
setopt prompt_subst
export PS1="%n: %F{cyan}%~%f \$(parse_git_branch)%# "

# setup a good default prompt
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

# brew
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath+=(/opt/homebrew/share/zsh/site-functions)

# some useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -aAlFG'
alias 777='chmod -R 777'
alias 755='chmod -R 755'
alias e='nvim'
alias h='history'
alias mkdir='mkdir -p'
alias python='python3'
alias pip='python3 -m pip'
alias c='clang++ -std=c++11 -Wall -Wextra -Wpedantic -Werror'
alias lg='lazygit'
alias mdscript='~/mdscript/mdwatch.py'
alias dungeon='~/dungeon-note-3/dungeon.py'
alias synopsis='/Users/fraser/synopsis/synopsis.py'

alias x86_brew='arch -x86_64 /usr/local/bin/brew'

alias claude='SHELL="/bin/bash" claude'

# git log but short
alias gl='git log --pretty=format:"%h --- %ae --- %s"'
# git log but short but with file names
alias glf='git log --name-status --pretty=format:"%h --- %ae --- %s"'

# mkdir and cd in one
mkcd() { mkdir $1 ; cd $1 }

# I always forget what tokei is called
alias loc 'tokei'

# better cd
eval "$(zoxide init zsh)"
alias cd='z'

# fzf integration
source <(fzf --zsh)

# use bat to make man pages more colourful
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# never make a noise ever please
set visualbell
set t_vb=


# autocomplete to history when pressing up
# https://unix.stackexchange.com/a/672892
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

export HISTSIZE=1000000000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY

setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# automatically source .venv if we're starting in that directory

if [[ -d ".venv" && "$VIRTUAL_ENV" != "$(pwd)/.venv" ]]; then
    source .venv/bin/activate
fi
