package asthe.states;

import flixel.input.keyboard.FlxKey;

class Init extends StateManager {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS];

	override public function create() {
		trace('Init created'.info());

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		ClientPrefs.loadPrefs();
		ClientPrefs.reloadVolumeKeys();

		#if MODS_ALLOWED
		Mods.loadMods([for (i in Mods.getAll()) i.dirName]);
		#end
		Locale.init();

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;


		if (FlxG.gamepads.numActiveGamepads > 0) {
			Controls.instance.controllerMode = true;
		}

		#if debug
			#if PLAYSTATE
			trace("Starting on PlayState...");
			FlxG.switchState(() -> new asthe.states.PlayState());
			#elseif MODS
			trace("Starting on Mods Menu...");
			FlxG.switchState(() -> new asthe.states.ModsMenu());
			#elseif OPTIONS
			trace("Starting on Options Menu...");
			FlxG.switchState(() -> new asthe.options.OptionsState());
			#elseif (SAVESELECT || DATASELECT)
			trace("Starting on Save Select...");
			FlxG.switchState(() -> new asthe.states.SaveSelect());
			#else
			trace("Starting on Main Menu...");
			FlxG.switchState(() -> new asthe.states.MainMenu());
			#end
		#else
		// Fallbacks to Title Screen
		trace("Starting on Title Screen...");
		FlxG.switchState(() -> new asthe.states.TitleState());
		#end
	}
}