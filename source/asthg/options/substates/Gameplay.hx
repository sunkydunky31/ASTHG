/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.options.substates;

class Gameplay extends OptionsSubState {
	public function new() {
		title = Locale.getString("title_gameplay", "options");

		var option:Option;

		option = new Option("auto_pause", "autoPause");
		addOption(option);

		option = new Option("flashing_lights", "flashing");
		addOption(option);

		option = new Option("hide_hud", "hideHud");
		addOption(option);

		option = new Option("show_miliseconds", "showMiliseconds");
		addOption(option);
		super();
	}
}