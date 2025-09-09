package options;

class SystemSubState extends BaseOptionsMenu {
	public function new() {

		var option:Option = new Option("Cache on GPU", "", "cacheOnGPU", BOOL);
		addOption(option);

		var option:Option = new Option("Check for Updates", "", "checkForUpdates", BOOL);
		addOption(option);

		var option:Option = new Option("Discord Rich Presence", "", "discordRPC", BOOL);
		addOption(option);

		#if HAPTICS_ALLOWED
		var option:Option = new Option("Haptics", "Make your device vibrate depending of the content on the screen", "haptics", BOOL);
		addOption(option);
		#end
		
		super();
	}
}