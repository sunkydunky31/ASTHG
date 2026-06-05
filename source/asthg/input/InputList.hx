package asthg.input;

enum abstract InputList(String) from String to String {
	// Movement - Menu navigation
	var UP    = "up";
	var LEFT  = 'left';
	var DOWN  = 'down';
	var RIGHT = 'right';

	// Actions
	var AUXILIAR = 'auxiliar'; // `Delete` on menus
	var JUMP     = 'jump';
	var ACCEPT   = 'accept';
	var BACK     = 'back';

	// Pause the game
	var PAUSE = 'pause';

	// Volume keybinds
	var VOLUME_MUTE = 'volume_mute';
	var VOLUME_UP   = 'volume_up';
	var VOLUME_DOWN = 'volume_down';
}