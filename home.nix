{ config, pkgs, ... }:

{
  imports = [
    ./modules/dotfiles.nix
    ./modules/packages.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG base directory support (~/.config, ~/.local/share, etc.)
  xdg.enable = true;
}
