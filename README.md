# Dotfiles

Personal configuration files managed with GNU Stow.

## Installation

1. Clone this repository to your home directory:
```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
git submodule update --init --recursive  # Initialize git submodules
```

2. Install GNU Stow if not already installed:
```bash
# Ubuntu/Debian
sudo apt install stow

# macOS
brew install stow

# Arch
sudo pacman -S stow
```

## Usage

### Installing configurations

To symlink a specific configuration to your home directory:
```bash
stow <package-name>
```

For example:
```bash
stow bash        # Symlinks bash configuration
stow helix       # Symlinks helix editor configuration
stow ghostty     # Symlinks ghostty terminal configuration
```

To install multiple packages at once:
```bash
stow bash helix ghostty
```

### Removing configurations

To remove symlinks for a specific configuration:
```bash
stow -D <package-name>
```

### Restowing (updating symlinks)

To refresh symlinks after making changes:
```bash
stow -R <package-name>
```

## Available Configurations

- `bash` - Bash shell configuration
- `claude` - Claude.ai assistant configuration
- `env_setup_scripts` - Environment setup scripts
- `ghostty` - Ghostty terminal emulator configuration
- `git-tools` - Git workflow tools (git-worktree-runner)
- `helix` - Helix text editor configuration
- `nushell` - Nushell configuration
- `nushell-macos` - macOS-specific Nushell configuration
- `rust` - Rust development configuration
- `starship` - Starship prompt configuration
- `yazi` - Yazi file manager configuration
- `zellij` - Zellij terminal multiplexer configuration
- `zsh` - Zsh shell configuration

## Structure

Each directory in this repository is a "stow package" that mirrors the structure expected in your home directory. For example:
- `bash/.bashrc` will be symlinked to `~/.bashrc`
- `helix/.config/helix/config.toml` will be symlinked to `~/.config/helix/config.toml`

## Notes

- Stow will never overwrite existing files. If conflicts occur, it will report an error.
- Use `stow -n <package>` to simulate what would be symlinked without making changes.
- Use `stow -v <package>` for verbose output to see what's being linked.