{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.theme;
  presets = import ./presets.nix;
  activePreset = presets.${cfg.preset};

  stripHash = c: lib.removePrefix "#" c;

  hexCharToInt = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7;
    "8" = 8; "9" = 9; "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
    "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
  };
  hexByteToInt = s:
    (hexCharToInt.${builtins.substring 0 1 s}) * 16
    + (hexCharToInt.${builtins.substring 1 1 s});
  hexToAnsiRgb = hex:
    let
      h = stripHash hex;
      r = toString (hexByteToInt (builtins.substring 0 2 h));
      g = toString (hexByteToInt (builtins.substring 2 2 h));
      b = toString (hexByteToInt (builtins.substring 4 2 h));
    in
    "38;2;${r};${g};${b}";

  nvimStyle =
    if cfg.preset == "storm" || cfg.preset == "storm-neon" then
      "storm"
    else if cfg.preset == "moon" then
      "moon"
    else
      "night";

  replacements = {
    "@preset@" = cfg.preset;
    "@fontFamily@" = cfg.fontFamily;
    "@lockImage@" = cfg.lockImage;
    "@configHome@" = config.xdg.configHome;
    "@nvimStyle@" = nvimStyle;

    # Hex colors (with leading '#')
    "@bg@" = cfg.bg;
    "@surface@" = cfg.surface;
    "@surfaceAlt@" = cfg.surfaceAlt;
    "@surfaceHover@" = cfg.surfaceHover;
    "@fg@" = cfg.fg;
    "@fgMuted@" = cfg.fgMuted;
    "@slate@" = cfg.slate;
    "@accent@" = cfg.accent;
    "@teal@" = cfg.teal;
    "@cyan@" = cfg.cyan;
    "@lavender@" = cfg.lavender;
    "@purple@" = cfg.purple;
    "@green@" = cfg.green;
    "@aqua@" = cfg.aqua;
    "@amber@" = cfg.amber;
    "@orange@" = cfg.orange;
    "@urgent@" = cfg.urgent;
    "@error@" = cfg.error;

    # Bare 6-digit hex colors (without '#', for swaylock)
    "@bgHex@" = stripHash cfg.bg;
    "@surfaceHex@" = stripHash cfg.surface;
    "@slateHex@" = stripHash cfg.slate;
    "@amberHex@" = stripHash cfg.amber;
    "@orangeHex@" = stripHash cfg.orange;
    "@tealHex@" = stripHash cfg.teal;
    "@urgentHex@" = stripHash cfg.urgent;
    "@accentHex@" = stripHash cfg.accent;
    "@fgHex@" = stripHash cfg.fg;

    # ANSI 24-bit RGB escape sequences ("38;2;R;G;B", for fastfetch)
    "@accentAnsi@" = hexToAnsiRgb cfg.accent;
    "@tealAnsi@" = hexToAnsiRgb cfg.teal;
    "@lavenderAnsi@" = hexToAnsiRgb cfg.lavender;
    "@cyanAnsi@" = hexToAnsiRgb cfg.cyan;
    "@fgAnsi@" = hexToAnsiRgb cfg.fg;
    "@slateAnsi@" = hexToAnsiRgb cfg.slate;
  };

  tokenNames = builtins.attrNames replacements;
  tokenValues = builtins.attrValues replacements;

  renderTemplate = path:
    builtins.replaceStrings tokenNames tokenValues (builtins.readFile path);

  gtkCss = renderTemplate ../../config/gtk/gtk.css;
  gtkSettingsIni = renderTemplate ../../config/gtk/settings.ini;

  themeScss = pkgs.writeTextDir "_theme.scss" (renderTemplate ../../config/waybar/_theme.scss);

  mkColorOption = name: desc: lib.mkOption {
    type = lib.types.str;
    default = activePreset.${name};
    description = desc;
  };
