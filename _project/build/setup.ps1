#requires -Version 6.0

<#
	.SYNOPSIS
	Tool used for compiling An Sonic the Hedgehog Engine
	.PARAMETER StayOnMenu
	If true, the script does not closes when it completes an action.
	Options: y, yes, true, 1
	.PARAMETER MenuOption
	If set, automatically starts an option from the menu without choosing

	Options: 0 to 5
	.EXAMPLE
	& setup.ps1 -MenuOption 0
	.EXAMPLE
	& setup.ps1 -StayOnMenu yes
	.EXAMPLE
	& setup.ps1 -StayOnMenu yes -MenuOption 3
	.NOTES
	Author: Sunnydev31 (@unreal.sunnydev)
	Latest edition: 2026-06-27
#>

param(
	[string]$StayOnMenu = '',
	[int]$MenuOption = -1,
	[bool]$Transcript = $true
)

Import-LocalizedData -BindingVariable 'Msg' -ErrorAction SilentlyContinue
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'util.ps1')

# Change the title of the windows
$Host.UI.RawUI.WindowTitle = $Msg['Menu'].Title

if ($Transcript) {
	Start-Transcript -Path (Write-Path $PSScriptRoot, 'setup.log')
}

$ProjectPath = (Write-Path -Path $PSScriptRoot, '..', '..' -Resolve)


Set-Location $ProjectPath

function Write-Message {
	param(
		[Parameter(Mandatory = $true, Position = 0)] [string]$Message,
		[Parameter(Position = 1)]                    [ConsoleColor]$Color = [ConsoleColor]::White
	)

	if (-not $Transcript) {
		Write-Host $Message -ForegroundColor $Color
	}
	else {
		Write-Output $Message
	}
}

# MAIN FUNCTION to call haxelib
$Haxelib = (Get-Command 'haxelib' -ErrorAction SilentlyContinue)
[bool]$HasHaxelib = $false
if ($null -ne $haxelib) {
	$HasHaxelib = $true
}
else {
	Write-Message ($Msg['Haxe'].NotFound) -Color Red
}

# Path to persist setup options
$ConfigPath = Write-Path -Path $PSScriptRoot, 'setup_config.json'
$obj = @{ }

<#
	.DESCRIPTION
	Function to get a setup configuration

	.PARAMETER Name
	The name of the setting to get

	.OUTPUTS
	Object
#>
function Get-SetupConfig {
	param([Parameter(Mandatory = $true)] [object]$Name)

	try {
		if (Test-Path $ConfigPath) {
			$obj = Get-Content $ConfigPath -Raw | ConvertFrom-Json -ErrorAction Stop
			return $obj[$Name]
		}
	}
	catch {}
}

<#
	.DESCRIPTION
	Function to save a setup configuration

	.PARAMETER Name
	The name of the setting to save
	.PARAMETER Value
	The value of this setting

	.OUTPUTS
	Void
#>
function Set-SetupConfig {
	param(
		[Parameter(Mandatory = $true, Position = 0)] [object]$Name,
		[Parameter(Mandatory = $true, Position = 1)] [object]$Value
	)

	$obj += @{ $Name = $Value }
	try {
		$obj | ConvertTo-Json | Set-Content -Path $ConfigPath -Encoding UTF8
	}
	catch {
		Write-Warning ($Msg['Config'].FailedSave -f $_)
	}
}


<#
	.DESCRIPTION
	Function to start a Windows setup

	.OUTPUTS
	Void
#>
function Set-SetupWindows {
	$filename = 'vs_BuildTools.exe'

	try {
		Invoke-WebRequest -Uri ('https://aka.ms/vs/16/release/{0}' -f $filename) -OutFile $filename
		Write-Message ($Msg['InstallingMSVC'].Prompt)
	}
	catch {
		Write-Warning ($Msg['InstallingMSVC'].ErrorDownload -f $_)
		return
	}

	try {
		if (Test-Path $filename) {
			Start-Process -FilePath $filename -ArgumentList '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', '--add', 'Microsoft.VisualStudio.Component.Windows10SDK.19041', '--passive', '--nocache', '--downloadThenInstall' -Wait
			Remove-Item $filename
		}
	}
	catch {
		Write-Message ($Msg['InstallingMSVC'].ErrorPath -f $filename) -Color Red
		Stop-Transcript
	}

	Write-Message ($Msg['Finished'])
	Set-SetupConfig -Name SetupWindows -Value $true
	Set-Pause
	Clear-Host
}

