package options.substates;

import openfl.utils.Assets;

class Language extends SubStateManager {
	#if TRANSLATIONS_ALLOWED
	var grpLanguages:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	var languages:Array<String> = [];
	var curSelected:Int = 0;
	public function new() {
		super();

		var bg = new FlxSprite().makeGraphic(1, 1, 0x50000000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.screenCenter();
		add(bg);
		add(grpLanguages);

		languages = Main.tongue.locales;
		for (num => str in languages) {
			// LanguageRegionNative breaks and I don't know why
			var text:FlxText = new FlxText(0, 300, 0, Main.tongue.getIndexString(LanguageNative, languages[num]) + " (" + Main.tongue.getIndexString(RegionNative, languages[num]) + ")");
			text.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, CENTER);
			text.ID = num;
			if (languages.length < 7) {
				text.screenCenter(Y);
				text.y += (20 * (num - (languages.length / 2))) + text.size;
			}
			text.screenCenter(X);
			grpLanguages.add(text);
		}

		curSelected = languages.indexOf(ClientPrefs.data.language);
		if(curSelected < 0) {
			ClientPrefs.data.language = ClientPrefs.defaultData.language;
			curSelected = Std.int(Math.max(0, languages.indexOf(ClientPrefs.data.language)));
		}
		changeSelected();
	}

	var changedLanguage:Bool = false;
	override function update(elapsed:Float) {
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		if(controls.justPressed('up')) changeSelected(-1 * mult);
		if(controls.justPressed('down')) changeSelected(1 * mult);
		if(FlxG.mouse.wheel != 0) changeSelected(FlxG.mouse.wheel * mult);

		if(controls.justPressed('back')) {
			if(changedLanguage) {
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				StateManager.resetState();
			}
			else close();
			CoolUtil.playSound('MenuCancel');
		}

		if(controls.justPressed('accept')) {
			CoolUtil.playSound('MenuAccept');
			ClientPrefs.data.language = languages[curSelected];
			ClientPrefs.saveSettings();
			Main.tongue.initialize({locale: ClientPrefs.data.language});
			changedLanguage = true;
		}
	}

	function changeSelected(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length-1);
		for (num => lang in grpLanguages) {
			lang.alpha = 0.6;
			if(num == curSelected) lang.alpha = 1;
		}
		CoolUtil.playSound('MenuChange');
	}
	#end
}