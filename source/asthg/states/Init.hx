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
		trace("Running on debug mode!");
		#elseif final
		trace("Running on final mode... oh, creepy!");
		#end

		#if debug
			#if PLAYSTATE
			StateManager.switchState(new asthg.states.PlayState());
			#elseif MODS
			StateManager.switchState(new asthg.states.ModsMenu());
			#elseif OPTIONS
			StateManager.switchState(new asthg.options.OptionsState());
			#elseif (SAVESELECT || DATASELECT)
			StateManager.switchState(new asthg.states.SaveSelect());
			#end
		#else
		// Fallbacks to Title Screen
		StateManager.switchState(new asthg.states.TitleState());
		#end
	}
}