package states;

import flixel.input.keyboard.FlxKey;

class Init extends StateManager {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	override public function create() {
		trace('Init created');

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		ClientPrefs.loadPrefs();
		
		Main.tongue.initialize({
			locale: ClientPrefs.data.language,
			replaceMissing: false
		});

		#if MODS_ALLOWED
		polymod.Polymod.scan(Constants.POLYMOD_SETTINGS.modRoot);
		#end

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		StateManager.switchState(new options.OptionsState());
	}
}