param(
	[string]$StayOnMenu
)

$Msg = DATA { @{ # Culture: 'en-US'
	Done = "Done."
	Finished = "Finished."
	PausePrompt = "Press any key to continue. . ." # Command prompt style message

	InstallingDependencies = @{
		Default = "Installing dependencies."
		Android = "Installing additional Android dependencies."

		SubText = "This might take a few moments depending on your internet speed."
		HaxeWarn = "Make sure Haxe is installed and added to your PATH environment variable."
	}

	CheckinGGit = "Checking if git is installed..."
	GitInstalledPrompt = "Do you have Git installed? ({0}/{1})"
	GitSkippedPrompt = "Skipped libraries where Git is needed (you can install them later manually)."

	NotHaxe = "The script will exit because Haxe was not found.`nPlease, verify if you really have installed Haxe or if it exists in your PATH before using the setup/build script!"
	GetHaxePath = "Please, insert the location of your HaxeToolkit folder path."

	InstallingMSVC = @{
		Prompt = "Installing Microsoft Visual Studio BuildTools (Dependency)"
		ErrorDownload = "The download of VS BuildTools has failed: {0}"
		ErrorPath = "'{0}' was not found. Returning..."
	}

	UnsupportedPS = "You're using an older version of PowerShell`nPlease. Use PowerShell Core (6+), having in mind that it supports Unix-like systems."

	Menu = @{
		Title = "ASTHG Setup"
		Options = @(
			"Setup for Windows",
			"Setup for MacOS",
			"Setup for Android",
			"Remove setup files",
			"Exit"
		)
		Prompt = "Choose an option ({0}-{1})"
		Error = "Invalid option, please try again."
		ErrorOS = "This option is not available for your system."
	}

	yOption = "y" # 'Yes'
	nOption = "n" # 'No'

	RemoveSetup = @{
		Dependencies = "Removing dependencies..."
		LibraryDependencies = "Removing library dependencies..."
		InfoAndroid = "Checking for Android setup..."
		Android = "Android configuration detected!`nRemoving extra dependencies."
		NotAndroid = "Android configuration not found."
		GitFile = "Git dummy file found, removing Git libraries."
	}

	# Don't ask this
	DummyFile = "Don't delete this file!`nIt is used for setup script."

	NotAvailable = "Sorry, this option is not available for now."
} }

Import-LocalizedData -BindingVariable "Msg" -ErrorAction SilentlyContinue

# Checks if the user has PSCore 
if (($PSVersionTable.PSVersion).Major -lt "6") {
	Write-Error $Msg.UnsupportedPS
	exit
}

# Change the title of the windows
$Host.UI.RawUI.WindowTitle = $Msg.Menu.Title

if (Get-Command "haxelib" -ErrorAction SilentlyContinue) {
	$HaxeLib = "haxelib"
} else {throw $Msg.NotHaxe}

$GitDummyFile = "userHasGit.txt"
$ind = @("O", "X")

# Pause Metod used here
function Set-Pause {
	if ($IsWindows) { & "cmd.exe" "/c" "pause" }
	else {
		Write-Host ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
	}
}

# MAIN FUNCTION to call haxelib
function Get-Haxelib {
	param(
		[Parameter(Mandatory=$true, Position=0)] [string]$Action,
		[Parameter(Mandatory=$true, Position=1)] [object[]]$ExArgs
	)

	return & $Haxelib $Action @ExArgs
	return Write-Host "Called haxelib: $Action $($ExArgs)"
}

$gitInstalled = if (Get-Item -Path "$PSScriptRoot/$GitDummyFile" -ErrorAction SilentlyContinue) { ($Msg.yOption).ToLower() }
else { Read-Host ($Msg.GitInstalledPrompt -f $Msg.yOption, $Msg.nOption) }

$libs = @( # Insert more libs here!
	@{Lib = "hxp";				Dependencies = @();},
	@{Lib = "openfl";			Dependencies = @();},
	@{Lib = "lime";				Dependencies = @("lime-samples");},
	@{Lib = "flixel";			Dependencies = @();},
	@{Lib = "flixel-addons";	Dependencies = @();},
	@{Lib = "flixel-tools";		Dependencies = @();},
	@{Lib = "tjson";			Dependencies = @();}
)


