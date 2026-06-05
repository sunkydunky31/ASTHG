#requires -PSEdition Core
#requires -Version 6

# ^^^^^^ Kinda be ridiculous, but this is for a maniac who will try to run this on PowerShell 4 or something.
# By that, WHY ARE YOU RUNNING ON AN OUTDATED PS VERSION???????????

param(
	[string]$Is32Bits,
	[string]$Action,
	[string]$Platform,
	[string]$BuildType,
	[string[]]$BuildFlags
)

# Import translations folders if available
Import-LocalizedData -BindingVariable "Msg" -ErrorAction Stop

$Host.UI.RawUI.WindowTitle = $Msg.Title
Clear-Host

# Checker for Haxelib + Stops running if not found
$haxelib = (Get-Command "haxelib" -ErrorAction SilentlyContinue)

if ($haxelib -eq $null) {
	$haxelib = (Join-Path (Read-Host ($Msg.InsertHaxelib).Join("`n")) "haxelib")
}

<#
	.DESCRIPTION
	Helper for set default values into a property,

	.PARAMETER value
	Sets the value to use
	.PARAMETER default
	Sets the default value if null or white space
#>
function Set-DefaultValue([string]$value, [string]$default) {
	$value = if ($value -ne $null) { $value.Trim() } else { "" }
	if ([string]::IsNullOrWhiteSpace($value)) {
		return $default
	}
	return $value
}

# Start with default settings if not called on PowerShell terminal
# CPP -> Windows / Linux / MacOS (depends on host)
$Platform  = Set-DefaultValue $Platform  -default (($IsWindows -or $IsLinux -or $IsMacOS) ? "cpp" : "hl")
$Action    = Set-DefaultValue $Action    "build"
$Is32Bits  = Set-DefaultValue $Is32Bits  "false"
$BuildType = Set-DefaultValue $BuildType "release"

$Is32Bits = ($Is32Bits -in @("y", "yes", "true", "1"))

$hxArgs = @("run", "lime", $Action, $Platform, "-$BuildType")
$PlatformOG = ($Platform -eq "cpp" ? ($IsWindows ? "windows" : $IsLinux ? "linux" : "macos") : $Platform)

<#
	.DESCRIPTION
	Function to simulate the "pause" command on Command Prompt on Windows.

	.NOTES
	This function calls "Command Prompt" if you're using Windows.
#>
function Set-Pause {
	if ($IsWindows) { & "cmd.exe" "/c" "pause" }
	else {
		Write-Host ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
	}
}

function New-CleanOldFiles {
	param(
		[Parameter(Mandatory=$true, Position=0)]
		[string]$CleanPath
	)

	$CleanPath = $CleanPath.Trim().Replace("\", "/")

	try {
		if (Test-Path $CleanPath) {
			Write-Host $Msg.Cleaning
				Remove-Item -Path $CleanPath -Recurse -Force
		}
	}
	catch {
		Write-Host ($Msg.CleaningError -f $_) -ForegroundColor Red
	}
}

# Set the cwd to "ASTHG"
Set-Location "$PSScriptRoot/../../"

# If arguments are available, add them
if (-not [string]::IsNullOrEmpty($BuildFlags)) {
	$hxArgs += $BuildFlags
}

# Draw config info and pause
foreach ($srt in @("Is32Bits", "Action", "Platform", "BuildType", "BuildFlags")) {
	$val = Get-Variable -Name $srt -ValueOnly
	Write-Host ($Msg.Config[$srt] -f "$val")
}
Set-Pause

# User confirmed, ready to go!
Clear-Host
Write-Host ($Msg.BuildTexts["$Action"])

# We can't run the app if it doesn't exists lol
if ($Action -in @("build", "test")) {
	New-CleanOldFiles "$(Get-Location)/export/$BuildType/$PlatformOG/bin"
	Start-Sleep 3
}


& $haxelib @hxArgs

Set-Pause
