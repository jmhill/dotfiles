# Git Tools

Command-line tools for Git workflow management.

## Contents

### git-worktree-runner (gtr)

A CLI tool for managing git worktrees with ease. Simplifies creating worktrees, opening them in editors, and starting AI coding tools.

**Version:** 2.0.0
**Source:** https://github.com/coderabbitai/git-worktree-runner

## Installation

### With Stow (Recommended)

From your dotfiles directory:

```bash
stow git-tools
```

This creates `~/.local/bin/git-gtr` which makes the tool available as `git gtr` or `git-gtr`.

### On New Systems

When setting up dotfiles on a new machine:

```bash
cd ~/dotfiles
git submodule update --init --recursive  # Initialize submodules
stow git-tools                           # Install the tool
```

## Updating

The tool is installed as a git submodule. To update to the latest version:

```bash
cd ~/dotfiles
git submodule update --remote .git-worktree-runner
git add .git-worktree-runner
git commit -m "update git-worktree-runner"
```

## Quick Start

### Initial Setup (Per Repository)

```bash
cd ~/your-git-repo
git gtr config set gtr.editor.default cursor   # or vscode, zed, nvim, etc.
git gtr config set gtr.ai.default claude       # for Claude Code CLI
```

### Daily Workflow

```bash
# Create a new worktree
git gtr new feature/new-feature

# Open in your editor
git gtr editor feature/new-feature

# Start AI tool (e.g., Claude Code)
git gtr ai feature/new-feature

# Navigate to worktree (nushell)
cd (git gtr go feature/new-feature)

# Run commands in worktree
git gtr run feature/new-feature npm test

# Remove when done
git gtr rm feature/new-feature --delete-branch
```

### Useful Commands

```bash
# List all worktrees
git gtr list

# Health check
git gtr doctor

# See available editors and AI tools
git gtr adapter

# Create variant worktrees for parallel work
git checkout feature/user-auth
git gtr new variant-1 --from-current
git gtr new variant-2 --from-current

# Access main repo using '1' as branch ID
git gtr editor 1        # Open main repo in editor
git gtr go 1            # Get path to main repo
git gtr run 1 npm build # Run command in main repo
```

## Configuration Options

All configuration is per-repository and stored in `.git/config`.

```bash
# Worktree location
git gtr config set gtr.worktrees.dir ../worktrees

# Default editor
git gtr config set gtr.editor.default cursor
# Options: cursor, vscode, zed, idea, pycharm, webstorm, vim, nvim, emacs, etc.

# Default AI tool
git gtr config set gtr.ai.default claude
# Options: aider, claude, codex, continue, cursor, gemini, opencode

# Copy specific files to worktrees (multi-valued)
git gtr config add gtr.copy.include ".env.local"
git gtr config add gtr.copy.include ".vscode/settings.json"

# Exclude patterns
git gtr config add gtr.copy.exclude "**/*.log"

# Post-create hooks (run after worktree creation)
git gtr config add gtr.hook.postCreate "npm install"
git gtr config add gtr.hook.postCreate "echo 'Worktree ready!'"

# Post-remove hooks (run after worktree removal)
git gtr config add gtr.hook.postRemove "echo 'Worktree removed'"
```

## Integration with Nushell

Add this to your `~/.config/nushell/config.nu` for easier navigation:

```nushell
# Navigate to git worktree
def "gtr-cd" [branch: string] {
  cd (git gtr go $branch)
}

# Create worktree and open in editor
def "gtr-start" [branch: string] {
  git gtr new $branch
  git gtr editor $branch
}
```

## Integration with Zellij

Create worktrees in new Zellij panes/tabs:

```bash
# In Zellij, create a new tab and run
git gtr new my-feature && cd (git gtr go my-feature) && git gtr ai my-feature
```

## Philosophy

git-worktree-runner follows a "configuration over flags" approach:
- Set your preferences once per repository
- Use simple commands daily
- Override with flags when needed

## Troubleshooting

```bash
# Check if everything is configured correctly
git gtr doctor

# See all available adapters
git gtr adapter

# Remove stale worktrees
git gtr clean
```

## Documentation

Full documentation: https://github.com/coderabbitai/git-worktree-runner
