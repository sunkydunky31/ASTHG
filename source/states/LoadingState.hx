package states;

import objects.Character;

import flixel.FlxState;
import flixel.ui.FlxBar;

import lime.app.Future;
import lime.app.Promise;
import lime.utils.Assets as LimeAssets;

import openfl.utils.Assets;

import haxe.io.Path;


class LoadingState extends StateManager {
	var target:FlxState;
	var stopMusic = false;
	var directory:String;
	var callbacks:MultiCallback;
	var targetTime:Float = 0;

	function new(target:FlxState, stopMusic:Bool, directory:String) {
		this.target = target;
		this.stopMusic = stopMusic;
		this.directory = directory;

		super();
	}

	var loadingTxt:FlxText;
	var loadBar:FlxBar;

	override function create() {
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xfff0f0f0);
		add(bg);
		
		loadingTxt = new FlxText(0, 70, 0, Locale.getString("loading", "data", ["..."]), 16);
		loadingTxt.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, "center");
		add(loadingTxt);

		loadBar = new FlxBar(0, FlxG.height - 20, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width * 0.8, 10);
		loadBar.createFilledBar(0xFF303030, 0xFF8BE3FF);
		add(loadBar);
		super.create();
	}
	
	function checkLibrary(library:String) {
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null) {
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw new haxe.Exception("Missing library: " + library);

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed);

		if(callbacks != null) {
			targetTime = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);
			loadBar.scale.x += 0.5 * (targetTime - loadBar.scale.x);
		}
	}
	
	function onLoad() {
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		StateManager.switchState(target);
	}
	
	inline static public function switchStates(target:FlxState, stopMusic = false)
		StateManager.switchState(getNextState(target, stopMusic));
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState {
		var directory:String = 'shared';

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to $directory');

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	override function destroy() {
		super.destroy();
		
		callbacks = null;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null) {
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled") {
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function () {
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}