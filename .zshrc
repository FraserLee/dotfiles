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
alias c='clang++ -std=c++11 -Wall -Wextra -Wpedantic -Werror'
alias lg='lazygit'
alias mdscript='~/mdscript/mdwatch.py'
alias dungeon='~/dungeon-note-3/dungeon.py'

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




export HISTSIZE=1000000000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY

setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

clear


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/fraser/.opam/opam-init/init.zsh' ]] || source '/Users/fraser/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
