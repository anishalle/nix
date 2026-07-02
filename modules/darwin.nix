{ config, pkgs, lib, ... }:

# macOS-only configuration. GUI apps, mac-specific paths, and anything that
# links against the Homebrew toolchain stays out of nix (see README/brew):
# llvm, openblas, libomp, libxml2, jansson, raylib, pinentry-mac, casks.
{
  home.homeDirectory = "/Users/ani";

  # Workstation-only tools the devbox doesn't need.
  home.packages = with pkgs; [
    ### java / android RE (pairs with IDA)
    maven
    jadx
    ### cloud / infra driven from the workstation
    cloudflared
  ];

  programs.zsh.initContent = lib.mkBefore ''
    export PATH="/Applications/IDA Professional 9.3.app/Contents/MacOS:$PATH"
  '';
}
