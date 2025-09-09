package;

import debug.FPSCounter;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsVar:FPSCounter;
	public function new() {	
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end
		super();

		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();

		#if MODS_ALLOWED
		Scripts.instance = new Scripts();
		#end

		haxe.ui.Toolkit.init();
		
		FlxG.save.bind('game', CoolUtil.getSavePath());

		addChild(new FlxGame(0, 0, states.Init, #if (flixel < "5.0.0") 1, #end 60, 60, true));

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
	}
}