in
{
  options.dotfiles.theme = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the unified dotfiles theme module across desktop and CLI tools.";
    };

    preset = lib.mkOption {
      type = lib.types.enum (builtins.attrNames presets);
      default = "cherry-blossom";
      description = "Active theme palette preset (cherry-blossom or Tokyo Night variants).";
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "BlexMono Nerd Font Mono";
      description = "Primary Nerd Font family used across Waybar, Mako, Rofi, and Sway.";
    };

    lockImage = lib.mkOption {
      type = lib.types.str;
      default = "~/.config/wallpapers/cherry_blossoms.jpg";
      description = "Background image path used by swaylock.";
    };

    bg = mkColorOption "bg" "Deep terminal/window background color.";
    surface = mkColorOption "surface" "Primary surface color for bars, notifications, and dialogs.";
    surfaceAlt = mkColorOption "surfaceAlt" "Secondary surface color (e.g. system tray, inactive tab).";
    surfaceHover = mkColorOption "surfaceHover" "Highlight/hover surface color.";
    fg = mkColorOption "fg" "Primary foreground text color.";
    fgMuted = mkColorOption "fgMuted" "Subdued foreground text color.";
    slate = mkColorOption "slate" "Muted comment/border slate color.";
    accent = mkColorOption "accent" "Primary accent color (focused borders, active workspace, prompts).";
    teal = mkColorOption "teal" "Secondary teal accent (split direction indicator, borders).";
    cyan = mkColorOption "cyan" "Bright cyan accent.";
    lavender = mkColorOption "lavender" "Lavender accent.";
    purple = mkColorOption "purple" "Purple accent.";
    green = mkColorOption "green" "Green accent.";
    aqua = mkColorOption "aqua" "Aqua/mint status OK color.";
    amber = mkColorOption "amber" "Amber warning color.";
    orange = mkColorOption "orange" "Warm orange accent.";
    urgent = mkColorOption "urgent" "Urgent/critical highlight color.";
    error = mkColorOption "error" "Error crimson color.";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      # Swaylock configuration rendered from config/swaylock/config
      ".config/swaylock/config".text = renderTemplate ../../config/swaylock/config;

      # Tmux base configuration (.tmux.conf) layered with config/tmux/theme.conf
      ".tmux.conf".text =
        builtins.readFile ../../.tmux.conf
        + "\n"
        + renderTemplate ../../config/tmux/theme.conf;

      # X11 / Xwayland Xresources 16-color palette + base .Xresources settings
      ".Xresources".text =
        renderTemplate ../../config/xresources/theme.Xresources
        + "\n"
        + builtins.readFile ../../.Xresources;
    };

    xdg.configFile = {
      # 1. Sway border & titlebar color fragment (included by config/sway/config)
      "sway/theme.conf".text = renderTemplate ../../config/sway/theme.conf;

      # 2. Waybar stylesheet compiled with injected _theme.scss variables
      "waybar/style.css".source =
        pkgs.runCommand "waybar-style.css" { nativeBuildInputs = [ pkgs.dart-sass ]; } ''
          sass --no-source-map --load-path=${themeScss} ${../../config/waybar/style.scss} $out
        '';

      # 3. Mako notification daemon base config layered with theme rules
      "mako/config" = {
        text =
          builtins.readFile ../../config/mako/config
          + "\n"
          + renderTemplate ../../config/mako/theme;
        onChange = "/usr/bin/makoctl reload >/dev/null 2>&1 || true";
      };

      # 4. Rofi launcher palette (~/.config/rofi/theme.rasi, imported by oneorthros.rasi)
      "rofi/theme.rasi".text = renderTemplate ../../config/rofi/theme.rasi;

      # 5. Alacritty 16-color + primary terminal palette (~/.config/alacritty/colors.toml)
      "alacritty/colors.toml".text = renderTemplate ../../config/alacritty/colors.toml;

      # 6. Atuin TUI custom theme (~/.config/atuin/themes/dotfiles-theme.toml)
      "atuin/themes/dotfiles-theme.toml".text =
        renderTemplate ../../config/atuin/themes/dotfiles-theme.toml;

      # 7. Zellij base configuration layered with unified theme block
      "zellij/config.kdl".text =
        builtins.readFile ../../config/zellij/config.kdl
        + "\n"
        + renderTemplate ../../config/zellij/theme.kdl;

      # 8. Shared theme exports for Zsh/fzf (~/.config/theme/colors.sh) and scripts (~/.config/theme/colors.json)
      "theme/colors.sh".text = renderTemplate ../../config/theme/colors.sh;

      "theme/colors.json".text = builtins.toJSON {
        inherit (cfg)
          preset bg surface surfaceAlt surfaceHover fg fgMuted slate
          accent teal cyan lavender purple green aqua amber orange urgent error;
      };

      # 9. btop resource monitor custom theme (~/.config/btop/themes/dotfiles-theme.theme)
      "btop/themes/dotfiles-theme.theme".text =
        renderTemplate ../../config/btop/themes/dotfiles-theme.theme;

      # 10. Yazi terminal file manager theme (~/.config/yazi/theme.toml)
      "yazi/theme.toml".text = renderTemplate ../../config/yazi/theme.toml;

      # 11. Jujutsu (jj) truecolor theme drop-in (~/.config/jj/conf.d/theme.toml)
      "jj/conf.d/theme.toml".text = renderTemplate ../../config/jj/conf.d/theme.toml;

      # 12. Glow markdown renderer config & Glamour JSON stylesheet (~/.config/glow/{glow.yml,theme.json})
      "glow/glow.yml".text = renderTemplate ../../config/glow/glow.yml;
      "glow/theme.json".text = renderTemplate ../../config/glow/theme.json;

      # 13. Viddy modern watch TUI configuration (~/.config/viddy.toml)
      "viddy.toml".text = renderTemplate ../../config/viddy/viddy.toml;

      # 14. Fastfetch system info configuration (~/.config/fastfetch/config.jsonc)
      "fastfetch/config.jsonc".text = renderTemplate ../../config/fastfetch/config.jsonc;

      # 15. Zathura PDF viewer base configuration layered with theme colors
      "zathura/zathurarc".text =
        builtins.readFile ../../config/zathura/zathurarc
        + "\n"
        + renderTemplate ../../config/zathura/theme;

      # 16. Neovim tokyonight.nvim + lualine theme synchronization (~/.config/nvim/after/plugin/dotfiles_theme.lua)
      "nvim/after/plugin/dotfiles_theme.lua".text =
        renderTemplate ../../config/nvim/after/plugin/dotfiles_theme.lua;

      # 17. GTK 3 & GTK 4 stylesheet and dark-mode settings (~/.config/gtk-{3,4}.0/{gtk.css,settings.ini})
      "gtk-3.0/gtk.css".text = gtkCss;
      "gtk-4.0/gtk.css".text = gtkCss;
      "gtk-3.0/settings.ini".text = gtkSettingsIni;
      "gtk-4.0/settings.ini".text = gtkSettingsIni;

      # Live-reload Herdr's running server whenever ~/.config/herdr/config.toml changes
      "herdr/config.toml".onChange =
        lib.mkIf (config.programs.herdr.enable && config.programs.herdr.package != null)
          "${lib.getExe config.programs.herdr.package} server reload-config >/dev/null 2>&1 || true";
    };

    # 18. Herdr terminal multiplexer custom theme (~/.config/herdr/config.toml [theme.custom])
    programs.herdr.settings.theme.custom = {
      accent = cfg.accent;
      panel_bg = cfg.bg;
      sidebar_bg = cfg.surface;
      active_row_bg = cfg.surfaceHover;
      selection_bg = cfg.surfaceHover;
      surface0 = cfg.surface;
      surface1 = cfg.surfaceAlt;
      surface_dim = cfg.bg;
      overlay0 = cfg.slate;
      overlay1 = cfg.fgMuted;
      text = cfg.fg;
      subtext0 = cfg.fgMuted;
      mauve = cfg.lavender;
      green = cfg.green;
      yellow = cfg.amber;
      red = cfg.urgent;
      blue = cfg.accent;
      teal = cfg.teal;
      peach = cfg.orange;
    };

    # Ensure ~/.config/btop/btop.conf selects "dotfiles-theme" while remaining
    # writable so btop can persist runtime UI toggles on exit, and synchronize
    # the persisted Zsh prompt_theme state file on Home Manager activation.
    home.activation.btopTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      BTOP_CONF="${config.xdg.configHome}/btop/btop.conf"
      mkdir -p "${config.xdg.configHome}/btop"
      if [ -f "$BTOP_CONF" ] && [ ! -L "$BTOP_CONF" ]; then
        if grep -q '^color_theme =' "$BTOP_CONF"; then
          sed -i 's|^color_theme =.*|color_theme = "dotfiles-theme"|' "$BTOP_CONF"
        else
          printf '\ncolor_theme = "dotfiles-theme"\n' >> "$BTOP_CONF"
        fi
      else
        rm -f "$BTOP_CONF"
        printf 'color_theme = "dotfiles-theme"\ntheme_background = false\ntruecolor = true\n' > "$BTOP_CONF"
      fi

      ZSH_STATE_DIR="${config.home.homeDirectory}/.local/state/zsh"
      mkdir -p "$ZSH_STATE_DIR"
      printf '%s\n' "${cfg.preset}" > "$ZSH_STATE_DIR/prompt_theme"
    '';
  };
}
