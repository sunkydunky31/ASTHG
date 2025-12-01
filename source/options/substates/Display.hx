package options.substates;

class Display {
	public function new() {
		var option:Option;

		option = new Option("background_layers", "backLayers", FLOAT, {min:0.0, max:1.0, amount:0.1, display:"%v"});
		addOption(option);

		option = new Option("show_fps", "showFPS");
		addOption(option);

		#if cpp
		option = new Option("framerate", "framerate", INT, {min:60, max:240, amount:1, display:"%v FPS"});
		addOption(option);
		#end

		option = new Option("low_quality", "lowQuality");
		addOption(option);
	}
}
