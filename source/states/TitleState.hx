package states;

import flixel.effects.FlxFlicker;

class TitleState extends MusicBeatState {
	var pressStart:FlxBitmapText;

	override function create() {
		Paths.clearUnusedMemory();

		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFFF00000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

        if (FlxG.gamepads.numActiveGamepads > 0) {
            Controls.instance.controllerMode = true;
        }

		pressStart = new FlxBitmapText(0, FlxG.height - 20, Language.getPhrase("titlescreen_press_start", "Press {1}", [backend.InputFormatter.getControlNames('accept')]));
		pressStart.screenCenter(X);
		add(pressStart);

		CoolUtil.playMusic('TitleScreen', {sample: 0});

		super.create();
	}

	override function update(e:Float) {
		if (controls.justPressed('accept'))
			MusicBeatState.switchState(new PlayState());

		FlxFlicker.flicker(pressStart, 17, 0.08, true);
	}
}