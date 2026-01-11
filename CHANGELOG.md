# Changelog

All notable changes to the dotfiles repository will be documented in this file.

## [Unreleased] - 2026-01-10

### Removed
- Deleted duplicate F12 toggle configuration from `.tmux.conf.local` (lines 660-685)
- Removed duplicate `grep` alias from `.bashrc`
- Deleted orphaned Vim swap file `.and.swp`
- Removed all commented yabai configuration from `.skhdrc` (yabai not in use)
- Removed dead code from `.tmux.conf.local` (catppuccin theme config and duplicate sesh binding)
- Deleted `.vscode/` directory (extension recommendations file)

### Fixed
- Fixed hardcoded username in `.zshrc` path: `/Users/clifton/` → `$HOME/`
- Updated sesh config session name from "yabai config" to "skhd config"
- Removed reference to non-existent `.yabairc` file from sesh configuration

### Added
- Added comprehensive documentation header to `.osx` script explaining purpose, usage, and configuration

### Fixed
- Fixed SSH config for `fat` host by removing RemoteCommand (prevents "not a terminal" error)
- Fixed fzf-tab loading in `.zshrc` to only load when TTY is available (prevents "open terminal failed" on remote hosts)

---

## Format

Based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

### Types of changes
- `Added` for new features
- `Changed` for changes in existing functionality
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features
- `Fixed` for any bug fixes
- `Security` in case of vulnerabilities