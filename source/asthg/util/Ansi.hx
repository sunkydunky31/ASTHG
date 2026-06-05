package asthg.util;

using util.StringUtil;

enum abstract AnsiList(String) to String {
	var RESET              = "\x1b[0m";
	var BOLD               = "\x1b[1m";
	var DIMMED             = "\x1b[2m";
	var ITALIC             = "\x1b[3m";
	var UNDERLINE          = "\x1b[4m";
	var BLINK              = "\x1b[5m";
	var REVERSE            = "\x1b[7m";
	var HIDDEN             = "\x1b[8m";
	var HIPERLINK          = "\x1b[8;{0}\x1b\\{1}\x1b]8;;\x1b\\m"; // {0}: Link, {1}: Label text.
	var STRIKETHROUGH      = "\x1b[9m";

	var BOLD_OFF           = "\x1b[22m";
	var DIMMED_OFF         = "\x1b[22m";
	var ITALIC_OFF         = "\x1b[23m";
	var UNDERLINE_OFF      = "\x1b[24m";
	var BLINK_OFF          = "\x1b[25m";
	var REVERSE_OFF        = "\x1b[27m";
	var HIDDEN_OFF         = "\x1b[28m";
	var STRIKETHROUGH_OFF  = "\x1b[29m";

	var BLACK              = "\x1b[30m";
	var RED                = "\x1b[31m";
	var GREEN              = "\x1b[32m";
	var YELLOW             = "\x1b[33m";
	var BLUE               = "\x1b[34m";
	var MAGENTA            = "\x1b[35m";
	var CYAN               = "\x1b[36m";
	var WHITE              = "\x1b[37m";
	var TRUE_COLOR         = "\x1b[38;2;{0};{1};{2}m";	// {0}: Red byte, {1}: Green byte, {2}: Blue byte

	var BG_BLACK           = "\x1b[40m";
	var BG_RED             = "\x1b[41m";
	var BG_GREEN           = "\x1b[42m";
	var BG_YELLOW          = "\x1b[43m";
	var BG_BLUE            = "\x1b[44m";
	var BG_MAGENTA         = "\x1b[45m";
	var BG_CYAN            = "\x1b[46m";
	var BG_WHITE           = "\x1b[47m";
	var BG_TRUE_COLOR      = "\x1b[48;2;{0};{1};{2}m";	// {0}: Red byte, {1}: Green byte, {2}: Blue byte

	var BRIGHT_BLACK       = "\x1b[90m";
	var BRIGHT_RED         = "\x1b[91m";
	var BRIGHT_GREEN       = "\x1b[92m";
	var BRIGHT_YELLOW      = "\x1b[93m";
	var BRIGHT_BLUE        = "\x1b[94m";
	var BRIGHT_MAGENTA     = "\x1b[95m";
	var BRIGHT_CYAN        = "\x1b[96m";
	var BRIGHT_WHITE       = "\x1b[97m";

	var BG_BRIGHT_BLACK    = "\x1b[100m";
	var BG_BRIGHT_RED      = "\x1b[101m";
	var BG_BRIGHT_GREEN    = "\x1b[102m";
	var BG_BRIGHT_YELLOW   = "\x1b[103m";
	var BG_BRIGHT_BLUE     = "\x1b[104m";
	var BG_BRIGHT_MAGENTA  = "\x1b[105m";
	var BG_BRIGHT_CYAN     = "\x1b[106m";
	var BG_BRIGHT_WHITE    = "\x1b[107m";
}

class Ansi {
	public static var enabled:Bool = #if message.nocolor false #else true #end; // Apply Haxe define for ANSI tracing


	public static function info(str:String):String
		return ansiApply(" INFO ", AnsiList.BG_CYAN) + str;

	public static function error(str:String):String
		return ansiApply(" ERROR ", AnsiList.BG_RED) + str;

	public static function warn(str:String):String
		return ansiApply(" WARNING ", AnsiList.BG_YELLOW) + str;

	/**
		Allows you to create a custom log label with custom colors.
		@param str The message wou want to log
		@param title The label that appears before the message, like " INFO ".
		@param color The Ansi code for the label.
		@return String
	**/
	public static function infoCustom(str:String, title:String, ?color:flixel.util.typeLimit.OneOfTwo<AnsiList, Null<Array<Dynamic>>>):String
		return switch (color) {
			case v if (Std.isOfType(v, Array)): ansiApply(' $title ', AnsiList.BG_TRUE_COLOR, v) + str;
			default: ansiApply(' $title ', color, null) + str;
		}

	public static function ansiApply(text:String, ansi:AnsiList, ?args:Null<Array<Dynamic>>):String {

		var temp = ((enabled) ? ansi : "") + text;

		if (args != null)
			temp.format(args);

		temp += AnsiList.RESET;

		//Prevents RESET appear more than 1 time
		if (StringTools.contains(temp, AnsiList.RESET) && enabled)
			temp = StringTools.replace(temp, AnsiList.RESET, "");

		return temp + (enabled ? AnsiList.RESET : "") + ' ';
	}
}