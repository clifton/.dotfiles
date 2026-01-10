# Security Considerations

This document describes security-related decisions and patterns used in this dotfiles repository.

## Eval Usage

Shell configuration files use `eval` in several places for legitimate tool initialization. All eval calls execute locally installed binaries, not network-fetched or user-constructed content.

### Homebrew (`.shellenv`)

```sh
eval "$($DOTFILES_HOMEBREW_PREFIX/bin/brew shellenv)"
```

**Justification:** Required by Homebrew to set `PATH`, `HOMEBREW_PREFIX`, and other environment variables. This is the official Homebrew initialization pattern.

### fzf (`.zshrc`, `.bashrc`)

```sh
eval "$(fzf --zsh)"
eval "$(fzf --bash)"
```

**Justification:** Standard fzf shell integration. Sets up keybindings (`Ctrl+R`, `Ctrl+T`) and completion functions.

### zoxide (`.zshrc`, `.bashrc`)

```sh
eval "$(zoxide init zsh)"
eval "$(zoxide init bash)"
```

**Justification:** Required for zoxide's `z` command and shell integration. Adds the `z` function and completion.

### keychain (`.aliases`)

```sh
alias keys='eval `keychain --eval --agents ssh id_rsa`'
```

**Justification:** keychain requires eval to set `SSH_AUTH_SOCK` and `SSH_AGENT_PID` in the current shell environment.

### Security Mitigations

- All eval'd commands come from locally installed binaries in trusted locations (`/opt/homebrew`, `/usr/local`, etc.)
- No network-fetched content is directly eval'd
- Commands are not constructed from user input
- File existence is verified before sourcing where applicable

## SSH Configuration

### What's Tracked

- `.ssh/config` - SSH client configuration with host aliases and settings
- `.ssh/authorized_keys` - Public keys for incoming SSH authentication

### What's NOT Tracked (via `.gitignore`)

- `.ssh/id_*` - Private keys
- `.ssh/known_hosts*` - Host fingerprints (machine-specific)

### Rationale

The `.ssh/config` file contains no secrets - only host aliases, preferred authentication methods, and connection settings. Tracking it enables consistent SSH configuration across machines.

The `authorized_keys` file contains only public keys. While these aren't secrets, be aware that:
- Key comments may reveal email addresses or machine names
- If this repository is public, this provides reconnaissance information about which keys have access

### Recommendations

1. Consider stripping identifying information from key comments:
   ```
   # Before: ssh-ed25519 AAAAC3... user@personal-laptop.local
   # After:  ssh-ed25519 AAAAC3... laptop
   ```

2. Use machine-specific `~/.ssh/config.local` for sensitive host configurations that shouldn't be shared.

## Local Configuration

The following files are sourced but not tracked in git:

### `~/.env`

For sensitive environment variables (API keys, tokens, etc.). Create from scratch on each machine.

### `~/.config.local`

For machine-specific configuration (network service names, custom paths, etc.). Copy from `.config.local.example` and customize.

## Git Credential Helper

The `.gitconfig` uses GitHub CLI (`gh`) for credential handling:

```gitconfig
[credential "https://github.com"]
    helper =
    helper = !gh auth git-credential
```

This relies on `gh auth login` having been run previously. Credentials are stored securely by `gh` (using the system keychain on macOS, or encrypted storage on Linux).

## Reporting Security Issues

If you discover a security issue in these dotfiles, please open an issue on GitHub or contact the repository owner directly.
