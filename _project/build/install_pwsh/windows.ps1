# Force the user to run on Windows PowerShell, not PowerShell Core
#requires -PSEdition Desktop -Version 4.0
Import-LocalizedData -BaseDirectory ".." -FileName "install_pwsh" -BindingVariable "Msg"

# Search for PSCore, if the user already has it installed
if (Get-Command "pwsh" -ErrorAction SilentlyContinue) {
	Write-Output $Msg['Err_PWSH_AlreadyInstalled']
	exit 0
}

# False, then attempt to install it
Write-Output $Msg['Installing_PWSH']

# Search for WinGet method
if (Get-Command "winget --version" -ErrorAction SilentlyContinue) {
	Write-Output $Msg["Install_FoundWinget"]
	Start-Process "winget" -ArgumentList "install", "--id", "Microsoft.PowerShell", "--source", "winget", "--installer-type", "wix" -Wait
	exit 0
}

# False, search for .NET Core
if (Get-Command "dotnet" -ErrorAction SilentlyContinue) {
	Write-Output $Msg["Install_FoundDotNET"]
	Start-Process "dotnet" -ArgumentList "tool", "install", "--global", "PowerShell" -Wait
	exit 0
}

# False again, install through MSI method
[version]$PSVER = Get-Content ".\version.txt" -Raw
[string]$ARCH = "x64"
[string]$FILE = "PowerShell-$PSVER-win-$ARCH.msi"
try {
	Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v$PSVER/$FILE.msi" -OutFile $FILE
	Start-Sleep 1

	if (Test-Path (Join-Path (Get-Location) $FILE) -PathType Leaf) {
		Start-Process "msiexec.exe" -ArgumentList "/package", $FILE -Wait
		exit 0
	}
}
catch {
	Write-Host ($Msg["Install_Failed"] -f $_)
	exit 1
}