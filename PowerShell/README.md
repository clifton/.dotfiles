# PowerShell Configuration

This directory contains files for setting up a PowerShell environment similar to the ZSH configuration.

## Files

- `Microsoft.PowerShell_profile.ps1`: PowerShell profile (equivalent to `.zshrc`)
- `aliases.ps1`: PowerShell aliases (equivalent to `.aliases`)
- `install.sh`: Bash script for installation from WSL to Windows

## Installation

### From WSL

```bash
cd ~/.dotfiles/PowerShell && ./install.sh
```

This single command copies all files and creates a batch file that you can run to complete the installation.

The installer will:
- Copy PowerShell profile files to Windows
- Copy your `.gitconfig` and `.gitignore` files from WSL to Windows
- Copy your Neovim configuration from `~/.config/nvim` to Windows
- Install Git, Neovim, and other tools in Windows

## Features

- Oh My Posh with Tokyo Night Storm theme
- Command history and search
- Directory jumping with 'z' (similar to zoxide)
- Fuzzy finding with PSFzf
- Git aliases
- Git-delta for improved diffs
- Terminal icons for better directory listings
- Environment variable management
- Automatic dependency handling for fzf
- Shared Git configuration between WSL and Windows
- Shared Neovim configuration between WSL and Windows
- Automatic installation of Git and Neovim

## Manual Installation (Alternative)

If you prefer to install manually:

1. Copy the PowerShell files to your profile locations:
   ```powershell
   copy Microsoft.PowerShell_profile.ps1 $PROFILE
   copy aliases.ps1 (Split-Path $PROFILE -Parent)
   ```

2. Copy configuration files (optional):
   ```powershell
   # Git config
   copy ~/.gitconfig C:\Users\YourUsername\
   copy ~/.gitignore C:\Users\YourUsername\

   # Neovim config
   mkdir -p $env:LOCALAPPDATA\nvim
   cp -r ~/.config/nvim/* $env:LOCALAPPDATA\nvim\
   ```

3. Install the required tools in PowerShell:
   ```powershell
   # PowerShell modules
   Install-Module -Name PSReadLine, z, Terminal-Icons, PSFzf -Scope CurrentUser -Force -AllowClobber

   # Applications
   winget install JanDeDobbeleer.OhMyPosh
   winget install dandavison.delta
   winget install Git.Git
   winget install Neovim.Neovim
   ```

4. The profile will automatically handle fzf installation if needed when you start PowerShell.