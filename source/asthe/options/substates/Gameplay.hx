/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthe.options.substates;

class Gameplay extends OptionsSubState {
	public function new() {
		title = Locale.getString("title_gameplay", "options");

		addOption(new BoolOption("auto_pause", "autoPause"));
		addOption(new BoolOption("flashing_lights", "flashing"));
		addOption(new BoolOption("hide_hud", "hideHud"));
		addOption(new BoolOption("show_miliseconds", "showMiliseconds"));
		super();
	}
}