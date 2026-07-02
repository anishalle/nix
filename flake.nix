{
  description = "Home Manager configuration of ani";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }:
    let
      mkHome = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit modules;
        };
      # Docker devbox image (see Dockerfile): runs as root in the container.
      mkContainer = system:
        mkHome system [
          ./modules/common.nix
          ./modules/linux.nix
          ({ lib, ... }: {
            home.username = lib.mkForce "root";
            home.homeDirectory = lib.mkForce "/root";
          })
        ];
    in
    {
      homeConfigurations = {
        # macOS (this machine): `home-manager switch`
        "ani" = mkHome "aarch64-darwin" [
          ./modules/common.nix
          ./modules/darwin.nix
        ];

        # Cloud devbox: `home-manager switch --flake .#ani-linux-x86` (or -arm)
        "ani-linux-x86" = mkHome "x86_64-linux" [
          ./modules/common.nix
          ./modules/linux.nix
        ];
        "ani-linux-arm" = mkHome "aarch64-linux" [
          ./modules/common.nix
          ./modules/linux.nix
        ];

        # Devbox image variants, named to match docker's TARGETARCH values.
        "ani-container-amd64" = mkContainer "x86_64-linux";
        "ani-container-arm64" = mkContainer "aarch64-linux";
      };

      # WSL NixOS: `sudo nixos-rebuild switch --flake .#wsl`
      # Home Manager runs as a NixOS module here (see hosts/wsl),
      # so system + home update together atomically.
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/wsl/configuration.nix
        ];
      };
    };
}
