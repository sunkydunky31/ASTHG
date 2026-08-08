package asthe.input;

enum abstract InputList(String) from String to String {
	// Movement - Menu navigation
	var UP    = "up";
	var LEFT  = "left";
	var DOWN  = "down";
	var RIGHT = "right";

	// Actions
	var AUXILIAR = "auxiliar"; // `Delete` on menus
	var JUMP     = "jump";
	var ACCEPT   = "accept";
	var BACK     = "back";

	// Pause the game
	var PAUSE = "pause";

	// Volume keybinds
	var VOLUME_MUTE = "volume_mute";
	var VOLUME_UP   = "volume_up";
	var VOLUME_DOWN = "volume_down";

	public static function toArray():Array<InputList> {
		return [
			UP, LEFT, DOWN, RIGHT,
			AUXILIAR, JUMP, ACCEPT, BACK,
			PAUSE,
			VOLUME_MUTE, VOLUME_UP, VOLUME_DOWN
		];
	}
}