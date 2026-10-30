#!/usr/bin/env bash

set -euo pipefail

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
timestamp="$(date +%Y%m%d%H%M%S)"

has() {
  command -v "$1" >/dev/null 2>&1
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

is_apt_linux() {
  has apt-get
}

backup_path() {
  local path="$1"
  if [[ -e "${path}" || -L "${path}" ]]; then
    mv "${path}" "${path}.bak.${timestamp}"
  fi
}

link_path() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "${target}")"

  if [[ -L "${target}" && "$(readlink "${target}")" == "${source}" ]]; then
    return 0
  fi

  if [[ -e "${target}" || -L "${target}" ]]; then
    backup_path "${target}"
  fi

  ln -s "${source}" "${target}"
}

install_apt_packages() {
  sudo apt-get update
  sudo apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    fd-find \
    fzf \
    git \
    htop \
    jq \
    make \
    neovim \
    npm \
    ripgrep \
    ruby-full \
    tmux \
    tree \
    unzip \
    vim \
    wget \
    xclip \
    zsh

  for package in gh git-delta lazygit; do
    sudo apt-get install -y "${package}" || echo "Skipped optional apt package: ${package}"
  done
}

install_brew_packages() {
  if ! has brew; then
    echo "Homebrew is not installed. Skipping macOS package installation."
    return 0
  fi

  brew install \
    ast-grep \
    fd \
    fnm \
    fzf \
    gh \
    git \
    git-delta \
    htop \
    jq \
    lazygit \
    neovim \
    pyenv \
    ripgrep \
    tmux \
    tmuxinator \
    tree \
    zsh
}

npm_install_global() {
  if is_macos || [[ -w "$(npm root -g)" ]]; then
    npm install --global "$@"
  else
    sudo npm install --global "$@"
  fi
}

clone_zsh_plugin() {
  local repo="$1"
  local name="$2"
  local custom_dir="${ZSH_CUSTOM:-${ZSH:-${HOME}/.oh-my-zsh}/custom}"
  local target="${custom_dir}/plugins/${name}"

  if [[ -d "${target}" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "${target}")"
  git clone --depth 1 "${repo}" "${target}"
}

install_zsh_plugins() {
  if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    echo "Oh My Zsh is not installed. Run ubuntu_setup_2.sh on Ubuntu or install it manually first."
    return 0
  fi

  clone_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
  clone_zsh_plugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
  clone_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
  clone_zsh_plugin "https://github.com/Aloxaf/fzf-tab" "fzf-tab"
}

install_optional_tools() {
  if has gh; then
    gh extension list | grep -q "dlvhdr/gh-dash" || gh extension install dlvhdr/gh-dash
  fi

  if has npm; then
    has ast-grep || npm_install_global @ast-grep/cli
    has pyright-langserver || npm_install_global pyright typescript-language-server typescript
  fi

  if ! has fnm && ! is_macos; then
    curl -fsSL https://fnm.vercel.app/install | bash
  fi

  if ! has pyenv && [[ ! -d "${HOME}/.pyenv" ]]; then
    curl https://pyenv.run | bash
  fi

  if has gem && ! has tmuxinator; then
    gem install tmuxinator --user-install
  fi
}

configure_git_delta() {
  if has delta; then
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
  fi
}

link_configs() {
  link_path "${dotfiles_dir}/conf/.zshrc" "${HOME}/.zshrc"
  link_path "${dotfiles_dir}/conf/custom_aliases.zsh" "${ZSH_CUSTOM:-${ZSH:-${HOME}/.oh-my-zsh}/custom}/custom_aliases.zsh"
  link_path "${dotfiles_dir}/conf/.tmux.conf" "${HOME}/.tmux.conf"
  link_path "${dotfiles_dir}/conf/.ripgreprc" "${HOME}/.ripgreprc"
  link_path "${dotfiles_dir}/conf/nvim" "${HOME}/.config/nvim"
  link_path "${dotfiles_dir}/conf/ghdashconfig.yml" "${HOME}/ghdashconfig.yml"

  link_path "${dotfiles_dir}/conf/agents/AGENTS.md" "${HOME}/.codex/AGENTS.md"
  link_path "${dotfiles_dir}/conf/agents/codex/hooks.json" "${HOME}/.codex/hooks.json"
  link_path "${dotfiles_dir}/conf/agents/codex/rules" "${HOME}/.codex/rules"
  link_path "${dotfiles_dir}/conf/agents/AGENTS.md" "${HOME}/.claude/CLAUDE.md"
  link_path "${dotfiles_dir}/conf/agents/claude/settings.json" "${HOME}/.claude/settings.json"
  link_path "${dotfiles_dir}/conf/agents/claude/hooks/attention.sh" "${HOME}/.claude/hooks/attention.sh"
  link_path "${dotfiles_dir}/conf/agents/ccstatusline_settings.json" "${HOME}/.config/ccstatusline/settings.json"
}

main() {
  mkdir -p "${HOME}/Projects" "${HOME}/src"

  if is_apt_linux; then
    install_apt_packages
  elif is_macos; then
    install_brew_packages
  else
    echo "Unsupported OS for package installation. Linking configs only."
  fi

  install_zsh_plugins
  install_optional_tools
  configure_git_delta
  link_configs

  echo "Dotfiles install complete."
}

main "$@"
