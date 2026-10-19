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
- `modules/dotfiles.nix`: Handles symlinking root dotfiles (e.g., `.zshenv`, `.tmux.conf`), `~/.config` directories (e.g., `alacritty`, `herdr`, `i3`, `jj`, `mise`, `tio`, `zsh`), and global AI agent instructions (`config/agents/AGENTS.md`). Also maps GnuPG files from `config/gnupg` to `~/.gnupg` and fonts from `config/fonts` to `~/.fonts`.
- `modules/packages.nix`: Declarative user packages (`bandwhich`, `btop`, `cyme`, `difftastic`, `direnv`, `duf`, `dust`, `fastfetch`, `fd`, `fzf`, `glow`, `jq`, `jujutsu`, `just`, `mergiraf`, `mise`, `nh`, `nix-melt`, `procs`, `ripgrep`, `tio`, `tmux`, `trippy`, `viddy`, `yazi`).

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

### Systems, USB & Network Diagnostics (`cyme`, `bandwhich`, `trippy`, and `procs`)

- **`cyme`** (modern Rust `lsusb` replacement): Lists and visualizes USB buses, hubs, port topologies, negotiated speeds, and device descriptors.
  ```bash
  # Display USB buses, hubs, and attached devices as a tree
  cyme --tree

  # Emit structured JSON for scripting or port inspection
  cyme --tree --json
  ```
- **`bandwhich`** (Rust per-process network utilization TUI): Sniffs a network interface and attributes live bandwidth consumption to specific processes, PIDs, and remote socket addresses.
  ```bash
  # Monitor live per-process and per-connection network bandwidth (requires root/CAP_NET_RAW)
  sudo bandwhich
  ```
- **`trippy`** (`trip` — Rust `mtr` / `traceroute` + `ping` TUI): Interactive network path diagnostic tool combining hop-by-hop traceroute discovery with continuous latency, jitter, and packet-loss telemetry.
  ```bash
  # Trace and monitor hop-by-hop latency to a target host
  trip <host-or-ip>
  ```
- **`procs`** (modern Rust `ps` replacement): Displays running processes with colorized, human-readable columns, full process-tree hierarchy, TCP/UDP port and socket ownership, and container/cgroup metadata.
  ```bash
  # Search for processes matching a keyword or binary name
  procs <pattern>

  # Display the full process hierarchy tree
  procs --tree
  ```

## What the heck is `.darwin`?

I found when using OSX and [Homebrew](https://brew.sh), I was installing brew to a non standard directory (`$HOME/.homebrew`). 
This meant my shell would not pick up the executeables I had installed via `brew install` (which are numerous).

Rather than try to continue to hack it, I added a `.darwin` file to be sourced first (and therefore fix the path).

The `.darwin` file is in [orthros/brewfiles](https://github.com/orthros/brewfiles)
