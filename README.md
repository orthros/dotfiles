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

- `flake.nix`: Defines inputs (`nixpkgs` and `home-manager`) and exposes a generic `default` `homeConfiguration`.
- `home.nix`: Main Home Manager module entry point.
- `modules/dotfiles.nix`: Handles symlinking root dotfiles (e.g., `.zshenv`, `.tmux.conf`) and `~/.config` directories (e.g., `alacritty`, `i3`, `zsh`). Also maps GnuPG files from `config/gnupg` to `~/.gnupg` and fonts from `config/fonts` to `~/.fonts`.
- `modules/packages.nix`: Declarative user packages.

## What the heck is `.darwin`?

I found when using OSX and [Homebrew](https://brew.sh), I was installing brew to a non standard directory (`$HOME/.homebrew`). 
This meant my shell would not pick up the executeables I had installed via `brew install` (which are numerous).

Rather than try to continue to hack it, I added a `.darwin` file to be sourced first (and therefore fix the path).

The `.darwin` file is in [orthros/brewfiles](https://github.com/orthros/brewfiles)
