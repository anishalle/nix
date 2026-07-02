#!/bin/sh
set -e

# docker doesn't set these, and home-manager activation checks $USER
export USER=root
export HOME=/root

# Fallback only — activation normally happens at image build (Dockerfile).
if [ ! -e "$HOME/.nix-profile/bin/zsh" ]; then
  case "$(uname -m)" in
    aarch64) ARCH=arm64 ;;
    *) ARCH=amd64 ;;
  esac
  "$(nix build --no-link --print-out-paths "/root/nix#homeConfigurations.ani-container-${ARCH}.activationPackage")/activate"
fi

# `docker run image <cmd>` runs <cmd>; otherwise drop into the usual shell.
if [ "$#" -gt 0 ]; then
  exec "$@"
fi
exec "$HOME/.nix-profile/bin/zsh" -l
