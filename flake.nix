{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-config = {
      url = "github:orthros/.vim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      vim-config,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHome =
        {
          username,
          homeDirectory ? "/home/${username}",
          stateVersion ? "24.05",
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            vim-config.homeManagerModules.default
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
        default =
          { ... }:
          {
            imports = [
              ./home.nix
              vim-config.homeManagerModules.default
            ];
          };
      };

      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        default = self.homeConfigurations.default.activationPackage;
        lint =
          pkgs.runCommand "dotfiles-lint"
            {
              nativeBuildInputs = with pkgs; [
                deadnix
                nixfmt
                python3
                ruff
                shellcheck
                statix
                zsh
              ];
            }
            ''
              cd ${self}
              nixfmt --check flake.nix home.nix modules/*.nix modules/theme/*.nix
              statix check .
              deadnix --fail flake.nix home.nix modules/*.nix modules/theme/*.nix
              shellcheck -s bash \
                config/motd/99-custom \
                config/zsh/aliases \
                config/zsh/functions \
                config/zsh/git-utils.sh \
                config/zsh/path
              shellcheck -s sh -e SC2034 config/vlock/vlockrc
              zsh -n \
                .zshenv \
                config/zsh/.zshrc \
                config/zsh/aliases \
                config/zsh/completions \
                config/zsh/functions \
                config/zsh/git-utils.sh \
                config/zsh/path \
                config/zsh/prompt \
                config/zsh/zprofile \
                config/zsh/zshenv
              RUFF_CACHE_DIR="$TMPDIR/ruff-cache" ruff check config/waybar/mediaplayer.py
              RUFF_CACHE_DIR="$TMPDIR/ruff-cache" ruff format --check config/waybar/mediaplayer.py
              python3 - <<'PY'
              import json, re, tomllib
              toml_files = [
                  "config/alacritty/alacritty.toml",
                  "config/alacritty/fonts.toml",
                  "config/herdr/config.toml",
                  "config/jj/config.toml",
                  "config/mise/config.toml",
              ]
              for path in toml_files:
                  with open(path, "rb") as fh:
                      tomllib.load(fh)
              raw = open("config/waybar/config.jsonc", encoding="utf-8").read()
              no_comments = re.sub(r"(?m)^\s*//.*$|(?<=\s)//.*$", "", raw)
              no_trailing = re.sub(r",(\s*[}\]])", r"\1", no_comments)
              json.loads(no_trailing)
              PY
              touch "$out"
            '';
      };
    };
}
