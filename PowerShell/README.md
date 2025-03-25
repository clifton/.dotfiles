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

The installer will also copy your `.gitconfig` and `.gitignore` files from WSL to your Windows home directory.

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

## Manual Installation (Alternative)

If you prefer to install manually:

1. Copy the PowerShell files to your profile locations:
   ```
   copy Microsoft.PowerShell_profile.ps1 $PROFILE
   copy aliases.ps1 (Split-Path $PROFILE -Parent)
   ```

2. Copy Git configuration files (optional):
   ```
   copy ~/.gitconfig C:\Users\YourUsername\
   copy ~/.gitignore C:\Users\YourUsername\
   ```

3. Install the required modules and tools in PowerShell:
   ```powershell
   Install-Module -Name PSReadLine, z, Terminal-Icons, PSFzf -Scope CurrentUser -Force -AllowClobber
   winget install JanDeDobbeleer.OhMyPosh
   winget install dandavison.delta
   ```

4. The profile will automatically handle fzf installation if needed when you start PowerShell. 