@{
	Title         = 'ASTHE Build'
	PausePrompt   = 'Press any key to continue. . .' # Command prompt style message
	BuildTexts    = @{
		'build' = 'Building...'
		'test'  = 'Testing...'
		'run'   = 'Running... (from who?)'
		'clean' = 'Cleaning...'
	}
	Finished      = 'Finished.'

	InsertHaxelib = @(
		'Looks like your PATH was corrupted, Haxe isn''t installed, or Haxe was not found on the defined PATH.',
		'If your Haxe is not installed, please, install it in "https://haxe.org/download/"',
		'If your PATH is corrupted, change the variables ''HAXEPATH'' and ''NEKO_INSTPATH'' from PATH by their absolute path, additionaly, Remove all binaries from Haxe and Neko folders replacing them with a ZIP version',
		'Insert you HaxeToolkit folder path where haxelib is located, without ''haxelib'' at the end',
		'NOTE: If you''re using Haxe in Portable Mode on a USB Drive, please, remove and re-insert your drive, then run this script again'
	)

	Config        = @{
		'Platform'   = 'Platform: .. {0}'
		'BuildFlags' = 'Build Flags: {0}'
		'Is32Bits'   = '32 Bits: ... {0}'
		'Action'     = 'Action: .... {0}'
		'BuildType'  = 'Build Type:  {0}'
	}

	Cleaning      = 'Cleaning old build files...'
	CleaningError = 'Failed when cleaning: {0}'
}