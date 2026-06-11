# clip2path installer — https://github.com/j7-dev/clip2path
#
# One-line install:
#   irm https://raw.githubusercontent.com/j7-dev/clip2path/main/install.ps1 | iex
#
# Or run locally from a cloned repo:
#   .\install.ps1

$ErrorActionPreference = 'Stop'

$repo       = 'j7-dev/clip2path'
$branch     = 'main'
$installDir = "$env:LOCALAPPDATA\clip2path"
$files      = @('clip2path.ahk', 'save-clipboard-image.ps1')
$startupLnk = "$([Environment]::GetFolderPath('Startup'))\clip2path.lnk"

function Find-AhkExe {
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe",
        "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    return $null
}

# 1. Ensure AutoHotkey v2 is installed
$ahkExe = Find-AhkExe
if (-not $ahkExe) {
    Write-Host 'AutoHotkey v2 not found. Installing via winget...' -ForegroundColor Yellow
    winget install --id AutoHotkey.AutoHotkey --silent --accept-package-agreements --accept-source-agreements
    $ahkExe = Find-AhkExe
    if (-not $ahkExe) {
        throw 'AutoHotkey v2 installation failed. Install it manually from https://www.autohotkey.com/ and re-run this script.'
    }
}
Write-Host "AutoHotkey v2: $ahkExe"

# 2. Get script files (copy from local clone if available, otherwise download from GitHub)
New-Item -ItemType Directory -Force $installDir | Out-Null
$localSource = if ($PSScriptRoot -and (Test-Path "$PSScriptRoot\clip2path.ahk")) { $PSScriptRoot } else { $null }
foreach ($f in $files) {
    if ($localSource) {
        Copy-Item "$localSource\$f" "$installDir\$f" -Force
    } else {
        Invoke-WebRequest "https://raw.githubusercontent.com/$repo/$branch/$f" -OutFile "$installDir\$f" -UseBasicParsing
    }
}
Write-Host "Files installed to: $installDir"

# 3. Create startup shortcut (runs on every boot)
$ws  = New-Object -ComObject WScript.Shell
$lnk = $ws.CreateShortcut($startupLnk)
$lnk.TargetPath       = $ahkExe
$lnk.Arguments        = "`"$installDir\clip2path.ahk`""
$lnk.WorkingDirectory = $installDir
$lnk.Description      = 'clip2path - save clipboard image as PNG and type its path (Ctrl+Alt+V)'
$lnk.Save()
Write-Host "Startup shortcut created: $startupLnk"

# 4. Restart any running instance, then start
Get-CimInstance Win32_Process -Filter "Name = 'AutoHotkey64.exe'" |
    Where-Object { $_.CommandLine -like '*clip2path.ahk*' } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
Start-Process $ahkExe -ArgumentList "`"$installDir\clip2path.ahk`""

Write-Host ''
Write-Host '✅ clip2path installed and running!' -ForegroundColor Green
Write-Host '   Copy any image to the clipboard, place your cursor in a text field,'
Write-Host '   then press Ctrl+Alt+V — the image is saved as PNG and its path is typed for you.'
