package states.editors;

import flixel.effects.FlxFlicker;

class MainMenuEdt extends MusicBeatState {
	public static var curSelected:Int = 0;

	var options:Array<String> = [
		"Character Editor",
		"Language Editor" // just testing :p
	];

	var grpOptions:FlxTypedGroup<FlxText>;

	override public function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_editor_mode-edt', 'Edit Mode'));
		#end

		var bg = CoolUtil.makeBGGradient([0xFF303030, 0xFF505050], 2, 0, false);
		add(bg);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (num => str in options) {
			var text:FlxText = new FlxText(0, FlxG.height / 2, FlxG.width, Language.getPhrase("editormenu_" + str, str), 16);
			text.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, CENTER);
			text.y += (20 * num);
			text.ID = num;
			grpOptions.add(text);
		}

		changeItem();
	}

	var hasSelected:Bool = false;
	override function update(e:Float) {
		if (!hasSelected) {
			if (controls.justPressed('up')) {
				changeItem(-1);
				CoolUtil.playSound("Menu Change", true);
			}
			if (controls.justPressed('down')) {
				changeItem(1);
				CoolUtil.playSound("Menu Change", true);
			}
			if (controls.justPressed("accept")) {
				CoolUtil.playSound("Menu Accept", true);
				hasSelected = true;

				grpOptions.forEach(function(txt:FlxText) {
					if (curSelected != txt.ID) {
						FlxTween.tween(txt, {alpha: 0}, 0.6, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween) {
								txt.kill();
							}
						});
					}
					else {
						FlxFlicker.flicker(txt, 1, 0.06, false, false, function(flick:FlxFlicker) {
							var daChoice:String = options[curSelected];
									trace("Selected " + txt.text);

							switch (daChoice.toLowerCase()) {
								case 'character editor':
									LoadingState.switchStates(new CharacterEdt());
							}
						});
					}
				});
			}
		}
		super.update(e);
	}

	
	function changeItem(change:Int = 0) {
		curSelected += change;

		if (curSelected >= grpOptions.length) curSelected = 0;
		if (curSelected < 0) curSelected = grpOptions.length - 1;
	}
}