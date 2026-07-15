#!/usr/bin/env pwsh
#requires -Version 6.0 -PSEdition Core

param(
	[Parameter()]
	[switch]$Is32Bits,

	[Parameter()]
	[ValidateSet('build', 'run', 'test', 'clean')]
	[string]$Action,

	[Parameter()] # Only ones that is supported to HaxeFlixel
	[ValidadeSet('cpp', 'html5', 'windows', 'linux', 'mac', 'android', 'ios')]
	[string]$Platform,

	[Parameter()]
	[ValidateSet('release', 'debug', 'final')]
	[string]$BuildType,

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

<#
	.SYNOPSIS
	Helper for set default values into a property,
	.PARAMETER value
	Sets the value to use
	.PARAMETER default
	Sets the default value if null or white space
#>
function Set-DefaultValue([string]$value, [string]$default) {
	$value = if ($value -ne $null) { $value.Trim() } else { '' }
	if ([string]::IsNullOrWhiteSpace($value)) { return $default }
	return $value
}

function Write-PlatformNameFix {
	param([string]$Name)
	if ([string]::IsNullOrWhiteSpace($Name)) { return $null }

	switch ($name.ToLower()) {
		'c#' { return 'cs' }
		'c++' { return 'cpp' }
		'javascript' { return 'js' }
		'hashlink' { return 'hl' }
		'nekovm' { return 'neko' }
		default { return "$name" }
	}
}

# Start with default settings if not called on PowerShell terminal
# CPP -> Windows / Linux / MacOS (depends on host)
$Platform = Set-DefaultValue (Write-PlatformNameFix "$Platform") -default "$(if ($IsWindows -or $IsLinux -or $IsMacOS) { 'cpp' } else { 'hl' })"
$Action = Set-DefaultValue $Action -default 'build'
$Is32Bits = Set-DefaultValue $Is32Bits -default 'false'
$BuildType = Set-DefaultValue $BuildType -default 'release'

$Is32Bits = ($Is32Bits -in @('y', 'yes', 'true', '1'))

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
