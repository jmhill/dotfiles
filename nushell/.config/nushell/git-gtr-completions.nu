# Git worktree runner (gtr) completions

# Get list of worktree branches
def "nu-complete gtr worktree-branches" [] {
    git worktree list --porcelain
    | lines
    | where ($it | str starts-with "branch ")
    | parse "branch {branch}"
    | get branch
    | where $it != ""
    | each { |b|
        let short_name = ($b | str replace "refs/heads/" "")
        { value: $short_name, description: $"Branch: ($short_name)" }
    }
    | append { value: "1", description: "Main repository" }
}

# Complete subcommands for git gtr
def "nu-complete gtr subcommands" [] {
    [
        { value: "new", description: "Create a new worktree" },
        { value: "go", description: "Print worktree path for shell navigation" },
        { value: "run", description: "Execute command in worktree directory" },
        { value: "rm", description: "Remove worktree(s)" },
        { value: "ls", description: "List all worktrees" },
        { value: "list", description: "List all worktrees" },
        { value: "clean", description: "Clean up stale worktrees" },
        { value: "editor", description: "Open worktree in configured editor" },
        { value: "ai", description: "Launch AI coding tools" },
        { value: "doctor", description: "Check system configuration" },
        { value: "adapter", description: "Shell adapter information" },
        { value: "config", description: "Manage gtr settings" },
        { value: "help", description: "Show help information" },
        { value: "version", description: "Show version information" },
    ]
}

# Complete AI tools
def "nu-complete gtr ai-tools" [] {
    [
        { value: "aider", description: "Aider AI coding assistant" },
        { value: "claude", description: "Claude AI assistant" },
        { value: "codex", description: "OpenAI Codex" },
        { value: "continue", description: "Continue AI assistant" },
        { value: "cursor", description: "Cursor AI editor" },
        { value: "gemini", description: "Google Gemini" },
        { value: "opencode", description: "OpenCode AI" },
    ]
}

# Complete config operations
def "nu-complete gtr config-ops" [] {
    [
        { value: "get", description: "Get configuration value" },
        { value: "set", description: "Set configuration value" },
        { value: "add", description: "Add to configuration list" },
        { value: "unset", description: "Remove configuration value" },
    ]
}

# Complete config keys
def "nu-complete gtr config-keys" [] {
    [
        { value: "gtr.worktrees.dir", description: "Worktrees directory location" },
        { value: "gtr.worktrees.prefix", description: "Worktree name prefix" },
        { value: "gtr.defaultBranch", description: "Default branch name" },
        { value: "gtr.editor.default", description: "Default editor command" },
        { value: "gtr.ai.default", description: "Default AI tool" },
        { value: "gtr.copy.include", description: "Files to copy (patterns)" },
        { value: "gtr.copy.exclude", description: "Files to exclude (patterns)" },
        { value: "gtr.copy.includeDirs", description: "Directories to copy" },
        { value: "gtr.copy.excludeDirs", description: "Directories to exclude" },
        { value: "gtr.hook.postCreate", description: "Post-create hook command" },
        { value: "gtr.hook.postRemove", description: "Post-remove hook command" },
    ]
}

# Complete track options
def "nu-complete gtr track-options" [] {
    [
        { value: "auto", description: "Automatically determine tracking" },
        { value: "remote", description: "Track remote branch" },
        { value: "local", description: "Track local branch" },
        { value: "none", description: "No tracking" },
    ]
}

# Main git gtr completion
export extern "git gtr" [
    subcommand?: string@"nu-complete gtr subcommands"
]

# git gtr new
export extern "git gtr new" [
    branch?: string                                    # Branch name to create
    --id: string                                       # Custom worktree identifier
    --from: string                                     # Source branch
    --from-current                                     # Use current branch as source
    --track: string@"nu-complete gtr track-options"  # Tracking mode
    --no-copy                                          # Skip copying files
    --no-fetch                                         # Skip git fetch
    --force(-f)                                        # Force creation
    --name: string                                     # Custom worktree name
    --yes(-y)                                          # Skip confirmations
]

# git gtr go
export extern "git gtr go" [
    branch?: string@"nu-complete gtr worktree-branches"  # Branch/worktree to navigate to
]

# git gtr run
export extern "git gtr run" [
    branch?: string@"nu-complete gtr worktree-branches"  # Branch/worktree to run command in
    ...command: string                                    # Command to execute
]

# git gtr rm
export extern "git gtr rm" [
    ...branches: string@"nu-complete gtr worktree-branches"  # Branch(es) to remove
    --delete-branch(-d)                                       # Also delete git branch
    --force(-f)                                               # Force removal
    --yes(-y)                                                 # Skip confirmations
]

# git gtr ls/list
export extern "git gtr ls" [
    --porcelain  # Machine-readable output
]

export extern "git gtr list" [
    --porcelain  # Machine-readable output
]

# git gtr editor
export extern "git gtr editor" [
    branch?: string@"nu-complete gtr worktree-branches"  # Branch/worktree to open
    --editor: string                                      # Override default editor
]

# git gtr ai
export extern "git gtr ai" [
    branch?: string@"nu-complete gtr worktree-branches"  # Branch/worktree to open
    --ai: string@"nu-complete gtr ai-tools"              # AI tool to use
]

# git gtr config
export extern "git gtr config" [
    operation?: string@"nu-complete gtr config-ops"  # Config operation
    key?: string@"nu-complete gtr config-keys"       # Config key
    value?: string                                    # Config value
    --global(-g)                                      # Use global config
]

# git gtr clean
export extern "git gtr clean" [
    --yes(-y)  # Skip confirmations
]

# git gtr doctor
export extern "git gtr doctor" []

# git gtr adapter
export extern "git gtr adapter" []

# git gtr help
export extern "git gtr help" [
    command?: string@"nu-complete gtr subcommands"  # Command to get help for
]

# git gtr version
export extern "git gtr version" []
