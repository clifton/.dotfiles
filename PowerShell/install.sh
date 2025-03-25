#!/bin/bash

# Exit on any error
set -e

# PowerShell profile installer for WSL - One-liner version
# This script automatically sets up PowerShell without manual intervention

# Determine Windows username using multiple methods
echo "Detecting Windows username..."

# Add Windows explorer.exe to PATH in WSL environment
if [ -f /proc/version ] && grep -q "microsoft" /proc/version; then
  # Get Windows system32 path and convert it to WSL path format
  WINDOWS_DIR=$(wslpath -u "$(wslvar SYSTEMROOT)")
  # Add only explorer.exe by using a function instead of PATH modification
  function explorer() {
    "${WINDOWS_DIR}/explorer.exe" "$@"
  }

  function cmd() {
    "${WINDOWS_DIR}/system32/cmd.exe" "$@"
  }
fi


# Method 1: cmd.exe method (most common)
WIN_USERNAME=$(cmd /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')

# Method 2: If that fails, try to get it from /mnt/c/Users
if [ -z "$WIN_USERNAME" ] || [ "$WIN_USERNAME" = "%USERNAME%" ]; then
  echo "Trying alternative method to detect username..."
  # List directories in /mnt/c/Users and pick the most likely user directory
  # Exclude common system directories
  WIN_USERNAME=$(ls -la /mnt/c/Users/ | grep -v "Public\|Default\|All Users\|desktop.ini\|total" | head -1 | awk '{print $9}')
fi

# Method 3: If that fails too, ask the user
if [ -z "$WIN_USERNAME" ]; then
  echo "Could not automatically detect Windows username."
  read -p "Please enter your Windows username: " WIN_USERNAME
  if [ -z "$WIN_USERNAME" ]; then
    echo "Error: Windows username is required to continue."
    exit 1
  fi
fi

echo "Windows username detected: $WIN_USERNAME"

# Verify the user directory exists
if [ ! -d "/mnt/c/Users/$WIN_USERNAME" ]; then
  echo "Warning: Directory /mnt/c/Users/$WIN_USERNAME does not exist."
  read -p "Continue anyway? (y/n): " CONTINUE
  if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
    echo "Installation aborted."
    exit 1
  fi
fi

# Define paths
POWERSHELL_DIR="/mnt/c/Users/$WIN_USERNAME/Documents/PowerShell"
POWERSHELL_CONFIG_DIR="/mnt/c/Users/$WIN_USERNAME/.config/PowerShell"
TEMP_DIR="/mnt/c/Users/$WIN_USERNAME/AppData/Local/Temp/ps_setup_$(date +%s)"
WIN_HOME_DIR="/mnt/c/Users/$WIN_USERNAME"
WIN_NVIM_CONFIG_DIR="/mnt/c/Users/$WIN_USERNAME/AppData/Local/nvim"

# Create directories if they don't exist
echo "Creating PowerShell directories..."
mkdir -p "$POWERSHELL_DIR"
mkdir -p "$POWERSHELL_CONFIG_DIR"
mkdir -p "$TEMP_DIR"
mkdir -p "$WIN_NVIM_CONFIG_DIR"

# Copy files to both locations (Documents is the default; .config is for newer PowerShell versions)
echo "Copying files to Windows PowerShell directories..."
cp "$(dirname "$0")/Microsoft.PowerShell_profile.ps1" "$POWERSHELL_DIR/"
cp "$(dirname "$0")/aliases.ps1" "$POWERSHELL_DIR/"
cp "$(dirname "$0")/Microsoft.PowerShell_profile.ps1" "$POWERSHELL_CONFIG_DIR/"
cp "$(dirname "$0")/aliases.ps1" "$POWERSHELL_CONFIG_DIR/"

echo "Files copied successfully to:"
echo "- $POWERSHELL_DIR"
echo "- $POWERSHELL_CONFIG_DIR"

# Copy git configuration files to Windows home directory
echo "Copying git configuration files..."
if [ -f "$HOME/.gitconfig" ]; then
  cp "$HOME/.gitconfig" "$WIN_HOME_DIR/"
  echo "- .gitconfig copied to Windows home directory"
else
  echo "- .gitconfig not found in WSL home directory, skipping"
fi

if [ -f "$HOME/.gitignore" ]; then
  cp "$HOME/.gitignore" "$WIN_HOME_DIR/"
  echo "- .gitignore copied to Windows home directory"
else
  echo "- .gitignore not found in WSL home directory, skipping"
fi

# Copy Neovim configuration files to Windows
echo "Copying Neovim configuration files..."
if [ -d "$HOME/.config/nvim" ]; then
  # Copy all contents of the nvim directory
  cp -r "$HOME/.config/nvim/"* "$WIN_NVIM_CONFIG_DIR/"
  echo "- Neovim configuration copied to Windows ($WIN_NVIM_CONFIG_DIR)"
else
  echo "- Neovim configuration not found in WSL (~/.config/nvim), skipping"
fi

# Create an automated PowerShell setup script
SETUP_SCRIPT="$TEMP_DIR/setup.ps1"

cat > "$SETUP_SCRIPT" << 'EOL'
# Set execution policy for current process only
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Simple progress report function
function Write-Status {
    param(
        [string]$Message,
        [string]$Status,
        [string]$Color = "White"
    )

    Write-Host $Message -NoNewline
    Write-Host " [$Status]" -ForegroundColor $Color
}

# Install required PowerShell modules
Write-Host "Installing PowerShell modules..." -ForegroundColor Cyan

# PSReadLine
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Write-Host "Installing PSReadLine..." -NoNewline
    try {
        Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        Write-Host " [Success]" -ForegroundColor Green
    } catch {
        Write-Host " [Failed]" -ForegroundColor Red
        Write-Host "Manual command: Install-Module -Name PSReadLine -Scope CurrentUser -Force -AllowClobber" -ForegroundColor Yellow
    }
} else {
    Write-Status "PSReadLine" "Already Installed" "Green"
}

