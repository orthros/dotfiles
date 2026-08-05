{ config, pkgs, ... }:

{
  # Packages to install in the user profile via Home Manager.
  # Add or uncomment CLI tools, development dependencies, and applications here.
  home.packages = with pkgs; [
    # Basic CLI utilities
    ripgrep
    fd
    jq
    fastfetch
  ];
}
