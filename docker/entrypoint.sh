#!/bin/sh
set -e

# docker doesn't set these, and home-manager activation checks $USER
export USER=root
export HOME=/root

# Activate the baked-in home-manager config on first start (instant: the
# store paths were built into the image).
if [ ! -e "$HOME/.nix-profile/bin/zsh" ]; then
  "$(nix build --no-link --print-out-paths /root/nix#homeConfigurations.ani-container.activationPackage)/activate"
fi

# `docker run image <cmd>` runs <cmd>; otherwise drop into the usual shell.
if [ "$#" -gt 0 ]; then
  exec "$@"
fi
exec "$HOME/.nix-profile/bin/zsh" -l
