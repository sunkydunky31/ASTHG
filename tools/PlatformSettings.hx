package tools;

typedef PlatformSettings = {
	android:AndroidSettings,
	windows:WindowsSettings
}

typedef AndroidSettings = {
	/** Icon settings for Android **/
	icons:AndroidSettings_Icons,

	/**
		Changes the game title to a translatable string (by now).
		Also, you can add more localized strings support
	**/
	localizedStrings:Bool
}

typedef AndroidSettings_Icons = {
	/**
		Adaptive icons (Android 8.0+) uses a foreground and background layer to create different shapes,
		adds support for monochrome icons on Android 12+ too, this depends on how you configured the XML files.
	**/
	adaptive:Bool,

	/**
		A circular version of the icon for devices that use round icons, if you are using Adaptive
		icons, is `optional`, but I recommend disabling this since you may don't need it.
	**/
	?hasRound:Bool
}

typedef WindowsSettings = {
	/**
		If enabled, this will use Windows 8+ VisualElements for stiling
		**WARNING**: This will only work if you pin the game on the Start menu
	**/
	visualElements:Bool
}