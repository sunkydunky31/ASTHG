package states;

import flixel.input.keyboard.FlxKey;

class Init extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	override public function create() {
		trace('Init created');

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		ClientPrefs.loadPrefs();
		Language.reloadPhrases();
		#if MODS_ALLOWED
		scripts.reloadScripts();

		scripts.callHook('onGameStart', []);
		#end

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		MusicBeatState.switchState(new states.SaveSelect());
	}
}