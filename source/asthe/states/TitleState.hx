/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-27
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package asthe.states;

import flixel.effects.FlxFlicker;

class TitleState extends StateManager {
	var pressStart:AstheBitmapText;

	override function create() {
		Paths.clearUnusedMemory();

		var bg:AstheSprite = new AstheSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var text = Locale.getString("press_start", "title_screen", [asthe.input.InputFormatter.getControlNames(asthe.input.InputList.ACCEPT)]);

		pressStart = AstheBitmapText.createAngelCode(0, FlxG.height - 20, text, "TitleFont");
		pressStart.screenCenter(X);
		add(pressStart);

		if (ClientPrefs.data.options.flashing)
			FlxFlicker.flicker(pressStart, 17, 0.12, true);

		AstheSound.playMusic('TitleScreen');

		super.create();
	}

	override function update(e:Float) {
		if (controls.ACCEPT)
			FlxG.switchState(() -> new asthe.states.MainMenu());

	}
}