# dotfiles
The settings for the things I like.

## Managing with Home Manager (Flakes)

This repository includes a [Home Manager](https://github.com/nix-community/home-manager) flake configuration that declaratively manages dotfiles and XDG configuration directories.

### Usage

To apply the configuration using an existing `home-manager` installation:

```bash
home-manager switch --flake .
```

You can also install or apply it directly using `nix run`:

```bash
nix run github:nix-community/home-manager -- switch --flake .
```

To validate the flake configuration:

```bash
nix flake check
```

### Structure

- `flake.nix`: Defines inputs (`nixpkgs`, `home-manager`, and `vim-config`) and exposes a generic `default` `homeConfiguration` and `homeManagerModules.default`.
- `home.nix`: Main Home Manager module entry point.
- `modules/dotfiles.nix`: Handles symlinking root dotfiles (e.g., `.zshenv`, `.tmux.conf`) and `~/.config` directories (e.g., `alacritty`, `i3`, `jj`, `mise`, `tio`, `zsh`). Also maps GnuPG files from `config/gnupg` to `~/.gnupg` and fonts from `config/fonts` to `~/.fonts`.
- `modules/packages.nix`: Declarative user packages (`btop`, `difftastic`, `direnv`, `duf`, `dust`, `fastfetch`, `fd`, `fzf`, `glow`, `jq`, `jujutsu`, `mergiraf`, `mise`, `nh`, `nix-melt`, `ripgrep`, `tio`, `tmux`, `viddy`, `yazi`).

### Using `nh`

Once the initial setup is complete, `nh` is installed and can be used instead of `home-manager` for nicer build progress (via `nix-output-monitor`) and package version diffs (via `nvd`).

Apply configuration changes:

```bash
nh home switch .
```

Update flake inputs before switching:

```bash
nh home switch . --update
```

Clean up old Home Manager generations and unused Nix store paths:

```bash
# Clean user profile generations and store paths, keeping the last 5 generations
nh clean user --keep 5
```

Search nixpkgs for packages from the terminal:

```bash
nh search <package-name>
```

### Disk Usage (`dust` and `duf`)

- **`dust`** (modern `du` replacement): View a visual breakdown of directory sizes in the current directory or a specific path.
  ```bash
  dust
  dust /path/to/dir
  # Limit tree depth (e.g. 2 levels)
  dust -d 2
  ```
- **`duf`** (modern `df` replacement): View free/used space across mounted filesystems.
  ```bash
  duf
  # Show only local filesystems
  duf --only local
  ```

## What the heck is `.darwin`?

I found when using OSX and [Homebrew](https://brew.sh), I was installing brew to a non standard directory (`$HOME/.homebrew`). 
This meant my shell would not pick up the executeables I had installed via `brew install` (which are numerous).

Rather than try to continue to hack it, I added a `.darwin` file to be sourced first (and therefore fix the path).

The `.darwin` file is in [orthros/brewfiles](https://github.com/orthros/brewfiles)
