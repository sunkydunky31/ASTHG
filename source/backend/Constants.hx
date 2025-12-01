package backend;

class Constants {
	// Fonts
	public static inline final ABSOLUTE_FONT_GLYPHDATA:String = " ☺☻♥♦♣♠●◘◉◙♂♀♪♬☼►◄↕‼¶§▄↨↑↓→←∟↔▲▼ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~⌂ÇüéâäaçêëèïîìÄÂÉæÆôöòûùÿÖÜc¢£¥₧ƒáíóúñÑªº¿⌐¬½¼¡«»";

	// Characters
	public static final PALETTE_OVERRIDE:Array<FlxColor> = [0xFF2020A0, 0xFF2040C0, 0xff4040E0, 0xff6060E0];

	// Save Select
	public static final SAVE_ENTRY_LIMIT:Int = 7;
	public static final SAVE_SELECTED_FRAME_COLOR:Array<String> = ["#ffffff", "#ff0000"];
	public static final SAVE_SELECTED_ARROW_COLOR:Array<String> = ["#ff0059", "#ff0059"];

	public static final POLYMOD_SETTINGS:Dynamic = {
		modRoot: "../mods/",
		dirs:["pt-BR Translation"],
		useScriptedClasses: false,
	};
}