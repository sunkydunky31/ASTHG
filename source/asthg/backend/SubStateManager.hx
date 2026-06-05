package asthg.backend;

import flixel.FlxSubState;

/**
	@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/MusicBeatSubstate.hx
**/
class SubStateManager extends FlxSubState {
	public function new() super();

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return Controls.instance;

	override function update(elapsed:Float) {
		//everyStep();
		if(!persistentUpdate) StateManager.timePassedOnState += elapsed;

		super.update(elapsed);
	}
}
