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

# Redis cache function
function Flush-RedisCache {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RedisUrl
    )
    
    if (-not (Get-Command -Name 'redis-cli' -ErrorAction SilentlyContinue)) {
        Write-Error "redis-cli not found. Please install Redis tools."
        return
    }
    
    Write-Host "Flushing Redis cache keys..." -ForegroundColor Yellow
    $keys = Invoke-Expression "redis-cli -u $RedisUrl KEYS 'cache:*'"
    
    if ($keys) {
        Invoke-Expression "redis-cli -u $RedisUrl DEL $keys"
        Write-Host "Cache keys deleted successfully" -ForegroundColor Green
    } else {
        Write-Host "No cache keys found" -ForegroundColor Cyan
    }
}
Set-Alias -Name flush_redis_cache -Value Flush-RedisCache 