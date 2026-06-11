#!/usr/bin/env bash

set -euo pipefail

read -r -p "Git email: " git_email

git config --global user.email "${git_email}"
git config --global user.name "Gabriela Melo"

ssh_key="${HOME}/.ssh/id_ed25519"

if [[ ! -f "${ssh_key}" ]]; then
  ssh-keygen -t ed25519 -C "${git_email}" -f "${ssh_key}"
fi

if ! ssh-add "${ssh_key}" >/dev/null 2>&1; then
  eval "$(ssh-agent -s)"
  ssh-add "${ssh_key}"
fi

cat "${ssh_key}.pub"