<#
	.DESCRIPTION
	Function to start a Machintosh OS setup

	.NOTES
	This function are disabled by now

	.OUTPUTS
	Custom Exception
#>
function Set-SetupMacOS {
	Write-Message ($Msg['NotAvailable'])
}

<#
	.DESCRIPTION
	Function to start a Windows setup

	.NOTES
	This function only run `haxelib --never run lime setup android`
	And saves a config entry for this.
#>
function Set-SetupAndroid {
	& $Haxelib @('--never', 'run', 'lime', 'setup', 'android')
	Set-SetupConfig -Name SetupAndroid -Value $true
}

$CompiledHXCPP = (Get-SetupConfig -Name CompiledHXCPP)
if ($null -eq $CompiledHXCPP) {
	$CompiledHXCPP = $false
}

<#
	.DESCRIPTION
	Function to start a game setup
	Install dependencies and configure lime
#>
function New-GameSetup {
	Write-Message ($Msg['Dependencies'].InstallingDependencies.Default)
	Write-Message ($Msg['Dependencies'].InstallingDependencies.SubText)
	Set-Pause

	& $Haxelib @('--global', 'install', 'hmm')
	Start-Sleep 2

	Set-Location $ProjectPath
	& $Haxelib @('--global', 'run', 'hmm', 'setup')
	Start-Sleep 2

	& 'hmm' 'install'
	Set-SetupConfig -Name SetupDone -Value $true

	Start-Sleep 2
	& $Haxelib @('run', 'lime', 'setup')
	Set-Pause

	Remove-RedundantHaxelibs

	Write-Message $Msg['HXCPP'].Building Red

	try {
		if (-not $CompiledHXCPP) {
			Set-Location (Write-Path $ProjectPath, '.haxelib', 'hxcpp', 'git', 'tools', 'hxcpp')
			& 'haxe' 'compile.hxml'
			Start-Sleep 2

			Set-Location $ProjectPath
			Set-SetupConfig -Name CompiledHXCPP -Value $true
		}
 	}
	catch { $Msg['HXCPP'].FailedBuild }

	Write-Message ($Msg['Finished'])

	if ($StayOnMenu) {
		Set-Location $PSScriptRoot
	}
}

<#
	.DESCRIPTION
	Function to remove setup of the game
#>
function Remove-GameSetup {
	Write-Message $Msg['Dependencies'].RemoveSetup.Removing

	<#
		Search in config if setup has done or if ".haxelib" exists
		If true, remove ALL dependencies
	#>
	if (((Get-SetupConfig -Name SetupDone) -eq $true) -or (Test-Path (Write-Path $ProjectPath, '.haxelib'))) {
		try {
			& 'hmm' 'clean'
		}
		catch {
			Write-Message ($Msg['Dependencies'].RemoveSetup.FailedRemove -f $_) -Color Red
			if ($Transcript) {
				Stop-Transcript
			}
		}
	}

	if (Test-Path $ConfigPath) {
		Remove-Item $ConfigPath -Force
	}

	Write-Message $Msg['Finished']
}

<#
	.DESCRIPTION
	Function to remove redundant haxelibs
	Removes all versions of a library except the one marked as ".current"

	.OUTPUTS
	Void

	.NOTES
	This function only works if you're using Haxelib portable mode (".haxelib" folder)
