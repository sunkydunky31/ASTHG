<#
	.DESCRIPTION
	Utilitary script that helps when scripting in PowerShell
	Core or Desktop
#>

<#
	.DESCRIPTION
	Function that returns a joined path supporting either PowerShell Desktop
	and Core editions.
	.PARAMETER Path
	The starting or more paths to search about
	.PARAMETER Resolve
	Returns a resolved path instead
	.EXAMPLE
	Write-Path -Path $HOME, "Images", "cutiecat.jpg"
	->> C:\Users\YourUsername\Images\cutiecat.jpg (Windows)
	->> local/usr/bin/Images/cutiecat.jpg (Linux)
	.EXAMPLE
	Write-Path -Path "$HOME", "..", ".." -Resolve
	->> C:\ (Windows)
	->> local/ (Linux)
	.OUTPUTS
	$Path -split '/' -split '\\' -join "$([System.IO.Path]::DirectorySeparatorChar)"
	(Resolve?) Resolve-Path "$Path"
#>
function Write-Path {
	param(
		[Parameter(Mandatory=$true, Position=0)]
		[object[]]$Path,

		[switch]$Resolve
	)

	$PathSeparator = [System.IO.Path]::DirectorySeparatorChar

	$Path = ($Path -split '/' -split '\\' -join "$PathSeparator")
	if ($Resolve) { $Path = Resolve-Path "$Path" }

	return $Path
}

<#
	.DESCRIPTION
	Function to simulate the "pause" command on Command Prompt on Windows.
	.NOTES
	This function calls "Command Prompt" if you're using Windows.
#>
function Set-Pause {
	if ($IsWindows) {
		Start-Process cmd -ArgumentList "/c", "pause" -NoNewWindow -Wait
	}
	else {
		Write-Host ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
	}
}