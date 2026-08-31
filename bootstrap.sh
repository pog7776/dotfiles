#!/bin/sh
# Bootstrap script for fresh machines.
# Not managed by chezmoi (see .chezmoiignore) - install curl/git/chezmoi, then hand off.
#
# Usage:
#   sh -c "$(curl -fsLS https://raw.githubusercontent.com/pog7776/dotfiles/main/bootstrap.sh)"
set -e

# Ensure curl and git are available (needed to fetch/install chezmoi and clone dotfiles)
if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y curl git
fi

# Install chezmoi into ~/.local/bin
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$HOME/.local/bin"

# Clone and apply dotfiles (this in turn runs the run_once_/run_onchange_ scripts,
# which install zsh, oh-my-zsh, oh-my-tmux, zsh plugins, and remaining packages)
"$HOME/.local/bin/chezmoi" init --apply pog7776/dotfiles
