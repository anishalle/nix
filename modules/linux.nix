{ config, pkgs, lib, ... }:

# Linux-only configuration, aimed at the cloud devbox image.
{
  home.homeDirectory = "/home/ani";

  # Running on non-NixOS Linux (e.g. a Debian/Ubuntu-based image):
  # fixes locale/terminfo/session integration for nix-installed programs.
  targets.genericLinux.enable = true;
}
