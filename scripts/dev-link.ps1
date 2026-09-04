<#
.SYNOPSIS
  Switch the in-game mod between this working copy (dev) and the released version from the mod portal.

.DESCRIPTION
  on      Link the repo into Factorio's mods folder as a junction named after the mod, park any
          portal-downloaded zips of the mod (renamed to *.zip.off so Factorio ignores them), and
          enable the mod in mod-list.json.
  off     Remove the junction and restore parked zips. The mod stays enabled in mod-list.json when a
          zip is present; otherwise it is disabled so Factorio does not complain about a missing mod.
          Install the released version from the in-game mod portal if no zip is present.
  status  Show what is currently active.

  Factorio must not be running while switching; it reads the mods folder at startup.

.PARAMETER ModsDir
  Factorio's mods folder. Defaults to %APPDATA%\Factorio\mods.

.EXAMPLE
  scripts/dev-link.ps1 on
  scripts/dev-link.ps1 off
  scripts/dev-link.ps1 status
#>
[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet('on', 'off', 'status')]
  [string]$Action = 'status',

  [string]$ModsDir = (Join-Path $env:APPDATA 'Factorio\mods')
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$info = Get-Content (Join-Path $repoRoot 'info.json') -Raw | ConvertFrom-Json
$modName = $info.name
$linkPath = Join-Path $ModsDir $modName
$modListPath = Join-Path $ModsDir 'mod-list.json'

if (-not (Test-Path $ModsDir)) { throw "Mods folder not found: $ModsDir" }
if (Get-Process -Name factorio -ErrorAction SilentlyContinue) {
  Write-Warning 'Factorio is running; changes take effect after a restart.'
}

function Get-Junction {
  $item = Get-Item $linkPath -Force -ErrorAction SilentlyContinue
  if ($item -and $item.LinkType -eq 'Junction') { return $item }
  return $null
}

function Get-Zips([string]$suffix) {
  Get-ChildItem $ModsDir -File -Filter "${modName}_*.zip$suffix"
}

function Set-ModEnabled([bool]$enabled) {
  $json = Get-Content $modListPath -Raw | ConvertFrom-Json
  $entry = $json.mods | Where-Object { $_.name -eq $modName }
  if ($entry) {
    $entry.enabled = $enabled
  } else {
    $json.mods += [pscustomobject]@{ name = $modName; enabled = $enabled }
  }
  $json | ConvertTo-Json -Depth 5 | Set-Content $modListPath -Encoding utf8
}

function Show-Status {
  $junction = Get-Junction
  $zips = Get-Zips ''
  $parked = Get-Zips '.off'
  $entry = (Get-Content $modListPath -Raw | ConvertFrom-Json).mods | Where-Object { $_.name -eq $modName }

  if ($junction) {
    Write-Host "mode:      dev (junction -> $($junction.Target))"
  } elseif ($zips) {
    Write-Host "mode:      released ($($zips.Name -join ', '))"
  } else {
    Write-Host 'mode:      none (no junction, no zip; install from the mod portal or run: dev-link.ps1 on)'
  }
  if ($parked) { Write-Host "parked:    $($parked.Name -join ', ')" }
  if ($entry) { Write-Host "mod-list:  enabled = $($entry.enabled)" } else { Write-Host 'mod-list:  no entry' }
  Write-Host "repo:      $modName $($info.version) at $repoRoot"
}

switch ($Action) {
  'on' {
    if (Test-Path $linkPath) {
      if (-not (Get-Junction)) { throw "$linkPath exists and is not a junction; refusing to replace it." }
    } else {
      New-Item -ItemType Junction -Path $linkPath -Target $repoRoot | Out-Null
      Write-Host "created junction $linkPath -> $repoRoot"
    }
    foreach ($zip in Get-Zips '') {
      Rename-Item $zip.FullName "$($zip.Name).off"
      Write-Host "parked $($zip.Name)"
    }
    Set-ModEnabled $true
    Show-Status
  }
  'off' {
    $junction = Get-Junction
    if ($junction) {
      # Remove only the junction, never the target's contents.
      [System.IO.Directory]::Delete($linkPath)
      Write-Host "removed junction $linkPath"
    } elseif (Test-Path $linkPath) {
      throw "$linkPath exists and is not a junction; not touching it."
    }
    foreach ($zip in Get-Zips '.off') {
      $restored = $zip.Name -replace '\.off$', ''
      Rename-Item $zip.FullName $restored
      Write-Host "restored $restored"
    }
    $hasZip = [bool](Get-Zips '')
    Set-ModEnabled $hasZip
    if (-not $hasZip) {
      Write-Host "no released zip in $ModsDir; install $modName from the in-game mod portal."
    }
    Show-Status
  }
  'status' { Show-Status }
}
