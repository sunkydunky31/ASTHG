package asthg.states;

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
			StateManager.switchState(new asthg.states.PlayState());
			#elseif MODS
			trace("Starting on Mods Menu...");
			StateManager.switchState(new asthg.states.ModsMenu());
			#elseif OPTIONS
			trace("Starting on Options Menu...");
			StateManager.switchState(new asthg.options.OptionsState());
			#elseif (SAVESELECT || DATASELECT)
			trace("Starting on Save Select...");
			StateManager.switchState(new asthg.states.SaveSelect());
			#else
			trace("Starting on Main Menu...");
			StateManager.switchState(new asthg.states.MainMenu());
			#end
		#else
		// Fallbacks to Title Screen
		trace("Starting on Title Screen...");
		StateManager.switchState(new asthg.states.TitleState());
		#end
	}
}