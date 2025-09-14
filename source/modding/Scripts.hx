package modding;

import objects.Character.CharacterData;
#if MODS_ALLOWED
import crowplexus.hscript.Interp;
import crowplexus.hscript.Parser;
#end

class Scripts {
	#if MODS_ALLOWED
	var interp:Interp;
	var parser:Parser;
	var hooks:Map<String, Dynamic>;
	
	public static var defaultHooks:Array<String> = [
    	"onGameStart", "onCreate", "onUpdate",
    	"onPlayerTransform", "onRingCollect", "onBossDefeated"
	];
	
	public static var instance:Scripts;

	public function new() {
		interp = new Interp();
		parser = new Parser();
		hooks = new Map();
		instance = this;

		var gameData = {
			'name': Std.string(CoolUtil.getProjectInfo('title')),
			'version': Std.string(CoolUtil.getProjectInfo('version')),
			'filename': Std.string(CoolUtil.getProjectInfo('file'))
		}

		addVar("trace", haxe.Log.trace);
		addVar("Type", Type);

		addVar("game", gameData);
	}

	public function addVar(name:String, vars:Dynamic):Void {
		interp.variables.set(name, vars);
	}

	public function getVar(name:String):Dynamic {
		return interp.variables.get(name);
	}

	public function hasVar(name:String):Bool {
		return interp.variables.exists(name);
	}

	public function getFunc(name:String, args:Array<Dynamic>) {
		var func = getVar(name);
		if (func != null && Reflect.isFunction(func)) {
            Reflect.callMethod(null, func, args);
        }
	}

	public function getScript(path:String) {
		interp.execute(parser.parseString(File.getContent(path)));

		for (hookName in defaultHooks) {
            if (hasVar(hookName)) {
                hooks.set(hookName, getVar(hookName));
            }
        }
	}

	public function callHook(name:String, args:Array<Dynamic>) {
        if (hooks.exists(name)) {
			try {
	            Reflect.callMethod(null, hooks.get(name), args);
			}
			catch(e:Dynamic) {
				trace('Error calling hook: $e');
			}
        }
    }

	public function reloadScripts():Void {		
		hooks.clear();
		if (FileSystem.exists(Constants.SCRIPTS_PATH) && FileSystem.isDirectory(Constants.SCRIPTS_PATH)) {
			for (file in FileSystem.readDirectory(Constants.SCRIPTS_PATH)) {
				if (FileSystem.exists(Constants.SCRIPTS_PATH + "/" + file) && file.toLowerCase().endsWith('.hx'))	{
					trace('Loaded script ($file)');
					getScript(Constants.SCRIPTS_PATH + "/" + file);
				}
			}
		}
	}
	#end
}