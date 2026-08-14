/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthe.options.substates;

class Display extends OptionsSubState {
	public function new() {
		title = Locale.getString("title_display", "options");

		addOption(new NumberOption("background_layers", "backLayers", 0.0, 0.0, 1.0, 0.1, true));

		/*#if cpp
		addOption(new BoolOption("show_fps", "showFPS"));

		option = new NumberOption("framerate", "framerate", 60, 30.0, 240.0, 1.0);
		addOption(option);
		#end */
		super();
	}
}
