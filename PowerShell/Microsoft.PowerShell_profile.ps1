# PowerShell Profile - Similar to .zshrc
# Equivalent to your ZSH setup, this file gets loaded when PowerShell starts

# Install and configure Oh My Posh (similar to powerlevel10k)
# Check if Oh My Posh is installed
if (-not (Get-Command -Name 'oh-my-posh' -ErrorAction SilentlyContinue)) {
    Write-Host "Oh My Posh not found. Installing..." -ForegroundColor Yellow
    winget install JanDeDobbeleer.OhMyPosh -s winget
    # Alternative: Install-Module oh-my-posh -Scope CurrentUser
}

# Import modules for extra functionality
# PSReadLine for better command line editing experience
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Scope CurrentUser -Force
}
Import-Module PSReadLine

# z-jump (similar to zoxide)
if (-not (Get-Module -ListAvailable -Name z)) {
    Install-Module -Name z -Scope CurrentUser -Force
}
Import-Module z

# Setup command autocompletion (similar to zsh-autosuggestions)
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Terminal icons for better directory listings
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
}
Import-Module Terminal-Icons

# Set up Oh My Posh theme with Tokyo Night Storm theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\tokyonight_storm.omp.json" | Invoke-Expression

# Source custom aliases file (similar to .aliases in ZSH)
. "$PSScriptRoot\aliases.ps1"

# Add user's local bin to PATH
$env:PATH += ";$env:USERPROFILE\.local\bin"

# History settings (similar to your ZSH history settings)
$MaximumHistoryCount = 5000

# Load environment file if it exists
if (Test-Path "$env:USERPROFILE\.env.ps1") {
    . "$env:USERPROFILE\.env.ps1"
}

# Check for fzf binary and load PSFzf only if available
# This requires fzf binary to be installed separately
function Install-Fzf {
    $fzfVersion = "0.46.1"
    $destination = "$env:USERPROFILE\.local\bin"
    $fzfZip = "$env:TEMP\fzf-$fzfVersion-windows_amd64.zip"
    $fzfUrl = "https://github.com/junegunn/fzf/releases/download/$fzfVersion/fzf-$fzfVersion-windows_amd64.zip"

    # Create destination directory if it doesn't exist
    if (-not (Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
        # Add to PATH if not already there
        if ($env:PATH -notlike "*$destination*") {
            $env:PATH += ";$destination"
            [System.Environment]::SetEnvironmentVariable('PATH', $env:PATH, [System.EnvironmentVariableTarget]::User)
        }
    }

    try {
        # Download fzf
        Write-Host "Downloading fzf $fzfVersion..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $fzfUrl -OutFile $fzfZip

        # Extract fzf
        Write-Host "Extracting fzf..." -ForegroundColor Cyan
        Expand-Archive -Path $fzfZip -DestinationPath $destination -Force

        # Clean up
        Remove-Item $fzfZip

        Write-Host "fzf installed successfully to $destination" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "Failed to install fzf: $_" -ForegroundColor Red
        Write-Host "Please install fzf manually from: https://github.com/junegunn/fzf/releases" -ForegroundColor Yellow
        return $false
    }
}

# Check if fzf is installed, and try to install it if not
$fzfCommand = Get-Command -Name 'fzf' -ErrorAction SilentlyContinue
if (-not $fzfCommand) {
    Write-Host "fzf binary not found. PSFzf requires the fzf executable." -ForegroundColor Yellow
    $installFzf = Read-Host "Would you like to install fzf now? (y/n)"
    if ($installFzf -eq 'y') {
        $success = Install-Fzf
        if ($success) {
            # Reload PATH to include the newly installed fzf
            $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User) + ";" + [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)
            $fzfCommand = Get-Command -Name 'fzf' -ErrorAction SilentlyContinue
        }
    }
}

# Only load PSFzf if fzf is available
if ($fzfCommand) {
    if (-not (Get-Module -ListAvailable -Name PSFzf)) {
        Install-Module -Name PSFzf -Scope CurrentUser -Force
    }
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
} else {
    Write-Host "PSFzf module is not loaded because fzf binary is missing." -ForegroundColor Yellow
    Write-Host "To manually install fzf, visit: https://github.com/junegunn/fzf/releases" -ForegroundColor Yellow
}

# Configure Git to use Windows OpenSSH client
$opensshPath = "C:\\Windows\\System32\\OpenSSH\\ssh.exe"
if (Test-Path $opensshPath) {
    # Configure Git to use Windows OpenSSH
    $gitSshCommand = git config --global core.sshCommand
    if (-not $gitSshCommand -or $gitSshCommand -ne $opensshPath) {
        Write-Host "Configuring Git to use Windows OpenSSH client..." -ForegroundColor Cyan
        git config --global core.sshCommand $opensshPath
        Write-Host "Git SSH command set to: $opensshPath" -ForegroundColor Green
    } else {
        # Write-Host "Git already configured to use Windows OpenSSH" -ForegroundColor Green
    }

    # Check and configure SSH agent service
    $sshAgentService = Get-Service -Name 'ssh-agent' -ErrorAction SilentlyContinue

    if ($null -ne $sshAgentService) {
        # Check if service is disabled and needs to be enabled
        if ($sshAgentService.StartType -eq 'Disabled') {
            Write-Host "SSH Agent service is disabled. To enable it, run as Administrator:" -ForegroundColor Yellow
            Write-Host "  Set-Service -Name ssh-agent -StartupType Manual" -ForegroundColor White
            Write-Host "  Start-Service ssh-agent" -ForegroundColor White
        } else {
            # Check if service is stopped and needs to be started
            if ($sshAgentService.Status -ne 'Running') {
                Write-Host "Starting SSH Agent service..." -ForegroundColor Cyan
                try {
                    Start-Service -Name 'ssh-agent' -ErrorAction Stop
                    Write-Host "SSH Agent service started" -ForegroundColor Green
                } catch {
                    Write-Host "Could not start SSH Agent service: $_" -ForegroundColor Red
                    Write-Host "Run PowerShell as Administrator to start the service" -ForegroundColor Yellow
                }
            } else {
                # Write-Host "SSH Agent service is running" -ForegroundColor Green
            }
        }

        # Set SSH_AUTH_SOCK environment variable to the Windows pipe path
        $env:SSH_AUTH_SOCK = "\\.\pipe\openssh-ssh-agent"
    } else {
        Write-Host "OpenSSH Authentication Agent service not found" -ForegroundColor Yellow
        Write-Host "Install OpenSSH Client using: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0" -ForegroundColor Yellow
    }
}

