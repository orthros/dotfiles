{ config, lib, pkgs, ... }:

let
  agentInstructions =
    if config.dotfiles.extraAgentInstructions == "" then
      config.dotfiles.agentInstructionsFile
    else
      pkgs.writeText "AGENTS.md" (
        builtins.readFile config.dotfiles.agentInstructionsFile
        + "\n"
        + config.dotfiles.extraAgentInstructions
      );

  agentSkills = pkgs.symlinkJoin {
    name = "agent-skills";
    paths = config.dotfiles.agentSkills;
  };
in
{
  options.dotfiles = {
    agentInstructionsFile = lib.mkOption {
      type = lib.types.path;
      default = ../config/agents/AGENTS.md;
      description = "Base global AGENTS.md file linked into ~/.agents/AGENTS.md, ~/.gemini/GEMINI.md, and ~/.claude/CLAUDE.md.";
    };

    extraAgentInstructions = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional markdown instructions appended to agentInstructionsFile (for layering machine- or environment-specific rules).";
    };

    agentSkills = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.str lib.types.path);
      default = [ ];
      description = "Skill directories combined into an agent-skills symlinkJoin derivation and mounted at ~/.agents/skills, ~/.gemini/config/skills, and ~/.claude/skills.";
    };
  };

  config = {
    fonts.fontconfig.enable = true;

    dotfiles.agentSkills = lib.mkIf (config.programs.herdr.enable && config.programs.herdr.package != null) [
      "${config.programs.herdr.package}/share/skills/herdr"
    ];

    # Root-level dotfiles linked into $HOME
    home.file = {
      ".Xresources".source = ../.Xresources;
      ".dircolors".source = ../.dircolors;
      ".tmux.conf".source = ../.tmux.conf;
      ".xinitrc".source = ../.xinitrc;
      ".xsessionrc".source = ../.xsessionrc;
      ".zshenv".source = ../.zshenv;

      # Global AI agent instructions
      ".agents/AGENTS.md".source = agentInstructions;
      ".gemini/GEMINI.md".source = agentInstructions;
      ".claude/CLAUDE.md".source = agentInstructions;

      # Global AI agent skills
      ".agents/skills" = lib.mkIf (config.dotfiles.agentSkills != [ ]) {
        source = agentSkills;
        recursive = true;
      };
      ".gemini/config/skills" = lib.mkIf (config.dotfiles.agentSkills != [ ]) {
        source = agentSkills;
        recursive = true;
      };
      ".claude/skills" = lib.mkIf (config.dotfiles.agentSkills != [ ]) {
        source = agentSkills;
        recursive = true;
      };

      # GnuPG configuration (stored in config/gnupg in repo, linked to ~/.gnupg in $HOME)
      ".gnupg/gpg.conf".source = ../config/gnupg/gpg.conf;
      ".gnupg/gpg-agent.conf".source =
        if pkgs.stdenv.hostPlatform.isDarwin then
          ../config/gnupg/gpg-agent-mac.conf
        else
          ../config/gnupg/gpg-agent-unix.conf;
    };

    # XDG configuration files linked explicitly into ~/.config/<path>
    xdg.configFile = {
      # alacritty
      "alacritty/alacritty.toml".source = ../config/alacritty/alacritty.toml;
      "alacritty/colors.toml".source = ../config/alacritty/colors.toml;
      "alacritty/fonts.toml".source = ../config/alacritty/fonts.toml;

      # i3
      "i3/config".source = ../config/i3/config;
      "i3/status.conf".source = ../config/i3/status.conf;

      # jj
      "jj/config.toml".source = ../config/jj/config.toml;

      # mako
      "mako/config".source = ../config/mako/config;

      # mise
      "mise/config.toml".source = ../config/mise/config.toml;

      # picom
      "picom/picom.conf".source = ../config/picom/picom.conf;

      # rofi
      "rofi/oneorthros.rasi".source = ../config/rofi/oneorthros.rasi;

      # sway
      "sway/config".source = ../config/sway/config;

      # tio
      "tio/config".source = ../config/tio/config;

      # wallpapers
      "wallpapers/cherry_blossoms.jpg".source = ../config/wallpapers/cherry_blossoms.jpg;
      "wallpapers/outrun-ocean.jpg".source = ../config/wallpapers/outrun-ocean.jpg;

      # waybar
      "waybar/config".source = ../config/waybar/config;
      "waybar/style.css".source = pkgs.runCommand "waybar-style.css" {
        nativeBuildInputs = [ pkgs.dart-sass ];
      } ''
        sass --no-source-map ${../config/waybar/style.scss} $out
      '';

      # zathura
      "zathura/zathurarc".source = ../config/zathura/zathurarc;

      # zellij
      "zellij/config.kdl".source = ../config/zellij/config.kdl;

      # zsh
      "zsh/.zshrc".source = ../config/zsh/.zshrc;
      "zsh/aliases".source = ../config/zsh/aliases;
      "zsh/completions".source = ../config/zsh/completions;
      "zsh/functions".source = ../config/zsh/functions;
      "zsh/git-utils.sh".source = ../config/zsh/git-utils.sh;
      "zsh/path".source = ../config/zsh/path;
      "zsh/prompt".source = ../config/zsh/prompt;
      "zsh/zprofile".source = ../config/zsh/zprofile;
      "zsh/zshenv".source = ../config/zsh/zshenv;
    };

    # Herdr terminal multiplexer for AI coding agents
    programs.herdr = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../config/herdr/config.toml);
    };
  };
}
