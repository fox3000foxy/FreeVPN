# Requires -RunAsAdministrator
param(
    [string]$InputArg,
    [switch]$AutoChoose
)

$RepoDir = "auto-ovpn"
$RepoUrl = "https://github.com/9xN/auto-ovpn"

# Clone or update the repo
if (-not (Test-Path $RepoDir)) {
    git clone --quiet --depth 1 $RepoUrl $RepoDir
} else {
    Push-Location $RepoDir
    git fetch --quiet origin
    $local = git rev-parse @
    $remote = git rev-parse @{u}
    if ($local -ne $remote) {
        git pull --quiet
    }
    Pop-Location
}

if (-not $InputArg -or $InputArg -eq "--help") {
    Write-Host "Usage: .\openvpn.ps1 [-AutoChoose] <JP|KR|VN|RU|TH|US>"
    exit 1
}

# Find matching OVPN files
if ($InputArg -notmatch "/") {
    $matches = Get-ChildItem "$RepoDir/configs/*$InputArg.ovpn" -ErrorAction SilentlyContinue
    if (-not $matches) {
        Write-Host "No file found for pattern: $InputArg"
        exit 1
    } elseif ($matches.Count -eq 1 -or $AutoChoose) {
        $ovpnFile = $matches[0].FullName
        Write-Host "File automatically selected: $ovpnFile"
    } else {
        Write-Host "Multiple files found:"
        $i = 1
        foreach ($file in $matches) {
            Write-Host "$i) $($file.Name)"
            $i++
        }
        do {
            $choice = Read-Host "Select file number"
        } while (-not ($choice -as [int]) -or $choice -lt 1 -or $choice -gt $matches.Count)
        $ovpnFile = $matches[$choice - 1].FullName
    }
} else {
    $ovpnFile = $InputArg
}

if (-not (Test-Path $ovpnFile)) {
    Write-Host "File not found: $ovpnFile"
    exit 1
}

# Replace 'cipher' with 'data-ciphers' in a temp file
$tmpOvpn = [System.IO.Path]::GetTempFileName()
Get-Content $ovpnFile | ForEach-Object {
    if ($_ -match '^\s*cipher\s+') {
        $_ -replace '^\s*cipher\s+', 'data-ciphers '
    } else {
        $_
    }
} | Set-Content $tmpOvpn

Write-Host "Using modified OVPN config (cipher -> data-ciphers):"
Select-String 'data-ciphers' $tmpOvpn
Start-Process -Wait -Verb RunAs openvpn.exe -ArgumentList "--config `"$tmpOvpn`" --verb 0"

Remove-Item $tmpOvpn -Force