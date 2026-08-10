# User shell configuration migrated from Home Manager.

export WEZTERM_SHELL_SKIP_ALL=1
export GOPATH="$HOME/go"
export ANDROID_HOME="$HOME/Android/Sdk"
export NDK_HOME="$HOME/Android/Sdk/ndk/27.3.13750724"
export CARGO_HOME="$HOME/.cargo"
export NODEJS_CHECK_BINARY=0
export npm_config_prefix="$HOME/.npm-global"
export VISUAL=nvim
export EDITOR=nvim
export BROWSER=google-chrome-stable
export VCPKG_ROOT=/opt/vcpkg
export VCPKG_DOWNLOADS=/var/cache/vcpkg
export MAKEFLAGS="-j$(nproc --all 2>/dev/null || getconf _NPROCESSORS_ONLN)"

path=(
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "$HOME/Android/Sdk/platform-tools"
  "$HOME/flutter/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
  "/var/lib/snapd/snap/bin"
  $path
)
# Prefer the mise binary managed by this config once it has been installed.
# Before that first install, fall back to the system mise package.
MISE_SELF_BIN="${MISE_DATA_DIR:-$HOME/.local/share/mise}/installs/aqua-jdx-mise/latest/mise/bin"
if [[ -x "$MISE_SELF_BIN/mise" ]]; then
  path=("$MISE_SELF_BIN" $path)
fi
typeset -U path PATH

HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.history"
setopt EXTENDED_HISTORY

alias vi=nvim
alias cd=z
alias ls=lsd
alias la='ls -a'
alias ll='ls -ls'
alias lh='ls -lh'
alias setup='mise run setup'

# mise is the environment manager for this repository.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Keep the two plugins used by the old Home Manager module, but fetch them as
# ordinary bootstrap repositories instead of putting them in the Nix store.
ZSH_ROMAJI_DIR="$HOME/mise-config/vendor/zsh-romaji-complete"
NI_ZSH_FILE="$HOME/mise-config/vendor/ni.zsh/ni.zsh"
if [[ -d "$ZSH_ROMAJI_DIR" ]]; then
  fpath=("$ZSH_ROMAJI_DIR" $fpath)
fi
autoload -Uz compinit && compinit

if [[ -r "$ZSH_ROMAJI_DIR/zsh-romaji-complete.plugin.zsh" ]]; then
  source "$ZSH_ROMAJI_DIR/zsh-romaji-complete.plugin.zsh"
fi
if [[ -r "$NI_ZSH_FILE" ]]; then
  source "$NI_ZSH_FILE"
fi

if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
if command -v mcfly >/dev/null 2>&1; then
  eval "$(mcfly init zsh)"
fi

if command -v google-chrome-stable >/dev/null 2>&1; then
  export CHROME_EXECUTABLE="$(command -v google-chrome-stable)"
fi

if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi
if command -v npm >/dev/null 2>&1; then
  eval "$(npm completion)"
fi

# Lightweight WezTerm directory tracking (OSC 7).
if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  function wezterm_osc7_precmd() {
    printf "\033]7;file://%s%s\033\\" "$HOST" "$PWD"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd wezterm_osc7_precmd
fi

# Terminfo-based key settings.
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

[[ -n "${key[Home]}" ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]] && bindkey "${key[End]}" end-of-line
[[ -n "${key[Insert]}" ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-history
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-history
[[ -n "${key[Left]}" ]] && bindkey "${key[Left]}" backward-char
[[ -n "${key[Right]}" ]] && bindkey "${key[Right]}" forward-char
[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey "${key[Shift-Tab]}" reverse-menu-complete

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

bindkey "^I" menu-expand-or-complete

if [[ -f "$HOME/.config/broot/launcher/bash/br" ]]; then
  source "$HOME/.config/broot/launcher/bash/br"
fi

unset SSH_ASKPASS
