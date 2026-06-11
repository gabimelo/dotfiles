export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="crunch"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  fzf-tab
  git
  z
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

if [[ -d "${ZSH_CUSTOM:-${ZSH}/custom}/plugins/zsh-completions/src" ]]; then
  fpath+=${ZSH_CUSTOM:-${ZSH}/custom}/plugins/zsh-completions/src
fi

if [[ -s "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
fi

if [[ "$(uname -s)" == "Darwin" && -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi

export TERM=xterm-256color
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export GH_DASH_CONFIG="$HOME/ghdashconfig.yml"

fd_command=""
if command -v fd >/dev/null 2>&1; then
  fd_command="fd"
elif command -v fdfind >/dev/null 2>&1; then
  fd_command="fdfind"
fi

if [[ -n "${fd_command}" ]]; then
  export FZF_DEFAULT_COMMAND="${fd_command} --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .tox"

  _fzf_compgen_path() {
    ${fd_command} --hidden --follow --exclude ".git" --exclude ".tox" . "$1"
  }

  _fzf_compgen_dir() {
    ${fd_command} --type d --hidden --follow --exclude ".git" --exclude ".tox" . "$1"
  }
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null || true
elif [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi

case $(uname -a) in
  *Microsoft*) unsetopt BG_NICE ;;
esac

export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init -)"
    if command pyenv virtualenv-init - >/dev/null 2>&1; then
      eval "$(command pyenv virtualenv-init -)"
    fi
    pyenv "$@"
  }
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell zsh)"
elif [[ -d "$HOME/.local/share/fnm" ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env --shell zsh)"
fi

if command -v ruby >/dev/null 2>&1; then
  ruby_gem_bin="$HOME/.local/share/gem/ruby/$(ruby -e 'puts RbConfig::CONFIG["ruby_version"]')/bin"
  [[ -d "$ruby_gem_bin" ]] && export PATH="$ruby_gem_bin:$PATH"
fi

if command -v git-spice >/dev/null 2>&1; then
  eval "$(git-spice shell completion zsh)"
elif command -v gs >/dev/null 2>&1; then
  eval "$(gs shell completion zsh)"
fi

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color=always $realpath'

custom_aliases="${ZSH_CUSTOM:-${ZSH}/custom}/custom_aliases.zsh"
if [[ -f "$custom_aliases" ]]; then
  source "$custom_aliases"
fi
