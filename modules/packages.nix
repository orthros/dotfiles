{ config, lib, pkgs, ... }:

{
  options.dotfiles.jujutsu.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to install the nixpkgs jujutsu package (disable on machines that provide an external/internal jj binary).";
  };

  config = {
    # Packages to install in the user profile via Home Manager.
    # Add or uncomment CLI tools, development dependencies, and applications here.
    home.packages = (with pkgs; [
      # Basic CLI utilities & modern replacements
      btop # Resource monitor (replaces htop)
      difftastic # Structural AST diff tool
      direnv # Per-directory environment loader
      duf # Modern df replacement
      dust # Modern du replacement
      fastfetch # System information fetcher
      fd # Modern find replacement
      fzf # Command-line fuzzy finder (replaces peco)
      glow # Terminal markdown renderer
      jq # Command-line JSON processor
      mergiraf # Structural AST merge tool
      mise # Polyglot tool version & environment manager
      nh # Nix CLI helper
      nix-melt # Ranger-like viewer for flake.lock
      ripgrep # Modern grep replacement
      tio # Serial device I/O tool
      tmux # Terminal multiplexer
      viddy # Modern watch command
      yazi # Terminal file explorer
    ]) ++ lib.optionals config.dotfiles.jujutsu.enable [
      pkgs.jujutsu # Git-compatible VCS
    ];
  };
}
