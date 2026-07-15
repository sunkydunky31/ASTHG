/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthe.options;

import flixel.addons.display.FlxSliceSprite;
import flixel.math.FlxRect;

class OptionsState extends StateManager {
	var options:Array<String> = [
		"System",
		"Display",
		"Gameplay",
		"Controls"
		#if TRANSLATIONS_ALLOWED , "Language" #end
	];
	private var curSelected:Int = 0;
	private var grpTabs:Null<FlxTypedGroup<ASTHEBitmapText>> = null;

	public static var onPlayState:Bool = false;

	override function create() {
		var bg:ASTHESprite = ASTHESprite.create(0, 0, "menus/options/bg");
		add(bg);

		// tabs group
		grpTabs = new FlxTypedGroup<ASTHEBitmapText>();
		add(grpTabs);

		for (num => str in options) {
			var txt:ASTHEBitmapText = ASTHEBitmapText.createAngelCode(0, 0, Locale.getString("title_" + str.toSnakeCase(), "options"));
			txt.screenCenter();
			txt.y += (20 * (num - (options.length / 2)));
			txt.ID = num;
			txt.screenCenter(X);
			grpTabs.add(txt);
		}

		super.create();
		changeSelection();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		var scroll = FlxG.mouse.wheel;
		if (controls.UP || controls.DOWN || scroll != 0) {
			changeSelection(((controls.UP ? -1 : 1) * mult) - -scroll);
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}

		if (controls.BACK) {
			ClientPrefs.saveSettings();
			ASTHESound.playSound(ConstantSound.MENU_BACK);
			FlxG.switchState(() -> new asthe.states.MainMenu());
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

		if (change != 0)
			ASTHESound.playSound(ConstantSound.MENU_SCROLL);

		if (grpTabs != null) {
			grpTabs.forEach(function(txt:ASTHEBitmapText) {
				txt.color = (txt.ID == curSelected) ? (ClientPrefs.data.options.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.YELLOW) : FlxColor.WHITE;
			});
		}
	}

	function openSelectedSubstate(lbl:String) {
		ASTHESound.playSound(ConstantSound.MENU_ACCEPT);

		switch (lbl.toLowerCase()) {
			case "system": openSubState(new asthe.options.substates.System());
			case "display": openSubState(new asthe.options.substates.Display());
			case "gameplay": openSubState(new asthe.options.substates.Gameplay());
			case "controls": openSubState(new asthe.options.substates.Controls());
			case "language": openSubState(new asthe.options.substates.Language());
			default: trace("Unknown option: '{0}'".error(), lbl); return;
		}
	}
}