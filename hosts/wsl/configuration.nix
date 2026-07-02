{ config, lib, pkgs, ... }:

# NixOS-WSL system configuration.
# Rebuild with: sudo nixos-rebuild switch --flake ~/nix#wsl
{
  wsl.enable = true;
  wsl.defaultUser = "ani";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.ani = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
  };

  # zsh must be enabled system-wide to be a login shell.
  programs.zsh.enable = true;

  # ani has no password set; allow sudo without one (personal WSL machine).
  security.sudo.wheelNeedsPassword = false;

  # For building/testing the devbox image locally.
  virtualisation.docker.enable = true;

  # Run foreign (FHS-expecting) binaries: pip wheels, npm postinstalls,
  # VSCode remote server, downloaded tarballs, etc.
  programs.nix-ld.enable = true;

  # Home Manager as a NixOS module: home.username / home.homeDirectory
  # are derived from users.users.ani automatically, and
  # `nixos-rebuild switch` updates system + home in one atomic step.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ani = {
      imports = [ ../../modules/common.nix ];
      # On NixOS, "update" means rebuilding the system, not standalone HM.
      programs.zsh.shellAliases.update =
        lib.mkForce "sudo nixos-rebuild switch --flake ~/nix#wsl";
    };
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
