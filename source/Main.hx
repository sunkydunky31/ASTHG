package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var tongue:FireTongue;

	public function new() {	
		#if android
		Sys.setCwd(haxe.io.Path.addTrailingSlash(extension.androidtools.content.Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(haxe.io.Path.addTrailingSlash(lime.system.System.documentsDirectory));
		#end
		super();

		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();

		tongue = new FireTongue(VanillaSys, Case.Unchanged);
		
		FlxG.save.bind('game', CoolUtil.getSavePath());

		#if MODS_ALLOWED
		polymod.Polymod.init({
			modRoot: "../mods/",
			dirs:["pt-BR Translation"],
			framework: OPENFL,
			useScriptedClasses: false,
			firetongue: tongue
		});
		#end

		var game:FlxGame = new FlxGame(0, 0, states.Init, #if (flixel < "5.0.0") 1, #end 60, 60, true);
		game._customSoundTray = framework.SoundTray;
		addChild(game);
	}
}
