{ config, pkgs, lib, ... }:

# Linux-only configuration, aimed at the cloud devbox image.
{
  home.homeDirectory = "/home/ani";

  # Running on non-NixOS Linux (e.g. a Debian/Ubuntu-based image):
  # fixes locale/terminfo/session integration for nix-installed programs.
  targets.genericLinux.enable = true;

  # Box-specific packages: things macOS (or a full distro) provides out of
  # the box but minimal boxes/containers don't.
  home.packages = with pkgs; [
    gcc # cc for nvim-treesitter parser builds, misc compiles
    ncurses # clear, tput, terminfo database
    glibcLocales
  ];

  # Containers/minimal boxes ship no locale: zsh otherwise runs under
  # ANSI_X3.4-1968 (ASCII) and oh-my-zsh breaks (iconv errors).
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };
}
