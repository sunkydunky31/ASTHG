package asthe.util;

import openfl.system.Capabilities;
import lime.system.System as LimeSystem;

class SystemUtil {
	@:isVar
	public static var ACCENT_COLOR(get, set):FlxColor = 0xFFFFFF;

	/**
		Returns the Directory Separator character  
		`\` on Windows, `/` on other systems.
	**/
	inline public static final DIRECTORY_SEPARATOR:String = #if windows "\\"; #else "/"; #end

	/**
		Returns the Invalid Directory Separator character, used for replacing
		incorrect chars on a path.

		`/` on Windows, `\` on other systems.
	**/
	inline public static final DIRECTORY_SEPARATOR_REPL:String = #if windows "/"; #else "\\"; #end
	public static final INVALID_PATH_CHARS:EReg                =
	#if windows
	new EReg("[\\/:*?\"<>|]", "g");
	#else
	new EReg("/", "g");
	#end

	inline public static function openFolder(folder:String, ?absolute:Null<Bool> = false) {
		#if sys
		if(!absolute) folder =  Sys.getCwd() + folder;

		folder = haxe.io.Path.removeTrailingSlashes(folder.replace(DIRECTORY_SEPARATOR_REPL, DIRECTORY_SEPARATOR));


		var command:String = "";
		#if mac
		command = "/usr/bin/open";
		#elseif linux
		command = '/usr/bin/xdg-open';
		#elseif windows
		command = 'explorer.exe';
		#end

		#if (windows || linux || mac)
		Sys.command(command, [folder]);
		trace('Command $command', 'Folder $folder');
		#end

		#else
		FlxG.log.error("Platform is not supported for SystemUtil.openFolder");
		#end
	}

	inline public static function browserLoad(site:String):Void {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	@:privateAccess() private static var _accent:FlxColor = 0xFFFFFF;
	inline public static function loadAccentColor():Null<Int> {
		trace("Loading accent colors...".info());

		#if (windows && !winjs)

		// Run a command to get the value
		var p = new sys.io.Process("reg", ["query", "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Accent", "/v", "AccentColorMenu"]);

		var result:String = p.stdout.readAll().toString();
		p.close();

		// Conversion from ABRG to ARGB
		var accent:String = "0x";

		var r = result.split("    ")[3]; // bro
		accent += (r.substr(2,2)); // Alpha
		accent += (r.substr(8,2)); // Red
		accent += (r.substr(6,2)); // Green
		accent += (r.substr(4,2)); // Blue

		trace('Loaded!\nParsed: . $accent\nOriginal: $r'.info());
		return Std.parseInt(accent);
		#else // I don't know how accent colors works on other systems...
		var errorMsg:String = "You're using a platform that doesn't support accent colors!";

		trace(errorMsg.error());
		FlxG.log.error(errorMsg);
		return 0xFFFFFF;
		#end
	}

	private static function get_ACCENT_COLOR():FlxColor {
		return _accent;
	}

	private static function set_ACCENT_COLOR(value:Null<FlxColor>):FlxColor {
		_accent = value ?? FlxColor.WHITE;

		if (value == null) {
			trace("Value for accent color is null! Setting to WHITE".warn());
		}

		return _accent;
	}

	public static function getSystemName():String {
		return LimeSystem.platformName;
	}
}