#requires -PSEdition Desktop

# Search for PSCore, if the user already has it installed
if (Get-Command "pwsh" -ErrorAction SilentlyContinue) {
	Write-Output "You already have PowerShell Core installed!"
	exit 0
}

# False, then attempt to install it
Write-Output "Installing PowerShell Core"

# Search for WinGet method
if (Get-Command "winget --version" -ErrorAction SilentlyContinue) {
	Write-Output "Found Windows Package Manager! Installing through it"
	Start-Process "winget" -ArgumentList "install", "--id", "Microsoft.PowerShell", "--source", "winget", "--installer-type", "wix" -Wait
	exit 0
}

# False, search for .NET Core
if (Get-Command "dotnet" -ErrorAction SilentlyContinue) {
	Write-Output "Found .NET Core! Installing through it"
	Start-Process "dotnet" -ArgumentList "tool", "install", "--global", "PowerShell" -Wait
	exit 0
}

# False again, install through MSI method
[version]$PSVER = "7.6.2"
[string]$ARCH = "x64"
[string]$FILEOUT = "PowerShell-$PSVER-win-$ARCH.msi"
try {
	Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v$PSVER/PowerShell-$PSVER-win-$ARCH.msi" -OutFile $FILEOUT
	Start-Sleep 1
}
catch {
	Write-Host "Failed when installing PowerShell Core: $_"
	exit 1
}

if (Test-Path "$(Get-Location)/$FILEOUT" -PathType Leaf) {
	Start-Process "msiexec.exe" -ArgumentList "/package", $FILEOUT -Wait
	exit 0
}
