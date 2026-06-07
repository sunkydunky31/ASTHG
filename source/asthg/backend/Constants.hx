/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-07
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.backend;

class Constants {
	// Fonts
	public static final ABSOLUTE_FONT_GLYPHDATA:String = [ // Switched to array for more organization
		" ☺☻♥♦♣♠●◘◉◙♂♀♪♬☼",
		"►◄↕‼¶§▄↨↑↓→←∟↔▲▼",
		" !\"#$%&'()*+,-./",
		"0123456789:;<=>?",
		"@ABCDEFGHIJKLMNO",
		"PQRSTUVWXYZ[\\]^_",
		"`abcdefghijklmno",
		"pqrstuvwxyz{|}~⌂",
		"ÇüéâäaçêëèïîìÄÂ",
		"ÉæÆôöòûùÿÖÜc¢£¥₧ƒ",
		"áíóúñÑªº¿⌐¬½¼¡«»"
	].join("");

	// Characters
	public static final DEFAULT_CHARACTER:String = "sonic";
	public static final PALETTE_OVERRIDE:Array<FlxColor> = [0xFF2020A0, 0xFF2040C0, 0xff4040E0, 0xff6060E0];
	public static final LIFE_ICON:String = "liveIcon";

	/**
		Stores the velocity of super palettes when glowing into white in seconds
	**/
	public static final PALETTE_SUPER_VELOCITY = 1;

	// Save Select
	public static final SAVE_ENTRY_LIMIT:Int = 7; // Number of Save Slots
	public static final SAVE_SELECTED_FRAME_COLOR:Array<FlxColor> = [0xffffffff, 0xffff0000];
	public static final SAVE_SELECTED_ARROW_COLOR:Array<FlxColor> = [0xffff0059, 0xffff0059];


	public static final POLYMOD_SETTINGS:Dynamic = {
		useScriptedClasses: false
	};

	// Files
	inline public static var SOUND_EXT = #if (web || flash) "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	// Game - HUD
	inline public static var HUD_SCORE_MULTIPLIER:Float = 10.0;
	inline public static var HUD_RINGS_MAX:Int = 999;
	inline public static var HUD_LIVES_MAX:Int = 99;

	inline public static final LANGUAGE_DEFAULT:String = "en-US";
}

/**
	List of game sounds for easy management
**/
enum abstract ConstantSound(String) to String {
	var MENU_ACCEPT = "MenuAccept";
	var MENU_SCROLL = "MenuChange";
	var MENU_BACK   = "MenuCancel";

	var PLAYER_JUMP = "Jump";
	var PLAYER_ROLL = "Rolling";
	var PLAYER_TRANSFORM = "Transform";

	var RING = "Ring";
}