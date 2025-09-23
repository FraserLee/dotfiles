# rust stuff

# add local bin to path
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.ghcup/bin:$PATH"
PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/go/bin:$PATH"

PATH="/usr/local/opt/icu4c/bin:$PATH"
PATH="/usr/local/opt/icu4c/sbin:$PATH"

# opam configuration
test -r /Users/fraser/.opam/opam-init/init.sh && . /Users/fraser/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# add scripts folder to path
PATH=$HOME/dotfiles/scripts:$PATH

PATH="/Users/fraser/.nimble/bin:$PATH"

PATH="/usr/local/sbin:$PATH"

HAXE_STD_PATH="/usr/local/lib/haxe/std"

# RUSTC_WRAPPER="/usr/local/bin/sccache"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/fraser/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"
