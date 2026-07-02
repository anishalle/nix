{ config, pkgs, lib, ... }:

# macOS-only configuration. GUI apps, mac-specific paths, and anything that
# links against the Homebrew toolchain stays out of nix (see README/brew):
# llvm, openblas, libomp, libxml2, jansson, raylib, pinentry-mac, casks.
{
  home.homeDirectory = "/Users/ani";

  programs.zsh.initContent = lib.mkBefore ''
    export PATH="/Applications/IDA Professional 9.3.app/Contents/MacOS:$PATH"
  '';
}
