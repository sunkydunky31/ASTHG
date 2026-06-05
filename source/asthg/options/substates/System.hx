/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.options.substates;

class System extends OptionsSubState {
	public function new() {
		var opt:Option;
		title = Locale.getString("title_system", "options");

		opt = new Option("cache_on_gpu", "cacheOnGPU");
		addOption(opt);

		#if DISCORD_ALLOWED
		opt = new Option("discord_rich_presence", "discordRPC");
		addOption(opt);
		#end

		opt = new Option("haptics", "haptics");
		addOption(opt);

		opt = new Option("accent_colors", "accentColors");
		addOption(opt);

		#if shaders_supported
		opt = new Option("shaders", "shaders");
		addOption(opt);
		#end

		opt = new Option("low_quality", "lowQuality");
		addOption(opt);

		opt = new Option("music_volume", "musicVolume", NUMBER, {
			min: 0.0, max: 1.0, amount: 0.1, percentageMode: true, display: "{0}%"
		});
		addOption(opt);

		opt = new Option("sfx_volume", "sfxVolume", NUMBER, {
			min: 0.0, max: 1.0, amount: 0.1, percentageMode: true, display: "{0}%"
		});
		addOption(opt);

		super();
	}
}