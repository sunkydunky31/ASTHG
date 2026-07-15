package asthe.states;

import asthe.backend.StateManager;
import asthe.options.OptionsState;

import flixel.addons.plugin.FlxScrollingText;
import flixel.group.FlxGroup;
import flixel.effects.FlxFlicker;
import flixel.input.mouse.FlxMouse;

class MainMenu extends StateManager {
	public static var curSelected:Int = 0;

	var group:FlxTypedGroup<ASTHEBitmapText>;

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

		var bg:flixel.FlxSprite = ASTHESprite.createGradient(FlxG.width, FlxG.height, [0xFF793BFF, 0xFF95EDFF], 4, 32, false);
		add(bg);

		var bgLayer:ASTHESprite = new ASTHESprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgLayer.alpha = ClientPrefs.data.options.backLayers;
		add(bgLayer);

		var backd:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backd.y = 15;
		backd.flipY = true;

		backd.color = (ClientPrefs.data.options.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.YELLOW);
		backd.dirty = true;
		backd.velocity.set(-30, 0);
		add(backd);

		var backdFill:ASTHESprite = new ASTHESprite().createGraphic(FlxG.width, Math.floor(backd.y), backd.color);
		add(backdFill);

		var titleTxt:ASTHEBitmapText = ASTHEBitmapText.createAngelCode(0, 2, Locale.getString("title", "main_menu"), "HUD");

		var titleSpr = FlxScrollingText.add(titleTxt, new openfl.geom.Rectangle(0, 2, FlxG.width, titleTxt.height));
		add(titleSpr);
		FlxScrollingText.startScrolling(titleSpr);

		var buildTxt = CoolUtil.getProjectInfo("buildNumber");
		var version:ASTHEBitmapText = ASTHEBitmapText.createMonospace(0, 0, "v" + CoolUtil.getProjectInfo('version'), "AbsoluteSystem", Constants.ABSOLUTE_FONT_GLYPHDATA, [8, 8]);
		if (!StringUtil.isBlank(buildTxt)) {
			version.text += " " + buildTxt;
		}
		version.setPosition(FlxG.width - version.width - 7, FlxG.height - version.height - 2);
		add(version);

		group = new FlxTypedGroup<ASTHEBitmapText>();
		add(group);

		for (num => str in options) {
			var menu:ASTHEBitmapText = ASTHEBitmapText.createAngelCode(10, 30, Locale.getString(str, "main_menu"), "HUD");
			menu.x += (32 * num);
			menu.y += (18 * num);
			menu.ID = num;
			group.add(menu);
		}

		// Testing asset with Polymod and FireTongue but seems it doesn't work :P
		var test:ASTHESprite = ASTHESprite.create(0, 0, "assetTest");
		test.screenCenter();
		add(test);

		super.create();
		changeItem();
		ASTHESound.playMusic("MainMenu", { persist: true });
	}


	var selectedSomethin:Bool = false;
	override function update(elapsed:Float) {
		if (!selectedSomethin) {

			var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
			var scroll = FlxG.mouse.wheel;
			if (controls.UP || controls.DOWN || scroll != 0) {
				changeItem(((controls.UP ? -1 : controls.DOWN ? 1 : 0) - scroll) * mult);
			}

			if (controls.ACCEPT) {
				selectedSomethin = true;
				group.forEach(function(txt:FlxBitmapText) {
					if (curSelected == txt.ID) {
						FlxFlicker.flicker(txt, 1, (!ClientPrefs.data.options.flashing) ? 0.3 : 0.06, false, false, function(flick:FlxFlicker) {
							var daChoice:String = options[curSelected];

							switch (daChoice.toLowerCase()) {
								case 'save select':
									ASTHESound.playSound(ConstantSound.MENU_ACCEPT);
									LoadingState.switchStates(new SaveSelect(), true);
									case 'options':
									ASTHESound.playSound(ConstantSound.MENU_ACCEPT);
									LoadingState.switchStates(new asthe.options.OptionsState());
									OptionsState.onPlayState = false;
								case 'mods':
									ASTHESound.playSound(ConstantSound.MENU_ACCEPT);
									LoadingState.switchStates(new ModsMenu());
								case 'exit':
									#if sys
									ASTHESound.playSound(ConstantSound.MENU_ACCEPT);
									Sys.exit(0);
									#else
									ASTHESound.playSound("Fail");
									#end
							}
						});
					}
				});
			}

			if (controls.BACK) {
				ASTHESound.playSound(ConstantSound.MENU_BACK);
				FlxG.switchState(() -> new TitleState());
			}
		}

		if (FlxG.keys.justPressed.SEVEN) {
			FlxG.switchState(() -> new asthe.states.editor.MainMenuEdt());
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0) {
		if (change != 0)
			ASTHESound.playSound(ConstantSound.MENU_SCROLL);

		curSelected = FlxMath.wrap(curSelected + change, 0, group.length - 1);

		group.forEach(function(txt:FlxBitmapText) {
			txt.color = (txt.ID == curSelected) ? 0xFFFF0000 : 0xFFFFFFFF;
		});
	}
}