package options;

import states.PlayState;

class OptionsState extends MusicBeatState {
	var options:Array<String> = [
		"Controls",
		"Graphics",
		"Gameplay"
		#if TRANSLATIONS_ALLOWED , 'Language' #end
	];
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls': openSubState(new options.ControlsSubState());
			case 'Graphics': openSubState(new options.GraphicsSubState());
			case 'Gameplay': openSubState(new options.GameplaySubState());
			case 'Language': openSubState(new options.LanguageSubState());
		}
	}

	var selectorLeft:FlxText;
	var selectorRight:FlxText;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_options', "Options Menu"), null);
		#end

		var bg:FlxSprite = CoolUtil.makeBGGradient([0xFF561ECF, 0xFFEFFD26], 2, 37, false);
		add(bg);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (num => option in options) {
			var optionText:FlxText = new FlxText(0, FlxG.height/2-20, 0, Language.getPhrase('options_$option', option));
			optionText.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, CENTER);
			optionText.y += (20 * (num - (options.length / 2))) + optionText.size;
			optionText.screenCenter(X);
			grpOptions.add(optionText);
		}

		selectorLeft = new FlxText(0, 0, 0, '>>');
		selectorLeft.setFormat(Paths.font("Mania.ttf"), grpOptions.members[curSelected].size, FlxColor.WHITE, CENTER);
		add(selectorLeft);
		selectorRight = new FlxText(0, 0, 0, '<<');
		selectorRight.setFormat(Paths.font("Mania.ttf"), grpOptions.members[curSelected].size, FlxColor.WHITE, CENTER);
		add(selectorRight);

		changeSelection();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_options', "Options Menu"), Language.getPhrase("discordrpc_options-main", "Main State"));
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.justPressed('up')) {
			changeSelection(-1);
		}
		if (controls.justPressed('down')) {
			changeSelection(1);
		}

		if (controls.justPressed('back')) {
			CoolUtil.playSound("Menu Cancel", true);
			if(onPlayState) {
				LoadingState.switchStates(new PlayState());
				CoolUtil.mus.volume = 0;
			}
			else MusicBeatState.switchState(new states.MainMenu());
		}
		else if (controls.justPressed('accept'))
			openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.ID = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.ID == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 25;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 10;
				selectorRight.y = item.y;
			}
		}
		CoolUtil.playSound("Menu Change", true);
	}

	override function destroy() {
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}