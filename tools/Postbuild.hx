package tools;

import sys.FileSystem;
import haxe.io.Path;
using StringTools;

@:nullSafety
class Postbuild {
	// These options will be updated later.
	public static var FILE:String = "";
	public static var PACKAGE_NAME:String = "";
	public static var APP_PATH:String = "";
	public static var IS_WINDOWS:Bool = false;
	public static var IS_LINUX:Bool = false;
	public static var IS_MACOS:Bool = false;

	static function main():Void {
		parseBuildSpecs();
		if (IS_LINUX) {
			handleDesktopFile();
		}

		//sys.FileSystem.deleteFile("BUILD.txt");
	}

	static function parseBuildSpecs():Void {
		final results = sys.io.File.getContent("BUILD.txt").trim();
		for (line => text in results.split("\n")) {
			text = text.trim();
			var sep = text.indexOf("=");

			if (sep != -1) {
				var key = text.substr(0, sep);
				var value = text.substr(sep + 1);

				Reflect.setProperty(Postbuild, key, key.startsWith("IS_") ? (value == 'true') : value);
			}
		}
	}

	static function handleDesktopFile() {
		final HOME = Sys.getEnv("HOME");

		final path = Path.join([".", APP_PATH, 'linux', "bin"]);
		final deskFile = PACKAGE_NAME + ".desktop";
		final deskPath = Path.join([path, deskFile]);
		final localPath = Path.join([HOME, ".local", "share", "applications"]);

		var file = '[Desktop Entry]\n'+
		'Name=$FILE\n'+
		'GenericName=$FILE\n'+
		'Comment=Small Sonic the Hedgehog engine made in HaxeFlixel.\n'+
		'Type=Application\n'+
		'Icon=$PACKAGE_NAME\n'+
		'Exec=ASTHE/$path/$FILE %f\n'+
		'Terminal=false\n'+
		'Categories=Game;\n'+
		'Keywords=sonic;sunnydev;asth;flixel;haxe;\n'+
		'StartupNotify=false';

		if (FileSystem.exists(Path.addTrailingSlash(localPath) + deskFile)) {
			FileSystem.deleteFile(Path.addTrailingSlash(localPath) + deskFile);
		}

		sys.io.File.saveContent(deskPath, file);
		Sys.command("desktop-file-install", ['--dir=$localPath', deskPath]);
	}
}