# z
if (-not (Get-Module -ListAvailable -Name z)) {
    Write-Host "Installing z..." -NoNewline
    try {
        Install-Module -Name z -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        Write-Host " [Success]" -ForegroundColor Green
    } catch {
        Write-Host " [Failed]" -ForegroundColor Red
        Write-Host "Manual command: Install-Module -Name z -Scope CurrentUser -Force -AllowClobber" -ForegroundColor Yellow
    }
} else {
    Write-Status "z" "Already Installed" "Green"
}

# Terminal-Icons
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Write-Host "Installing Terminal-Icons..." -NoNewline
    try {
        Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        Write-Host " [Success]" -ForegroundColor Green
    } catch {
        Write-Host " [Failed]" -ForegroundColor Red
        Write-Host "Manual command: Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -AllowClobber" -ForegroundColor Yellow
    }
} else {
    Write-Status "Terminal-Icons" "Already Installed" "Green"
}

# PSFzf
if (-not (Get-Module -ListAvailable -Name PSFzf)) {
    Write-Host "Installing PSFzf..." -NoNewline
    try {
        Install-Module -Name PSFzf -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        Write-Host " [Success]" -ForegroundColor Green
    } catch {
        Write-Host " [Failed]" -ForegroundColor Red
        Write-Host "Manual command: Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber" -ForegroundColor Yellow
    }
} else {
    Write-Status "PSFzf" "Already Installed" "Green"
}

# Install Git if not already installed
if (-not (Get-Command -Name 'git' -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..." -ForegroundColor Cyan

    $gitInstalled = $false

    # Method 1: Try winget
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        Write-Host "Trying winget method..." -NoNewline
        try {
            winget install Git.Git -h --accept-package-agreements --accept-source-agreements
            Write-Host " [Success]" -ForegroundColor Green
            $gitInstalled = $true

            # Add Git to the current session PATH
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
        } catch {
            Write-Host " [Failed]" -ForegroundColor Red
        }
    }

    # Final status
    if ($gitInstalled) {
        Write-Host "Git installed successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to install Git. Please install manually from https://git-scm.com/download/win" -ForegroundColor Yellow
    }
} else {
    Write-Status "Git" "Already Installed" "Green"
}

