# dotfiles

Personal dotfiles and new-machine setup scripts.

## Ubuntu Setup

Run the Ubuntu scripts in order. The first two are intentionally separate because
changing the default shell needs a new login before continuing.

```sh
./ubuntu_setup_1.sh
```

Log out and back in with zsh as the default shell, then run:

```sh
./ubuntu_setup_2.sh
./install.sh
```

## macOS Setup

On a fresh Mac, install Homebrew first:

```sh
./mac_setup_1.sh
```

Then run the portable installer:

```sh
./install.sh
```

On macOS, the installer uses Homebrew when it is already installed. It skips
package installation if Homebrew is missing and still links configs.

## Existing Machines

Run the portable installer directly:

```sh
./install.sh
```

The installer backs up existing destination files before creating symlinks.

## What Gets Linked

- `conf/.zshrc` to `~/.zshrc`
- `conf/custom_aliases.zsh` to `$ZSH_CUSTOM/custom_aliases.zsh`
- `conf/.tmux.conf` to `~/.tmux.conf`
- `conf/.ripgreprc` to `~/.ripgreprc`
- `conf/nvim` to `~/.config/nvim`
- `conf/ghdashconfig.yml` to `~/ghdashconfig.yml`
- sanitized agent configs under `~/.codex`, `~/.claude`, and `~/.config/ccstatusline`

Existing files are moved aside with a timestamped `.bak.*` suffix before
symlinks are created.