#>
function Remove-RedundantHaxelibs {
	if ($HasHaxelib) {
		Write-Message ($Msg['Dependencies'].Redundant.RemoveWarn)

		$libPath = Write-Path $ProjectPath, '.haxelib'
		if (-not (Test-Path $libPath)) {
			Write-Message ($Msg['Dependencies'].Redundant.FolderNotFound)
			return
		}

		# For each lib...
		Get-ChildItem $libPath | Where-Object { ($_).PSIsContainer } | ForEach-Object {
			$libName = ($_).Name
			$libDir = ($_).FullName
			$currentFile = Write-Path $libDir, '.current'
			if (Test-Path $currentFile) {
				$currentVersion = (Get-Content $currentFile -Raw).Replace('.', ',')
				Get-ChildItem $libDir | Where-Object { ($_).PSIsContainer -and (($_).Name -ne $currentVersion) } | ForEach-Object {
					try {
						Remove-Item -Recurse -Force ($_).FullName
						Write-Message ($Msg['Dependencies'].Redundant.VersionRemoved -f ($_).Name, $libName)
					}
					catch {
						Write-Message ($Msg['Dependencies'].Redundant.VersionRemoveFailed -f ($_).Name, $libName, $_) -Color Yellow
					}
				}
			}
		}
		Start-Sleep 1

		Write-Message $Msg['Done']
	}
	else {
		Write-Message ($Msg['RemoveFullSetup'].AbortedWithReason -f $Msg['RemoveFullSetup'].ErrorReasons.NotHaxelib) -Color Red
		return
	}
}

function Remove-FullSetup {
	$Confirm = Read-Host ($Msg['RemoveFullSetup'].Confirm -f $Msg['Options'].Yes, $Msg['Options'].No)
	if ($Confirm.ToLower() -ne $Msg['Options'].Yes) {
		Write-Message ($Msg['RemoveFullSetup'].Aborted)
		return
	}

	Remove-GameSetup

	# This function also remove game builds!
	if (Get-SetupConfig -Name SetupWindows) {
		Write-Message ($Msg['RemoveFullSetup'].PlatformWarn.Windows)
		& $haxelib @('run', 'lime', 'clean', 'windows')
	}

	if (Get-SetupConfig -Name SetupAndroid) {
		Write-Message ($Msg['RemoveFullSetup'].PlatformWarn.Android)
		& $haxelib @('run', 'lime', 'clean', 'android')
	}
}

do {
	[int]$NUM_OPTIONS = 7

	Write-Message ('===== {0} =====' -f $Msg['Menu'].Title)
	for ($i = 0; $i -lt ($NUM_OPTIONS + 1); $i++) {
		$text = $Msg['Menu'].Options[$i]
		if (($i -in ('0', '4', '5', '6')) -and (-not $HasHaxelib)) {
			$text = $Msg['Menu'].NotAvailable
		}

		Write-Message ('{0}. {1}' -f ($i), $text)
		continue
	}
	Write-Message "`n"

	if ($null -ne $MenuOption -and $MenuOption -ne -1) {
		$MenuOptionNow = $MenuOption
	}
	else {
		$MenuOptionNow = Read-Host ($Msg['Menu'].Prompt -f 0, $NUM_OPTIONS)
	}

	switch ($MenuOptionNow) {
		'0' {
			if ($HasHaxelib) { New-GameSetup }
		}
		'1' {
			if ($IsWindows) { Set-SetupWindows }
			else { Write-Message ($Msg['Menu'].ErrorOS) Red }
		}
		'2' {
			if ($IsMacOS) { Set-SetupMacOS }
			else { Write-Message ($Msg['Menu'].ErrorOS) Red }
		}
		'3' {
			Set-SetupAndroid
		}
		'4' {
			if ($HasHaxelib) { Remove-GameSetup }
		}
		'5' {
			if ($HasHaxelib) { Remove-FullSetup }
		}
		'6' {
			if ($HasHaxelib) { Remove-RedundantHaxelibs }
		}
		'7' {
			Stop-Transcript
			exit
		}
		default {
			Write-Message ($Msg['Menu'].Error) Red
		}
	}

} while ($StayOnMenu.ToLower() -in @($Msg['Options'].Yes, 'true', '1') -or $MenuOption -eq -1)
Stop-Transcript
