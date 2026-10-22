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
      bandwhich # Per-process/connection network bandwidth monitor
      btop # Resource monitor (replaces htop)
      cyme # Modern USB bus & topology viewer (replaces lsusb)
      difftastic # Structural AST diff tool
      direnv # Per-directory environment loader
      duf # Modern df replacement
      dust # Modern du replacement
      fastfetch # System information fetcher
      fd # Modern find replacement
      fzf # Command-line fuzzy finder (replaces peco)
      glow # Terminal markdown renderer
      jq # Command-line JSON processor
      just # Command runner for project workflows
      mergiraf # Structural AST merge tool
      mise # Polyglot tool version & environment manager
      nh # Nix CLI helper
      nix-melt # Ranger-like viewer for flake.lock
      procs # Modern process viewer with tree & socket mapping (replaces ps)
      ripgrep # Modern grep replacement
      tio # Serial device I/O tool
      tmux # Terminal multiplexer
      trippy # Network path diagnostic TUI (combines traceroute and ping/mtr)
      viddy # Modern watch command
      yazi # Terminal file explorer
      zellij # Terminal workspace and multiplexer
    ]) ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
      brightnessctl # Backlight brightness control for Sway
      pavucontrol # PulseAudio / PipeWire volume control GUI for Waybar
    ]) ++ lib.optionals config.dotfiles.jujutsu.enable [
      pkgs.jujutsu # Git-compatible VCS
    ];
  };
}
