
param(
	[string]$Is32Bits,
	[string]$Action,
	[string]$Platform,
	[string[]]$BuildFlags
)

$Msg = DATA { @{ # Culture: 'en-US'
	Title = "ASTHG Build"
	PausePrompt = "Press any key to continue. . ." # Command prompt style message
	BuildTexts = @{
		"build" = "Building..."
		"test" = "Testing..."
		"run" = "Running... (from who?)"
	}
	Finished = "Finished."

	InsertHaxelib = "Looks like your PATH was corrupted or Haxe isn't installed.`nIf your Haxe is not installed, please, install it in 'https://haxe.org/download/4.3.7/'`nIf your PATH is corrupted, change the variables 'HAXEPATH' and 'NEKO_INSTPATH' from PATH by their absolute path, additionaly, Remove all binaries from Haxe and Neko folders replacing them with a ZIP version`nInsert you HaxeToolkit folder path where haxelib is located"
	
	ConfigAsk = @{
		"Platform" = "Please, insert a platform to build"
		"BuildFlags" = "Additional arguments"
		"Is32Bits" = "For 32 Bits?"
	}

	Config = @{
		"Platform" = "Platform: {0}"
		"BuildFlags" = "Builf Flags: {0}"
		"Is32Bits" = "32 Bits: {0}"
	}
} }

Import-LocalizedData -BindingVariable "Msg" -ErrorAction SilentlyContinue


$Host.UI.RawUI.WindowTitle = $Msg.Title #Change the title of the terminal
Clear-Host # Clear all messages on the screen

$haxelib = if (-not (Get-Command "haxelib" -ErrorAction SilentlyContinue)) {
	Join-Path (Read-Host ($Msg.InsertHaxelib)) "haxelib"
} else { Get-Command "haxelib" -ErrorAction Stop}

if ([string]::IsNullOrEmpty($Platform))		{ $Platform	= if ($IsWindows) { "windows" } elseif ($IsLinux) { "linux" }  elseif ($IsMacOS) { "mac" } else { "hl" } }
if ([string]::IsNullOrEmpty($BuildFlags))	{ $BuildFlags	= (Read-Host $Msg.ConfigAsk.BuildFlags) }
if ([string]::IsNullOrEmpty($Action))		{ $Action		= "build" }
if ([string]::IsNullOrEmpty($Is32Bits))		{ $Is32Bits		= (Read-Host $Msg.ConfigAsk.Is32Bits).toLower() }

$Is32Bits = ($Is32Bits -in @("y","yes","true","1"))

# in case the user left this blank

$hxArgs = @("run", "lime", $Action, $Platform)

function Set-Pause {
	if ($IsWindows) { & "cmd.exe" "/c" "pause" }
	else {
		Write-Host ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
	}
}

Set-Location (Resolve-Path "$PSScriptRoot/../../") # Set the cwd to "ASTHG"


if ($BuildFlags) {
	$hxArgs += $BuildFlags
}

# Draw config info and pause
foreach ($srt in $Msg["Config"].Keys) {
	$val = Get-Variable -Name $srt -ValueOnly
	Write-Host ($Msg.Config[$srt] -f $val.toLower())
}
Set-Pause

# User confirmed, ready to go!
Clear-Host
Write-Host ($Msg.BuildTexts["$Action"])
& $haxelib @hxArgs

Set-Pause