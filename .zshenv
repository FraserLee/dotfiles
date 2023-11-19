# rust stuff
. "$HOME/.cargo/env"

# add local bin to path
PATH="$HOME/.local/bin:$PATH"

PATH="$HOME/.ghcup/bin:$PATH"
PATH="$HOME/.cabal/bin:$PATH"

PATH="/usr/local/opt/icu4c/bin:$PATH"
PATH="/usr/local/opt/icu4c/sbin:$PATH"

# opam configuration
test -r /Users/fraser/.opam/opam-init/init.sh && . /Users/fraser/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
