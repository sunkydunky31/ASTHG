package asthe.states;

import flixel.effects.FlxFlicker;

class TitleState extends StateManager {
	var pressStart:ASTHEBitmapText;

	override function create() {
		Paths.clearUnusedMemory();

		var bg:ASTHESprite = new ASTHESprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var text = Locale.getString("press_start", "title_screen", [asthe.input.InputFormatter.getControlNames(asthe.input.InputList.ACCEPT)]);

		trace("TitleState.text: {0}", text);

		pressStart = ASTHEBitmapText.createAngelCode(0, FlxG.height - 20, text, "TitleFont");
		pressStart.screenCenter(X);
		add(pressStart);

		if (!ClientPrefs.data.options.flashing)
			FlxFlicker.flicker(pressStart, 17, 0.12, true);

		ASTHESound.playMusic('TitleScreen');

		super.create();
	}

	override function update(e:Float) {
		if (controls.ACCEPT)
			FlxG.switchState(() -> new asthe.states.MainMenu());

	}
}