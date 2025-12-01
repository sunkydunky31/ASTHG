package options.substates;

class System {
	public function new() {
		var opt:Option;

		opt = new Option("cache on gpu", "cacheOnGPU");
		addOption(opt);

		#if DISCORD_ALLOWED
		opt = new Option("discord_rich_presence", "discordRPC");
		addOption(opt);
		#end

		opt = new Option("haptics", "haptics");
		addOption(opt);
	}
}