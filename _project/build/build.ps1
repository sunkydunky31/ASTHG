#!/usr/bin/env pwsh
#requires -Version 6.0 -PSEdition Core

param(
	[Parameter()]
	[switch]$Is32Bits,

	[Parameter()]
	[ValidateSet('build', 'run', 'test', 'clean')]
	[string]$Action = 'build',

	[Parameter()] # Only ones that the game supports
	[ValidateSet('android', 'cpp', 'html5',
		'hl', 'hashlink',
		'linux', 'mac', 'ios', 'windows')]
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
$haxelib = (Get-Command 'haxelib' -ErrorAction SilentlyContinue)

if ($null -eq $haxelib) {
	$haxelib = Join-Path (Read-Host ($Msg['InsertHaxelib'] -Join "`n")) 'haxelib'
}

$hxArgs = @('run', 'lime', $Action, $Platform, "-$BuildType")
$PlatformOG = if ($Platform -eq 'cpp') {
	if ($IsWindows) { 'windows' }
	elseif ($IsLinux) { 'linux' }
	else { 'macos' }
}
else { $Platform }

function New-CleanOldFiles {
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string]$CleanPath
	)

	try {
		$files = @('assets', 'manifest', 'lime.ndll')

		if ($IsWindows) {
			$files += 'VisualElements', 'icon.ico'

			$project = Get-Content (Write-Path -Path $PSScriptRoot, '..', '..', 'project.hxp' -Resolve) -Raw

			if ($project -match '"file" => "(.*)",') {
				# This is crazy bro
				$files += "$($Matches[1]).VisualElementsManifest.xml", "$($Matches[1]).exe"
			}
		}

		if (Test-Path $CleanPath) {
			Write-Host $Msg.Cleaning
			foreach ($i in $files) {
				if (Test-Path (Join-Path $CleanPath $i)) {
					Remove-Item -Path (Join-Path $CleanPath $i) -Recurse -Force
				}
			}
		}
	}
	catch {
		Write-Host ($Msg.CleaningError -f $_) -ForegroundColor Red
	}
}


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

# We can't run the app if it doesn't exists lol
if ($Action -in @('build', 'test')) {
	New-CleanOldFiles (Write-Path -Path (Get-Location), 'export', $BuildType, $PlatformOG, 'bin')
	Start-Sleep 3
}


& $haxelib @hxArgs

Set-Pause
