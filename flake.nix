{
  description = "Home Manager configuration of ani";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit modules;
        };
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
      };
    };
}