if ($gitInstalled -eq ($Msg.yOption).ToLower()) {
	New-Item -ItemType File -Path "$PSScriptRoot/$GitDummyFile" -Value $Msg.DummyFile -Force | Out-Null # Make a file to indicate user has git, used in 'remove setup' option 

	$libs += @(
		@{Lib = "firetongue";		Dependencies = @()}
		@{Lib = "hxdiscord_rpc";	Dependencies = @("hxcpp")}
		@{Lib = "polymod";			Dependencies = @("jsonpatch", "jsonpath", "thx.core", "thx.semver")}
	)
}

function SetupWindows {
	$filename = "vs_BuildTools.exe"
	$url = "https://aka.ms/vs/16/release/{0}"
	try {
		Invoke-WebRequest -Uri ($url -f $filename) -OutFile $filename
		Write-Host ($Msg.InstallingMSVC.Prompt)
	} catch {
		Write-Warning ($Msg.InstallingMSVC.ErrorDownload -f $_)
		return
	}
	if (Test-Path $filename) {
		try {
			Start-Process -FilePath $filename -ArgumentList "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -passive --no-cache" -Wait -Verbose
			Remove-Item $filename
		} catch {}
	} else {
		Write-Warning ($Msg.InstallingMSVC.ErrorPath -f $filename)
		return
	}

	Write-Host ($Msg.Finished)
	Set-Pause
	Clear-Host
}

function SetupMacOS {
	Write-Host $Msg.NotAvailable -ForegroundColor Red
}

function SetupAndroid {
	Write-Host $Msg.NotAvailable -ForegroundColor Red
	<#
		Write-Host $Msg.InstallingDependencies.Android
		Get-Haxelib "install" @("extension-androidtools")
		Start-Sleep 1

		Get-Haxelib "run" @("lime", "setup", "android")
	#>
}

function Remove-GameSetup {
	Write-Host $Msg.RemoveSetup.InfoAndroid

	$xmlPath = Resolve-Path "$HOME/.lime/config.xml"
	[xml]$xml = Get-Content $xmlPath
	if ((Test-Path $xmlPath -ErrorAction SilentlyContinue) -and ($xml.SelectSingleNode("//define[@name='ANDROID_SETUP' and @value='true']"))) {
		Write-Host $ind[0] -NoNewline -ForegroundColor Blue
		$libs += @(
			@{Lib = "extension-androidtools"; Dependencies = @()}
		)
	} else { Write-Host $ind[1] -NoNewline -ForegroundColor Red - }
	start-sleep 2

	Write-Host $Msg.CheckinGit
	if (Get-Item -Path "$PSScriptRoot/$GitDummyFile" -ErrorAction SilentlyContinue) {
		Remove-Item -Path "$PSScriptRoot/$GitDummyFile"
	}

	Write-Host $Msg.RemoveSetup.Dependencies
	foreach ($i in $libs) {
		try { Get-Haxelib "remove" @($i.Lib) } catch {}

		foreach ($dep in $i.Dependencies) {
    		try { Get-Haxelib "remove" @($dep) } catch {}
	    }
	}
}


do {
	Write-Host ("===== {0} =====" -f $Msg.Menu.Title)
	foreach ($i in 0..($Msg["Menu"]["Options"].Count - 1)) {
		if ($i -eq 1 -or $i -eq 2) {
			Write-Host ("{0}. {1}" -f $i, $Msg.Menu.Options[$i]) -ForegroundColor Red
			continue
		} elseif ($i -eq 3) {
			Write-Host ("{0}. {1}" -f $i, $Msg.Menu.Options[$i]) -ForegroundColor Yellow
			continue
		} else { Write-Host ("{0}. {1}" -f $i, $Msg.Menu.Options[$i]) }
	}
	Write-Host ""

	$choice = Read-Host ($Msg.Menu.Prompt -f 0, ($Msg["Menu"]["Options"].Count - 1))

	switch (($choice).ToString().ToLower()) {
		'0' { if ($IsWindows) { SetupWindows }	else { Write-Host ($Msg.Menu.ErrorOS) } }
		'1' { if ($IsMacOS)   { SetupMacOS }	else { Write-Host ($Msg.Menu.ErrorOS) } }
		'2' { SetupAndroid }
		'3' { if (Get-Command "haxelib" -ErrorAction SilentlyContinue) {Remove-GameSetup} else { throw $Msg.NotHaxe } }
		'4' { exit }
		'exit' { exit }
		default { Write-Host ($Msg.Menu.Error) -ForegroundColor Red}
	}
} while ($StayOnMenu.ToLower() -in @("y","yes","true","1"))
