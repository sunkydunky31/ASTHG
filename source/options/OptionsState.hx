package options;

class OptionsState extends StateManager {
	var options:Array<String> = [
		"System",
		"Display",
		"Gameplay",
		"Controls"
		#if TRANSLATIONS_ALLOWED , "Language" #end
	];
	private var curSelected:Int = 0;
	private var grpTabs:FlxTypedGroup<FlxBitmapText>;

	public static var onPlayState:Bool = false;

	override function create() {
		// background gradient (uses existing util)
		var bg:FlxSprite = CoolUtil.makeBGGradient([0x4FFFFFFF, 0x28FFFFFF], 2, 37, false);
		add(bg);

		var tabBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("optionsTabHeader"));
		add(tabBG);

		// tabs group
		grpTabs = new FlxTypedGroup<FlxBitmapText>();
		add(grpTabs);

		for (num => str in options) {
			var txt:FlxBitmapText = new FlxBitmapText(0, 0, Locale.getString(str, "options"), Paths.getAngelCodeFont("Roco"));
			trace('str: ${str.toLowerCase()}, return: ${Locale.getString(str, "options")}');
			txt.screenCenter();
			txt.y += (20 * (num - (options.length / 2)));
			txt.screenCenter(X);
			grpTabs.add(txt);
		}

		updateTabVisuals();

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.justPressed('up')) {
			changeSelection(-1);
			CoolUtil.playSound("MenuChange");
		} else if (controls.justPressed('down')) {
			changeSelection(1);
			CoolUtil.playSound("MenuChange");
		}

		if (controls.justPressed('accept')) {
			CoolUtil.playSound("MenuAccept");
			openSelectedSubstate(options[curSelected]);
		}

		if (controls.justPressed('back')) {
			ClientPrefs.saveSettings();
			CoolUtil.playSound("MenuCancel");
			StateManager.switchState(new states.MainMenu());
		}
	}

	private function updateTabVisuals():Void {
		for (idx => t in grpTabs.members) {
			t.color = (idx == curSelected) ? FlxColor.YELLOW : FlxColor.WHITE;
		}
	}

	function changeSelection(change:Int) {	
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
		updateTabVisuals();
	}

	function openSelectedSubstate(lbl:String) {
		switch (lbl.toLowerCase()) {
		//	case "display": openSubState(new options.substates.Display());
			case "controls": openSubState(new options.substates.Controls());
			case "language": openSubState(new options.substates.Language());
			default: return;
		}
	}

	override function destroy() {
		super.destroy();
	}
}