# Install Neovim if not already installed
if (-not (Get-Command -Name 'nvim' -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Neovim..." -ForegroundColor Cyan

    $nvimInstalled = $false

    # Method 1: Try winget
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        Write-Host "Trying winget method..." -NoNewline
        try {
            winget install Neovim.Neovim -h --accept-package-agreements --accept-source-agreements
            Write-Host " [Success]" -ForegroundColor Green
            $nvimInstalled = $true

            # Add Neovim to the current session PATH
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
        } catch {
            Write-Host " [Failed]" -ForegroundColor Red
        }
    }

    # Final status
    if ($nvimInstalled) {
        Write-Host "Neovim installed successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to install Neovim. Please install manually from https://github.com/neovim/neovim/releases" -ForegroundColor Yellow
    }
} else {
    Write-Status "Neovim" "Already Installed" "Green"
}

# Install Oh My Posh
if (-not (Get-Command -Name 'oh-my-posh' -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Oh My Posh..." -ForegroundColor Cyan

    $ohmyposhInstalled = $false

    # Method 1: Try winget
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        Write-Host "Trying winget method..." -NoNewline
        try {
            winget install JanDeDobbeleer.OhMyPosh -h --accept-package-agreements --accept-source-agreements
            Write-Host " [Success]" -ForegroundColor Green
            $ohmyposhInstalled = $true
        } catch {
            Write-Host " [Failed]" -ForegroundColor Red
        }
    }

    # Method 2: Try direct download if winget failed
    if (-not $ohmyposhInstalled) {
        Write-Host "Trying direct download method..." -NoNewline
        try {
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
            Write-Host " [Success]" -ForegroundColor Green
            $ohmyposhInstalled = $true
        } catch {
            Write-Host " [Failed]" -ForegroundColor Red
        }
    }

    # Final status
    if ($ohmyposhInstalled) {
        Write-Host "Oh My Posh installed successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to install Oh My Posh. Please install manually from https://ohmyposh.dev/docs/installation/windows" -ForegroundColor Yellow
    }
} else {
    Write-Status "Oh My Posh" "Already Installed" "Green"
}

# Install git-delta (improved git diff)
if (-not (Get-Command -Name 'delta' -ErrorAction SilentlyContinue)) {
    Write-Host "Installing git-delta..." -ForegroundColor Cyan

    $deltaInstalled = $false

    # Method 1: Try winget
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        Write-Host "Trying winget method..." -NoNewline
        try {
            winget install dandavison.delta -h --accept-package-agreements --accept-source-agreements
            Write-Host " [Success]" -ForegroundColor Green
            $deltaInstalled = $true
        } catch {
            Write-Host " [Failed]" -ForegroundColor Red
        }
    }

    # Method 2: Try direct download if winget failed
    if (-not $deltaInstalled) {
        Write-Host "Trying direct download method..." -NoNewline
        try {
            # Create a temporary directory for the download
            $tempDir = Join-Path $env:TEMP "delta_install"
            New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

            # Determine latest version and download URL for Windows x64
            $releaseUrl = "https://api.github.com/repos/dandavison/delta/releases/latest"
            $release = Invoke-RestMethod -Uri $releaseUrl
            $asset = $release.assets | Where-Object { $_.name -like "*x86_64-pc-windows-msvc.zip" } | Select-Object -First 1

            if ($asset) {
                # Download the zip file
                $zipPath = Join-Path $tempDir "delta.zip"
                Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath

                # Extract the zip file
                Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force

                # Move the executable to a directory in PATH
                $targetDir = "$env:USERPROFILE\.local\bin"
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }

                # Find the delta.exe in the extracted directory
                $deltaExe = Get-ChildItem -Path $tempDir -Filter "delta.exe" -Recurse | Select-Object -First 1

                if ($deltaExe) {
                    Copy-Item -Path $deltaExe.FullName -Destination $targetDir

                    # Add to PATH if not already there
                    if ($env:PATH -notlike "*$targetDir*") {
                        $env:PATH += ";$targetDir"
                        [System.Environment]::SetEnvironmentVariable('PATH', $env:PATH, [System.EnvironmentVariableTarget]::User)
                    }

                    # Configure git to use delta
                    git config --global core.pager "delta"
                    git config --global interactive.diffFilter "delta --color-only"
                    git config --global delta.navigate true
                    git config --global delta.light false
                    git config --global delta.line-numbers true

                    Write-Host " [Success]" -ForegroundColor Green
                    $deltaInstalled = $true
                } else {
                    Write-Host " [Failed - delta.exe not found]" -ForegroundColor Red
                }

                # Clean up
                Remove-Item -Path $tempDir -Recurse -Force
            } else {
                Write-Host " [Failed - asset not found]" -ForegroundColor Red
            }
        } catch {
            Write-Host " [Failed]" -ForegroundColor Red
        }
    }

    # Final status
    if ($deltaInstalled) {
        Write-Host "git-delta installed successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to install git-delta. Please install manually from https://github.com/dandavison/delta/releases" -ForegroundColor Yellow
    }
} else {
    Write-Status "git-delta" "Already Installed" "Green"
}

