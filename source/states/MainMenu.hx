package states;

import options.OptionsState;
import flixel.effects.FlxFlicker;
import backend.MusicBeatState;
import flixel.input.mouse.FlxMouse;
import flixel.group.FlxGroup;

class MainMenu extends MusicBeatState {
	public static var curSelected:Int = 0;
	var group:FlxTypedGroup<FlxBitmapText>;
	var options:Array<String> = [
		"Save Select",
		"Options",
		#if MODS_ALLOWED "Mods", #end
		"Exit"
	];

	override function create() {
		Paths.clearStoredMemory();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_main_menu', 'Main Menu'), null);
		#end

		var bg:FlxSprite = CoolUtil.makeBGGradient([0xFF793BFF, 0xFF95EDFF], 4, 32, false);
		add(bg);

		var backd:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backd.y = 15;
		backd.flipY = true;
		backd.color = 0xFFf0f000;
		backd.velocity.set(-30, 0);
		add(backd);
		
		var backdFill:FlxSprite = new FlxSprite().makeGraphic(1, 1, backd.color);
		backdFill.scale.set(FlxG.width, Math.floor(backd.y));
		backdFill.updateHitbox();
		add(backdFill);

		var titleTxt:FlxBitmapText = new FlxBitmapText(0, 2, Language.getPhrase("mainmenu_title", "Main Menu"), Paths.fontBitmap("HUD"));

		var titleBackdrop:FlxBackdrop = new FlxBackdrop(titleTxt.graphic, X);
		titleBackdrop.velocity.set(30, 0);
		add(titleBackdrop);

		group = new FlxTypedGroup<FlxBitmapText>();
		add(group);

		for (num => str in options) {
			var menu:FlxBitmapText = new FlxBitmapText(10, 30 + (18 * num), Language.getPhrase('mainmenu_$str', str), Paths.fontBitmap("HUD"));
			menu.ID = num;
			group.add(menu);
		}

		super.create();
		changeItem();
		CoolUtil.playMusic("MainMenu", {sample: 202752});
	}

	
	var selectedSomethin:Bool = false;
	override function update(elapsed:Float) {
		if (!selectedSomethin) {
			if (controls.justPressed('up')) {
				changeItem(-1);
				CoolUtil.playSound("Menu Change", true);
			}
			if (controls.justPressed('down')) {
				changeItem(1);
				CoolUtil.playSound("Menu Change", true);
			}
			if (controls.justPressed('accept')) {
				CoolUtil.playSound("Menu Accept", true);
				selectedSomethin = true;
				group.forEach(function(txt:FlxBitmapText) {
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

							switch (daChoice.toLowerCase()) {
								case 'save select':
									LoadingState.loadAndSwitchState(new SaveSelect(), true);
								case 'options':
									LoadingState.loadAndSwitchState(new OptionsState());
									OptionsState.onPlayState = false;
								case 'mods':
									LoadingState.loadAndSwitchState(new ModsMenu());
								case 'exit':
									Sys.exit(0);
							}
						});
					}
				});
			}
		}
		super.update(elapsed);
	}

	function changeItem(change:Int = 0) {
		curSelected += change;

		if (curSelected >= group.length) curSelected = 0;
		if (curSelected < 0) curSelected = group.length - 1;
		group.forEach(function(txt:FlxBitmapText) { //https://github.com/Jorge-SunSpirit/Doki-Doki-Takeover/blob/main/source/MainMenuState.hx#L390; Sorry
			txt.color = (txt.ID == curSelected) ? 0xFFFF0000 : 0xFFFFFFFF;
		});
	}
}