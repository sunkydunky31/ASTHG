#!/usr/bin/env pwsh
#requires -Version 6.0 -PSEdition Core

param(
	[Parameter()]
	[switch]$Is32Bits,

	[Parameter()]
	[ValidateSet('build', 'run', 'test', 'clean')]
	[string]$Action = 'build',

	[Parameter()] # Only ones that the game supports
	[ValidateSet('android', 'cpp', 'html5', 'hl', 'hashlink', 'linux', 'mac', 'neko', 'ios', 'windows')]
	[string]$Platform = "$(if ($IsWindows -or $IsLinux -or $IsMacOS) { 'cpp' } else { 'hl' })",

	[Parameter()]
	[ValidateSet('release', 'debug', 'final')]
	[string]$BuildType = 'release',

	[Parameter()]
	[string[]]$BuildFlags
)

# Import translations folders if available
Import-LocalizedData -BindingVariable 'Msg' -ErrorAction Stop

Import-Module (Join-Path -Path "$PSScriptRoot" -ChildPath 'util.ps1')

$Host.UI.RawUI.WindowTitle = $Msg.Title
Clear-Host

# Checker for Haxelib + Stops running if not found
$HAXELIB = (Get-Command 'haxelib' -ErrorAction SilentlyContinue)

if ($null -eq $HAXELIB) {
	$HAXELIB = Join-Path (Read-Host ($Msg['InsertHaxelib'] -Join "`n")) 'haxelib'
}

$hxArgs = @('run', 'lime', $Action, $Platform, "-$BuildType")
$PlatformOG = if ($Platform -eq 'cpp') {
	if ($IsWindows) { 'windows' }
	elseif ($IsLinux) { 'linux' }
	else { 'macos' }
}
else { $Platform }

# Set the cwd to "ASTHE"
Set-Location (Write-Path -Path $PSScriptRoot, '..', '..' -Resolve)

# If arguments are available, add them
if (-not [string]::IsNullOrEmpty($BuildFlags)) {
	$hxArgs += $BuildFlags
}

# Draw config info and pause
Write-Host $Msg["ConfigTitle"]
foreach ($srt in @('Is32Bits', 'Action', 'Platform', 'BuildType', 'BuildFlags')) {
	$val = Get-Variable -Name $srt -ValueOnly
	Write-Host ($Msg.Config[$srt] -f "$val")
}
Set-Pause

# User confirmed, ready to go!
Clear-Host
Write-Host ($Msg.BuildTexts[$Action])

& $HAXELIB @hxArgs

Set-Pause
