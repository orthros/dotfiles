{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = { username, homeDirectory, system ? "x86_64-linux", stateVersion ? "24.05" }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            {
              home = {
                inherit username homeDirectory stateVersion;
              };
            }
          ];
        };
    in
    {
      homeConfigurations = {
        default = mkHome {
          username = "orthros";
        };
      };
      homeManagerModules = {
        default = ./home.nix;
      };
    };
}
