#!/bin/bash
set -e

FONTS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

install_nerd_font() {
  local font_name="$1"
  local target_dir="$FONTS_DIR/${font_name}Nerd"

  if [ -d "$target_dir" ] && ls "$target_dir"/*.ttf >/dev/null 2>&1; then
    return 0
  fi

  echo "Installing ${font_name} Nerd Font..."
  mkdir -p "$target_dir"

  local tmp_dir
  tmp_dir=$(mktemp -d)

  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz" -o "$tmp_dir/${font_name}.tar.xz"
  tar -xf "$tmp_dir/${font_name}.tar.xz" -C "$target_dir"
  rm -rf "$tmp_dir"
  echo "${font_name} Nerd Font installed."
}

# Install font families
install_nerd_font "JetBrainsMono"

# Refresh font cache
if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$FONTS_DIR"
fi
