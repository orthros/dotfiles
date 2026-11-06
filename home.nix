{ config, lib, ... }:

{
  imports = [
    ./modules/dotfiles.nix
    ./modules/packages.nix
    ./modules/theme
  ];

  programs = {
    nh = {
      enable = lib.mkDefault true;
      flake = lib.mkDefault "${config.home.homeDirectory}/.config/home-manager";
      clean = {
        enable = lib.mkDefault true;
        extraArgs = lib.mkDefault "--keep 5 --keep-since 7d";
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # Enable XDG base directory support (~/.config, ~/.local/share, etc.)
  xdg.enable = true;
}
