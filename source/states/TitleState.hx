package states;

import flixel.effects.FlxFlicker;

class TitleState extends StateManager {
	var pressStart:FlxBitmapText;

	override function create() {
		Paths.clearUnusedMemory();

		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

        if (FlxG.gamepads.numActiveGamepads > 0) {
            Controls.instance.controllerMode = true;
        }

		pressStart = new FlxBitmapText(0, FlxG.height - 20, Locale.getString("press_start", "title_screen", [backend.InputFormatter.getControlNames('accept')]), Paths.getAngelCodeFont("HUD"));
		pressStart.screenCenter(X);
		add(pressStart);

		if (!ClientPrefs.data.flashing)
			FlxFlicker.flicker(pressStart, 17, 0.12, true);

		CoolUtil.playMusic('TitleScreen', {sample: 0});

		super.create();
	}

	override function update(e:Float) {
		if (controls.justPressed('accept'))
			StateManager.switchState(new states.MainMenu());

	}
}