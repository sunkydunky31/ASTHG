/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.options.substates;

class Display extends OptionsSubState {
	public function new() {
		var option:Option;
		title = Locale.getString("title_display", "options");

		option = new Option("background_layers", "backLayers", NUMBER, {
			min: 0.0, max: 1.0, amount: 0.1, percentageMode: true
		});
		addOption(option);

		/*#if cpp
		option = new Option("show_fps", "showFPS");
		addOption(option);

		option = new Option("framerate", "framerate", NUMBER, {
			min: 30.0, max: 240.0, amount: 1.0, display: "{0} FPS"
		});
		addOption(option);
		#end */
		super();
	}
}
