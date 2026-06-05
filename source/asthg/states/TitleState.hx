package asthg.states;

import flixel.effects.FlxFlicker;

class TitleState extends StateManager {
	var pressStart:AsthgBitmapText;

	override function create() {
		Paths.clearUnusedMemory();

		var bg:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var text = Locale.getString("press_start", "title_screen", [asthg.input.InputFormatter.getControlNames(asthg.input.InputList.ACCEPT)]);

		trace("TitleState.text: {0}", text);

		pressStart = AsthgBitmapText.createAngelCode(0, FlxG.height - 20, text, "TitleFont");
		pressStart.screenCenter(X);
		add(pressStart);

		if (!ClientPrefs.data.options.flashing)
			FlxFlicker.flicker(pressStart, 17, 0.12, true);

		AsthgSound.playMusic('TitleScreen');

		super.create();
	}

	override function update(e:Float) {
		if (controls.ACCEPT)
			StateManager.switchState(new asthg.states.MainMenu());

	}
}