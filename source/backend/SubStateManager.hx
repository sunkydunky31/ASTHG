package backend;

import flixel.FlxSubState;

class SubStateManager extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return Controls.instance;

	override function update(elapsed:Float)
	{
		//everyStep();
		if(!persistentUpdate) StateManager.timePassedOnState += elapsed;

		super.update(elapsed);
	}
}
