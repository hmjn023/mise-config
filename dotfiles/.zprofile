# Login-shell environment formerly supplied by Home Manager.

# This machine uses the personal mise profile by default. Override per command
# with `mise -E work ...` when working on the other profile.
export MISE_ENV="${MISE_ENV:-personal}"

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export MCFLY_INTERFACE_VIEW="TOP"
export MCFLY_KEY_SCHEME="emacs"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export TMUX_TMPDIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
