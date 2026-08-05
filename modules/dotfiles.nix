{ config, pkgs, ... }:

{
  # Root-level dotfiles linked into $HOME
  home.file = {
    ".Xresources".source = ../.Xresources;
    ".dircolors".source = ../.dircolors;
    ".fonts".source = ../config/fonts;
    ".tmux.conf".source = ../.tmux.conf;
    ".xinitrc".source = ../.xinitrc;
    ".xsessionrc".source = ../.xsessionrc;
    ".zshenv".source = ../.zshenv;

    # GnuPG configuration (stored in config/gnupg in repo, linked to ~/.gnupg in $HOME)
    ".gnupg/gpg.conf".source = ../config/gnupg/gpg.conf;
    ".gnupg/gpg-agent.conf".source =
      if pkgs.stdenv.isDarwin then
        ../config/gnupg/gpg-agent-mac.conf
      else
        ../config/gnupg/gpg-agent-unix.conf;
  };

  # XDG configuration files linked explicitly into ~/.config/<path>
  xdg.configFile = {
    # alacritty
    "alacritty/alacritty.toml".source = ../config/alacritty/alacritty.toml;
    "alacritty/alacritty.yml".source = ../config/alacritty/alacritty.yml;
    "alacritty/colors.toml".source = ../config/alacritty/colors.toml;
    "alacritty/colors.yml".source = ../config/alacritty/colors.yml;
    "alacritty/fonts.toml".source = ../config/alacritty/fonts.toml;
    "alacritty/fonts.yml".source = ../config/alacritty/fonts.yml;

    # blocklets
    "blocklets/battery".source = ../config/blocklets/battery;
    "blocklets/cpu_usage".source = ../config/blocklets/cpu_usage;
    "blocklets/disk".source = ../config/blocklets/disk;
    "blocklets/docker".source = ../config/blocklets/docker;
    "blocklets/iface".source = ../config/blocklets/iface;
    "blocklets/memory".source = ../config/blocklets/memory;
    "blocklets/volume".source = ../config/blocklets/volume;

    # dunst
    "dunst/dunstrc".source = ../config/dunst/dunstrc;

    # i3
    "i3/config".source = ../config/i3/config;
    "i3/status.conf".source = ../config/i3/status.conf;

    # i3blocks
    "i3blocks/config".source = ../config/i3blocks/config;

    # mako
    "mako/config".source = ../config/mako/config;

    # neofetch
    "neofetch/config.conf".source = ../config/neofetch/config.conf;

    # peco
    "peco/config.json".source = ../config/peco/config.json;

    # picom
    "picom/picom.conf".source = ../config/picom/picom.conf;

    # rofi
    "rofi/oneorthros.rasi".source = ../config/rofi/oneorthros.rasi;

    # sway
    "sway/config".source = ../config/sway/config;

    # wallpapers
    "wallpapers/cherry_blossoms.jpg".source = ../config/wallpapers/cherry_blossoms.jpg;
    "wallpapers/outrun-ocean.jpg".source = ../config/wallpapers/outrun-ocean.jpg;

    # waybar
    "waybar/config".source = ../config/waybar/config;
    "waybar/style.css".source = ../config/waybar/style.css;

    # zathura
    "zathura/zathurarc".source = ../config/zathura/zathurarc;

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
}
