#!/usr/bin/env bash

set -euo pipefail

if [[ ! "${SHELL:-}" =~ "/zsh" ]]; then
  echo "Not running on Zsh"
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "ubuntu_setup_2.sh requires apt-get."
  exit 1
fi

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ca-certificates curl git

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
