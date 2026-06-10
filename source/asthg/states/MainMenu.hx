package asthg.states;

import asthg.backend.StateManager;
import asthg.options.OptionsState;

import flixel.addons.plugin.FlxScrollingText;
import flixel.group.FlxGroup;
import flixel.effects.FlxFlicker;
import flixel.input.mouse.FlxMouse;

class MainMenu extends StateManager {
	public static var curSelected:Int = 0;

	var group:FlxTypedGroup<AsthgBitmapText>;

	var options:Array<String> = [
		"Save Select",
		"Options",
		#if MODS_ALLOWED "Mods", #end
		"Exit"
	];

	override function create() {
		Paths.clearStoredMemory();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence({details: Locale.getString('main_menu', 'discord')});
		#end

		var bg:flixel.FlxSprite = AsthgSprite.createGradient(FlxG.width, FlxG.height, [0xFF793BFF, 0xFF95EDFF], 4, 32, false);
		add(bg);

		var bgLayer:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgLayer.alpha = ClientPrefs.data.options.backLayers;
		add(bgLayer);

		var backd:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backd.y = 15;
		backd.flipY = true;

		backd.color = (ClientPrefs.data.options.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.YELLOW);
		backd.dirty = true;
		backd.velocity.set(-30, 0);
		add(backd);

		var backdFill:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, Math.floor(backd.y), backd.color);
		add(backdFill);

		var titleTxt:AsthgBitmapText = AsthgBitmapText.createAngelCode(0, 2, Locale.getString("title", "main_menu"), "HUD");

		var titleSpr = FlxScrollingText.add(titleTxt, new openfl.geom.Rectangle(0, 2, FlxG.width, titleTxt.height));
		add(titleSpr);
		FlxScrollingText.startScrolling(titleSpr);

		var buildTxt = CoolUtil.getProjectInfo("buildNumber");
		var version:FlxBitmapText = new FlxBitmapText(0, 0, "v" + CoolUtil.getProjectInfo('version'), FlxBitmapFont.fromMonospace(Paths.getFolderPath("AbsoluteSystem.png", "fonts"), Constants.ABSOLUTE_FONT_GLYPHDATA, flixel.math.FlxPoint.get(8, 8)));
		if (!StringUtil.isBlank(buildTxt)) {
			version.text += " " + buildTxt;
		}
		version.setPosition(FlxG.width - version.width - 7, FlxG.height - version.height - 2);
		add(version);

		group = new FlxTypedGroup<AsthgBitmapText>();
		add(group);

		for (num => str in options) {
			var menu:AsthgBitmapText = AsthgBitmapText.createAngelCode(10, 30, Locale.getString(str, "main_menu"), "HUD");
			menu.x += (32 * num);
			menu.y += (18 * num);
			menu.ID = num;
			group.add(menu);
		}

		// Testing asset with Polymod and FireTongue but seems it doesn't work :P
		var test:AsthgSprite = AsthgSprite.create(0, 0, "assetTest");
		test.screenCenter();
		add(test);

		super.create();
		changeItem();
		AsthgSound.playMusic("MainMenu", { persist: true});
	}


	var selectedSomethin:Bool = false;
	override function update(elapsed:Float) {
		if (!selectedSomethin) {

			var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
			var scroll = FlxG.mouse.wheel;
			if (controls.UP || controls.DOWN || scroll != 0) {
				changeItem(((controls.UP ? -1 : 1) * mult) - -scroll);
			}

			if (controls.ACCEPT) {
				if (options[curSelected].toLowerCase() != "exit")
					AsthgSound.playSound(ConstantSound.MENU_ACCEPT);
				else
					AsthgSound.playSound( #if sys ConstantSound.MENU_ACCEPT #else "Fail" #end);

				selectedSomethin = true;
				group.forEach(function(txt:FlxBitmapText) {
					if (curSelected == txt.ID) {
						FlxFlicker.flicker(txt, 1, (!ClientPrefs.data.options.flashing) ? 0.3 : 0.06, false, false, function(flick:FlxFlicker) {
							var daChoice:String = options[curSelected];

							switch (daChoice.toLowerCase()) {
								case 'save select':
									LoadingState.switchStates(new SaveSelect(), true);
								case 'options':
									LoadingState.switchStates(new asthg.options.OptionsState());
									OptionsState.onPlayState = false;
								case 'mods':
									LoadingState.switchStates(new ModsMenu());
								case 'exit':
									#if sys
									Sys.exit(0);
									#else
									return;
									#end
							}
						});
					}
				});
			}

			if (controls.BACK) {
				AsthgSound.playSound(ConstantSound.MENU_BACK);
				StateManager.switchState(new TitleState());
			}
		}

		if (FlxG.keys.justPressed.SEVEN) {
			StateManager.switchState(new asthg.states.editor.MainMenuEdt());
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, group.length - 1);

		group.forEach(function(txt:FlxBitmapText) {
			txt.color = (txt.ID == curSelected) ? 0xFFFF0000 : 0xFFFFFFFF;
		});
	}
}