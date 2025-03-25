# PowerShell aliases - Similar to .aliases bash file

# Navigation shortcuts
function .. { Set-Location .. }
function ... { Set-Location ..\.. }

# Directory listing with Terminal-Icons module
function ll { Get-ChildItem -Force | Format-Table -View childrenWithIcon }
function la { Get-ChildItem -Force -Hidden | Format-Table -View childrenWithIcon }
function ls { Get-ChildItem | Format-Table -View childrenWithIcon }
function lsd { Get-ChildItem -Directory | Format-Table -View childrenWithIcon }

# Git aliases (similar to your .aliases file)
function gst { git status --short }
function gl { git pull }
function gd { git diff --no-prefix }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gp { git push $args }
function br { git branch --show-current }
function gc { git commit -v }
function gb { git branch }

# Network utilities
function myip { (Invoke-WebRequest -Uri "https://api.ipify.org").Content }
function ips { Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" } | Select-Object IPAddress }

# Start a simple HTTP server (similar to your server alias)
function server {
    $port = 6060
    Start-Process "http://localhost:$port/"
    python -m http.server $port
}

# Docker compose alias
function dc { docker compose $args }

# Add session management with PSSession (similar to your sesh function)
function sc {
    $sessions = Get-PSSession | Select-Object -ExpandProperty Name
    if ($sessions.Count -eq 0) {
        Write-Host "No active sessions found."
        return
    }

    $selected = $sessions | Out-GridView -Title "Pick a session" -OutputMode Single
    if ($selected) {
        Enter-PSSession -Name $selected
    }
}

# Vim alias for people used to using vim (maps to nvim if installed)
if (Get-Command -Name 'nvim' -ErrorAction SilentlyContinue) {
    function vim { nvim $args }
}

# Memory management function for Windows (similar to mem in WSL)
function Clean-Memory {
    Write-Host "Cleaning memory..." -ForegroundColor Green
    [System.GC]::Collect()
    Write-Host "Memory cleaned" -ForegroundColor Green
}
Set-Alias -Name mem -Value Clean-Memory

# Flush DNS cache (similar to flush alias)
function Flush-DNS {
    Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
    ipconfig /flushdns
    Write-Host "DNS cache flushed." -ForegroundColor Green
}
Set-Alias -Name flush -Value Flush-DNS

# Simple SSH key management function that works with Windows OpenSSH
function Add-SshKeys {
    # Check if Windows OpenSSH client is being used by Git
    $gitSshCommand = git config --global core.sshCommand
    $windowsOpenSshPath = "C:\Windows\System32\OpenSSH\ssh.exe"

    if (-not $gitSshCommand -or $gitSshCommand -ne $windowsOpenSshPath) {
        Write-Host "Configuring Git to use Windows OpenSSH client..." -ForegroundColor Cyan
        git config --global core.sshCommand $windowsOpenSshPath
        Write-Host "Git SSH command set to: $windowsOpenSshPath" -ForegroundColor Green
    }

    # Verify SSH agent service is running
    $sshAgentService = Get-Service -Name 'ssh-agent' -ErrorAction SilentlyContinue

    if ($null -eq $sshAgentService) {
        Write-Host "OpenSSH Authentication Agent service not found." -ForegroundColor Red
        Write-Host "Install OpenSSH Client using: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0" -ForegroundColor Yellow
        return
    }

    if ($sshAgentService.Status -ne 'Running') {
        Write-Host "SSH Agent service is not running." -ForegroundColor Yellow

        # Try to start the service
        try {
            Start-Service -Name 'ssh-agent' -ErrorAction Stop
            Write-Host "SSH Agent service started" -ForegroundColor Green
        } catch {
            Write-Host "Could not start SSH Agent service. Run these commands as Administrator:" -ForegroundColor Red
            Write-Host "  Set-Service -Name ssh-agent -StartupType Manual" -ForegroundColor White
            Write-Host "  Start-Service ssh-agent" -ForegroundColor White
            return
        }
    }

    # Set the environment variable to the Windows pipe
    $env:SSH_AUTH_SOCK = "\\.\pipe\openssh-ssh-agent"

    # Check which keys are already loaded
    Write-Host "Checking loaded SSH keys..." -ForegroundColor Cyan
    $loadedKeys = & "C:\Windows\System32\OpenSSH\ssh-add.exe" -l 2>&1

    if ($loadedKeys -like "*Could not open a connection*") {
        Write-Host "Error connecting to SSH agent. Please run PowerShell as Administrator and try again." -ForegroundColor Red
        return
    }

    # Get the keys to add
    $keysToAdd = @(
        "$env:USERPROFILE\.ssh\id_rsa",
        "$env:USERPROFILE\.ssh\id_ed25519"
    )

    # For each key, check if it exists and is already loaded
    foreach ($key in $keysToAdd) {
        if (Test-Path $key) {
            # Extract email from public key file if it exists
            $publicKeyPath = "$key.pub"
            $keyIdentifier = $null

            if (Test-Path $publicKeyPath) {
                $publicKeyContent = Get-Content $publicKeyPath -Raw
                if ($publicKeyContent -match ' ([^\s]+@[^\s]+)') {
                    $keyIdentifier = $Matches[1]
                }
            }

            # Check if key is already loaded
            $isLoaded = $false
            if ($keyIdentifier -and $loadedKeys -like "*$keyIdentifier*") {
                $isLoaded = $true
            }

            if ($isLoaded) {
                Write-Host "Key already loaded: $key" -ForegroundColor Green
            } else {
                Write-Host "Adding SSH key: $key" -ForegroundColor Cyan
                & "C:\Windows\System32\OpenSSH\ssh-add.exe" $key

                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Key added successfully" -ForegroundColor Green
                } else {
                    Write-Host "Failed to add key. Error code: $LASTEXITCODE" -ForegroundColor Red
                }
            }
        }
    }

    # List all loaded keys
    Write-Host "`nCurrently loaded SSH keys:" -ForegroundColor Cyan
    & "C:\Windows\System32\OpenSSH\ssh-add.exe" -l
}
Set-Alias -Name keys -Value Add-SshKeys

