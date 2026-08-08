package asthe.substates;

/**
	TODO: Make this functional
**/
class GameOver extends SubStateManager{

	// helpers
	var text:String = "";
	var textL:String = text.substr(0, Std.int(text.length/2)).trim();
	var textR:String = text.substring(Std.int(text.length/2)).trim();


}