# Create empty .env.ps1 file if it doesn't exist
$envFilePath = "$env:USERPROFILE\.env.ps1"
if (-not (Test-Path -Path $envFilePath -PathType Leaf)) {
    Set-Content -Path $envFilePath -Value "# Environment variables for PowerShell" -Force
    Write-Status ".env.ps1" "Created" "Green"
}

Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "Please restart PowerShell to apply the changes or run: . `$PROFILE" -ForegroundColor Cyan

# Load profile in current session
try {
    . $PROFILE
    Write-Host "Profile loaded successfully!" -ForegroundColor Green
} catch {
    Write-Host "Could not load profile automatically" -ForegroundColor Yellow
    Write-Host "You may need to restart PowerShell to apply changes." -ForegroundColor Yellow
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
EOL

# Create a launcher script that runs PowerShell with our setup script
LAUNCHER_SCRIPT="$TEMP_DIR/run_setup.bat"

# Convert WSL path to Windows path format
WIN_SETUP_SCRIPT=$(wslpath -w "$SETUP_SCRIPT" 2>/dev/null)
if [ -z "$WIN_SETUP_SCRIPT" ]; then
  # Fallback if wslpath is not available
  WIN_SETUP_SCRIPT="C:\\Users\\$WIN_USERNAME\\AppData\\Local\\Temp\\ps_setup_$(date +%s)\\setup.ps1"
fi

cat > "$LAUNCHER_SCRIPT" << EOL
@echo off
echo Running PowerShell setup script...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '$WIN_SETUP_SCRIPT'"
echo.
echo Setup complete! Press any key to exit...
pause > nul
EOL

# Make the batch file executable
chmod +x "$LAUNCHER_SCRIPT"

# Show manual instructions since automatic launch might not work
echo
echo "Setup files created successfully!"
echo "-------------------------------------------------"
echo "To complete installation:"
echo "1. Open File Explorer in Windows"
echo "2. Navigate to: C:\\Users\\$WIN_USERNAME\\AppData\\Local\\Temp\\ps_setup_$(date +%s)"
echo "3. Double-click run_setup.bat"
echo "-------------------------------------------------"

# Try to open the Windows directory containing our files
if which explorer &> /dev/null; then
  echo "Attempting to open the folder in Windows Explorer..."
  WIN_TEMP_DIR=$(wslpath -w "$TEMP_DIR" 2>/dev/null)
  if [ ! -z "$WIN_TEMP_DIR" ]; then
    explorer "$WIN_TEMP_DIR"
    echo "Windows Explorer should open the folder location."
  fi
fi

echo "Your PowerShell environment files have been copied and setup files created."
echo "After running the batch file, your PowerShell environment will be configured."

exit 0