@{

	#General
	Done           = 'Done.'
	Finished       = 'Finished.'
	PausePrompt    = 'Press any key to continue. . .' # Command prompt style message

	Options        = @{
		Yes = 'y' # 'Yes' option.
		No  = 'n' # 'No' option.
	}

	Dependencies   = @{
		InstallingDependencies = @{
			Default = 'Installing dependencies.'
			SubText = 'This might take a few moments depending on your internet speed.'
		}

		RemoveSetup            = @{
			Dependencies = 'Removing dependencies...'
			FailedRemove = 'Failed on cleaning dependencies: {0}'
		}

		Redundant              = @{
			RemoveWarn          = 'Removing redundant dependencies...'
			FolderNotFound      = 'The dependencies folder was not found, did you complete the initial setup?'

			VersionRemoved      = "Version '{0}' removed from '{1}'!"
			VersionRemoveFailed = "Failed to remove version '{0}' from '{1}': {2}"
		}
	}

	Haxe           = @{
		NotFound = "Haxelib was not found!`nIs '%HAXEPATH%' and '%NEKO_INSTPATH%' registered on your PATH?"
		GetPath  = 'Please, insert the location of your HaxeToolkit folder path.'
	}

	HXCPP          = @{
		Building    = 'Building HXCPP Dev'
		FailedBuild = 'Failed when building HXCPP: {0}'
	}

	InstallingMSVC = @{
		Prompt        = 'Installing Microsoft Visual Studio BuildTools (Dependency)'
		ErrorDownload = 'The download of VS BuildTools has failed: {0}'
		ErrorPath     = "'{0}' was not found. Returning..."
	}

	Menu           = @{
		Title        = 'ASTHE Setup'
		Options      = @(
			'Install default dependencies',
			'Setup for Windows',
			'Setup for MacOS',
			'Setup for Android',
			'Remove setup files',
			'Remove full setup files',
			'Remove redundant dependencies',
			'Exit'
		)
		Prompt       = 'Choose an option ({0}/{1})'
		Error        = 'Invalid option, please try again.'
		ErrorOS      = 'This option is not available for your system.'
		NotAvailable = 'This option is disabled because HaxeLib was not found.'
	}

	NotAvailable   = 'Sorry, this option is not available for now.'

	Config         = @{
		FailedSave = 'Failed to save config: {0}'
	}
}