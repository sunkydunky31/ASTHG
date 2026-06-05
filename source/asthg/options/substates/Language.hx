/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.options.substates;

import firetongue.FireTongue;
import openfl.utils.Assets;

//@:nullSafety()
class Language extends SubStateManager {
	#if (TRANSLATIONS_ALLOWED && target.unicode)
	/*                           ^^^^^^^^^^^^^^
		We need to be sure that Unicode are supported,
		or translations will be weird as hell
	*/
	var grpLanguages:FlxTypedGroup<AsthgText>;

	/**
		Current game's supported languages list
	**/
	var languages:Array<String> = new Array<String>();
	var curSelected:Int = 0;
	public function new() {
		super();

		var bg = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		grpLanguages = new FlxTypedGroup<AsthgText>();
		add(grpLanguages);

		languages = Locale.tongue.locales;
		try {
			if (!ArrayUtil.isBlank(languages)) {
				for (num => str in languages) {
					var text:AsthgText = AsthgText.create(0, 30, Locale.tongue.getIndexString(LanguageRegionNative, languages[num]));
					text.fieldWidth = FlxG.width;
					text.format(16, AsthgText.TextAlign.CENTER, FlxColor.WHITE);
					text.ID = num;
					text.y += (20 * (num - (languages?.length / 2))) + text?.size;
					grpLanguages.add(text);
				}
			}
			else throw "Languages data is null/empty!";
		}
		catch(e:Dynamic) {
			trace("Error when loading language data: {0}", e);
		}

		changeSelection();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		var scroll = FlxG.mouse.wheel;
		if (controls.UP || controls.DOWN || scroll != 0) {
			changeSelection(((controls.UP ? -1 : 1) * mult) - scroll);
			AsthgSound.playSound(ConstantSound.MENU_SCROLL);
		}

		if (controls.BACK) {
			close();
			AsthgSound.playSound(ConstantSound.MENU_BACK);
		}

		if(controls.ACCEPT) {
			AsthgSound.playSound(ConstantSound.MENU_ACCEPT);
			ClientPrefs.data.options.language = (languages[curSelected] ?? Constants.LANGUAGE_DEFAULT);
			ClientPrefs.saveSettings();
			Locale.init();
		}
	}

	function changeSelection(change:Int = 0) {
		if (ArrayUtil.isBlank(languages) || ArrayUtil.isBlank(grpLanguages.members))
			return;

		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length-1);

		for (num => lang in grpLanguages)
			lang.alpha = (num == curSelected) ? 1 : 0.5;

	}
	#end
}