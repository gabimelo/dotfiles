#!/usr/bin/env bash

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "ubuntu_setup_1.sh requires apt-get."
  exit 1
fi

sudo apt-get update
sudo apt-get install -y zsh

zsh --version

if [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)"
fi
