# clip2path uninstaller — https://github.com/j7-dev/clip2path
#
# One-line uninstall:
#   irm https://raw.githubusercontent.com/j7-dev/clip2path/main/uninstall.ps1 | iex

$ErrorActionPreference = 'Stop'

$installDir = "$env:LOCALAPPDATA\clip2path"
$startupLnk = "$([Environment]::GetFolderPath('Startup'))\clip2path.lnk"

# 1. Stop the running clip2path instance (only processes running clip2path.ahk are touched)
Get-CimInstance Win32_Process -Filter "Name = 'AutoHotkey64.exe'" |
    Where-Object { $_.CommandLine -like '*clip2path.ahk*' } |
    ForEach-Object {
        Stop-Process -Id $_.ProcessId -Force
        Write-Host "Stopped clip2path process (PID $($_.ProcessId))"
    }

# 2. Remove the startup shortcut
if (Test-Path $startupLnk) {
    Remove-Item $startupLnk -Force
    Write-Host "Removed startup shortcut: $startupLnk"
}

# 3. Remove installed files
if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force
    Write-Host "Removed install directory: $installDir"
}

Write-Host ''
Write-Host '✅ clip2path uninstalled.' -ForegroundColor Green
Write-Host '   Note: AutoHotkey itself was NOT removed. To remove it as well:'
Write-Host '   winget uninstall AutoHotkey.AutoHotkey'
Write-Host '   Saved PNG files in %TEMP% are also kept and will be cleaned up by Windows automatically.'
