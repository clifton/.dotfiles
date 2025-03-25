# PowerShell Profile Installer Script
# This script installs the PowerShell profile and aliases

# Ensure we are running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script should be run as administrator. Some features may not work properly."
}

# Check if PowerShell profile exists and create it if it doesn't
if (-not (Test-Path -Path $PROFILE -PathType Leaf)) {
    $profileDir = Split-Path -Path $PROFILE -Parent
    if (-not (Test-Path -Path $profileDir -PathType Container)) {
        New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
    }
    New-Item -Path $PROFILE -ItemType File -Force | Out-Null
    Write-Host "Created PowerShell profile at $PROFILE" -ForegroundColor Green
}

# Define source and destination paths
$sourceDir = $PSScriptRoot
$profileDir = Split-Path -Path $PROFILE -Parent

Write-Host "Installing PowerShell profile from $sourceDir to $profileDir..." -ForegroundColor Cyan

# Create backup of existing profile if it exists
if (Test-Path -Path $PROFILE -PathType Leaf) {
    $backupPath = "$PROFILE.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item -Path $PROFILE -Destination $backupPath -Force
    Write-Host "Created backup of existing profile at $backupPath" -ForegroundColor Yellow
}

# Copy profile files to the destination
$files = @(
    "Microsoft.PowerShell_profile.ps1",
    "aliases.ps1"
)

foreach ($file in $files) {
    $sourcePath = Join-Path -Path $sourceDir -ChildPath $file
    
    if ($file -eq "Microsoft.PowerShell_profile.ps1") {
        # Special handling for profile - we want to update the existing profile
        $profileContent = Get-Content -Path $sourcePath -Raw
        Set-Content -Path $PROFILE -Value $profileContent -Force
        Write-Host "Updated PowerShell profile at $PROFILE" -ForegroundColor Green
    } else {
        # Copy other files to the profile directory
        $destPath = Join-Path -Path $profileDir -ChildPath $file
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "Copied $file to $destPath" -ForegroundColor Green
    }
}

# Install required PowerShell modules
$modules = @(
    "PSReadLine",
    "z",
    "Terminal-Icons",
    "PSFzf"
)

foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module $module..." -ForegroundColor Cyan
        Install-Module -Name $module -Scope CurrentUser -Force
    } else {
        Write-Host "Module $module is already installed." -ForegroundColor Green
    }
}

# Install Oh My Posh using winget
if (-not (Get-Command -Name 'oh-my-posh' -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Oh My Posh..." -ForegroundColor Cyan
    
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        # Use winget if available
        winget install JanDeDobbeleer.OhMyPosh -s winget
    } else {
        # Fallback to Install-Module
        Write-Host "Winget not found, installing Oh My Posh using Install-Module..." -ForegroundColor Yellow
        Install-Module oh-my-posh -Scope CurrentUser -Force
    }
}

# Reload profile or instruct user to reload
Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "To load the new profile immediately, run:" -ForegroundColor Cyan
Write-Host ". $PROFILE" -ForegroundColor White
Write-Host "Alternatively, restart your PowerShell session." -ForegroundColor Cyan

# Optional: create .env.ps1 file if it doesn't exist
$envFilePath = "$env:USERPROFILE\.env.ps1"
if (-not (Test-Path -Path $envFilePath -PathType Leaf)) {
    Set-Content -Path $envFilePath -Value "# Environment variables for PowerShell" -Force
    Write-Host "Created empty .env.ps1 file at $envFilePath" -ForegroundColor Green
} 