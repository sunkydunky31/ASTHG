package asthg.util;

import openfl.system.Capabilities;
import lime.system.System as LimeSystem;

class SystemUtil {
	public static var ACCENT_COLOR(get, set):FlxColor;

	inline public static function openFolder(folder:String, ?absolute:Null<Bool> = false) {
		#if sys
		if(!absolute) folder =  Sys.getCwd() + folder;

		#if windows
		folder = folder.replace('/', '\\');
		#else
		folder = folder.replace('\\', '/');
		#end

		if(folder.endsWith('/')) folder.substr(0, folder.length - 1);


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

	@:privateAccess() private static var _accent:FlxColor = FlxColor.WHITE;
	inline public static function loadAccentColor():Null<FlxColor> {
		trace("Loading accent colors...".info());

		#if (windows && !winjs)

		// Run a command to get the value
		var p = new sys.io.Process("powershell",
			["Get-ItemPropertyValue",
			 '"HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Accent"',
			 '"AccentColorMenu"']);

		var result = StringUtil.hexFloat(Std.parseFloat(p.stdout.readLine()));
		#if debug trace("Loaded color from powershell"); #end
		p.close();

		// Conversion from ABRG to ARGB
		var accent = "0x";
		#if debug trace("Converting color to ARGB..."); #end
		accent += (result.substr(0,2)); // Alpha
		accent += (result.substr(6,2)); // Red
		accent += (result.substr(4,2)); // Green
		accent += (result.substr(2,2)); // Blue

		trace("Loaded!".info());
		return Std.parseInt(accent);
		#else // I don't know how accent colors works on other systems...
		var errorMsg:String = "You're using a platform that doesn't support accent colors!";
		trace(errorMsg.error());
		FlxG.log.error(errorMsg);
		return FlxColor.WHITE;
		#end
	}

	private static function get_ACCENT_COLOR():FlxColor {
		return _accent;
	}

	private static function set_ACCENT_COLOR(value:Null<FlxColor>):FlxColor {
		_accent = value ?? FlxColor.BLACK;

		if (value == null) {
			trace("Value for accent color is null! Setting to BLACK".warn());
		}

		return _accent;
	}

	public static function getSystemName():String {
		return LimeSystem.platformName;
	}
}