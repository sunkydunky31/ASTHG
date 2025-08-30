package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new() {	
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end
		super();
		
	/*	FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];*/

		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		
		FlxG.save.bind('game', CoolUtil.getSavePath());

		addChild(new FlxGame(0, 0, states.TitleState, #if (flixel < "5.0.0") 1, #end 60, 60, true));
	}
}
