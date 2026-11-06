# Workflows for orthros's Home Manager configuration

# List available recipes
default:
    @just --list

# Evaluate and build all Home Manager profile and lint checks
check:
    nix flake check

# Format all Nix files in the repository via nixfmt
fmt:
    nix fmt

# Run Nix (nixfmt, statix, deadnix), shell (shellcheck, zsh -n), Python (ruff), and TOML/JSONC linters
lint:
    nix build ".#checks.x86_64-linux.lint" --no-link

# Build a Home Manager profile without activating (defaults to "default")
build profile="default":
    nix build ".#homeConfigurations.{{profile}}.activationPackage" --no-link

# Build and activate a Home Manager profile via nh
switch profile="default":
    nh home switch . -c "{{profile}}"

# Update the upstream orthros/.vim flake input
update-vim:
    nix flake update vim-config

# Install privileged host-level configs (/etc/update-motd.d and /etc/sysctl.d)
sync-system:
    #!/usr/bin/env bash
    set -euo pipefail
    sudo ln -snf "${XDG_CONFIG_HOME:-$HOME/.config}/motd/99-custom" /etc/update-motd.d/99-custom
    sudo ln -snf "${XDG_CONFIG_HOME:-$HOME/.config}/sysctl/70-inotify-limits.conf" /etc/sysctl.d/70-inotify-limits.conf
    sudo sysctl --system >/dev/null
