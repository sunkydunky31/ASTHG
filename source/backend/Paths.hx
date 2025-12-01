package backend;

import flixel.math.FlxPoint;
import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import lime.utils.Assets;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

@:access(openfl.display.BitmapData)
class Paths
{
	inline public static var SOUND_EXT = #if (web || flash) "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = #if (web || flash) "mp4" #else "ogv" #end;

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> = ['assets/shared/music/MainMenu.$SOUND_EXT'];
	// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory() {
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys()) {
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key)) {
				destroyGraphic(currentTrackedAssets.get(key)); // get rid of the graphic
				currentTrackedAssets.remove(key); // and remove the key from local cache map
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];

	@:access(flixel.system.frontEnds.BitmapFrontEnd._cache)
	public static function clearStoredMemory() {
		// clear anything not in the tracked assets list
		for (key in FlxG.bitmap._cache.keys()) {
			if (!currentTrackedAssets.exists(key))
				destroyGraphic(FlxG.bitmap.get(key));
		}

		// clear all sounds that are cached
		for (key => asset in currentTrackedSounds) {
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && asset != null) {
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	public static function freeGraphicsFromMemory() {
		var protectedGfx:Array<FlxGraphic> = [];
		function checkForGraphics(spr:Dynamic) {
			try {
				var grp:Array<Dynamic> = Reflect.getProperty(spr, 'members');
				if(grp != null) {
					//trace('is actually a group');
					for (member in grp)
					{
						checkForGraphics(member);
					}
					return;
				}
			}

			//trace('check...');
			try {
				var gfx:FlxGraphic = Reflect.getProperty(spr, 'graphic');
				if(gfx != null) {
					protectedGfx.push(gfx);
					//trace('gfx added to the list successfully!');
				}
			}
			//catch(haxe.Exception) {}
		}

		for (member in FlxG.state.members)
			checkForGraphics(member);

		if(FlxG.state.subState != null)
			for (member in FlxG.state.subState.members)
				checkForGraphics(member);

		for (key in currentTrackedAssets.keys()) {
			// if it is not currently contained within the used local assets
			if (!dumpExclusions.contains(key)) {
				var graphic:FlxGraphic = currentTrackedAssets.get(key);
				if(!protectedGfx.contains(graphic)) {
					destroyGraphic(graphic); // get rid of the graphic
					currentTrackedAssets.remove(key); // and remove the key from local cache map
					//trace('deleted $key');
				}
			}
		}
	}

	inline static function destroyGraphic(graphic:FlxGraphic) {
		// free some gpu memory
		if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null)
			graphic.bitmap.__texture.dispose();
		FlxG.bitmap.remove(graphic);
	}

	static public var currentLevel:String;
	static public function setCurrentLevel(name:String) {
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, ?type:AssetType = TEXT, ?parentfolder:String = null, ?modsAllowed:Bool = true):String {
		if (parentfolder != null && parentfolder != "" && parentfolder != "shared") {
			return getFolderPath(file, parentfolder);
		}

		if (currentLevel != null && currentLevel != 'shared') {
			var levelPath = getFolderPath(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}
		return getFolderPath(file);
	}

	inline static public function getFolderPath(file:String = '', folder = "shared"):String {
		return 'assets/$folder/$file';
	}

	inline static public function file(key:String, ?type:AssetType = TEXT, ?library:String) {
		return getPath(key, type, library);
	}

	inline static public function video(key:String) {
		return getPath('videos/$key.$VIDEO_EXT');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int) {
		return sound(key + FlxG.random.int(min, max));
	}

	inline static public function sound(key:String):Sound {
		return returnSound('sounds/$key');
	}

	inline static public function music(key:String):Sound {
		return returnSound('music/$key');
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	/**
		Gets a image
		@param key Name of the image (e.g. funkay)
		@param parentFolder Use another folder? (Default: Shared)
		@param allowGPU Cache on GPU? (Default: True)
		@return openfl.display.BitmapData
	**/
	static public function image(key:String, ?parentFolder:String = null, ?allowGPU:Bool = true):FlxGraphic {
		key = Locale.getFile('images/$key') + '.png';
		var bitmap:BitmapData = null;
		if (currentTrackedAssets.exists(key)) {
			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}
		return cacheBitmap(key, parentFolder, bitmap, allowGPU);
	}

	public static function cacheBitmap(key:String, ?parentFolder:String = null, ?bitmap:BitmapData, ?allowGPU:Bool = true):FlxGraphic {
		if (bitmap == null) {
			var file:String = getPath(key, IMAGE, parentFolder, true);
			
			if (OpenFlAssets.exists(file, IMAGE))
				bitmap = OpenFlAssets.getBitmapData(file);

			if (bitmap == null) {
				trace('[cacheBitmap] Bitmap not found: $file | key: $key');
				return null;
			}
		}

		if (allowGPU && ClientPrefs.data.cacheOnGPU && bitmap.image != null) {
			bitmap.lock();
			if (bitmap.__texture == null) {
				bitmap.image.premultiplied = true;
				bitmap.getTexture(FlxG.stage.context3D);
			}
			bitmap.getSurface();
			bitmap.disposeImage();
			bitmap.image.data = null;
			bitmap.image = null;
			bitmap.readable = true;
		}

		var graph:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
		graph.persist = true;
		graph.destroyOnNoUse = false;

		currentTrackedAssets.set(key, graph);
		localTrackedAssets.push(key);
		return graph;
	}


	inline static public function font(key:String) {
		var folderKey:String = Locale.getFile('fonts/$key');
		return 'assets/$folderKey';
	}

	/**
		Gets a AngelCode bitmap font
		@param key Name of the font file
	**/
	inline static public function getAngelCodeFont(key:String) {
		return FlxBitmapFont.fromAngelCode(getFolderPath('$key.png', 'fonts'), getFolderPath('$key.fnt', 'fonts'));
	}

	inline static public function getSparrowAtlas(key:String, ?parentFolder:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, parentFolder, allowGPU);
		
		return FlxAtlasFrames.fromSparrow(imageLoaded, getPath(Locale.getFile('images/$key') + '.xml', TEXT, parentFolder));

	}

	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static function returnSound(key:String, ?path:String, ?beepOnNull:Bool = true) {
		var file:String = getPath(Locale.getFile(key) + '.$SOUND_EXT', SOUND, path);

		//trace('precaching sound: $file');
		if(!currentTrackedSounds.exists(file))
		{
			if(OpenFlAssets.exists(file, SOUND))
				currentTrackedSounds.set(file, OpenFlAssets.getSound(file));
			else if(beepOnNull)
			{
				trace('SOUND NOT FOUND: $key, PATH: $path');
				FlxG.log.error('SOUND NOT FOUND: $key, PATH: $path');
				return FlxAssets.getSound('flixel/sounds/beep');
			}
		}
		localTrackedAssets.push(file);
		return currentTrackedSounds.get(file);
	}

	inline public static function fileExists(key:String, type:AssetType, ?library:String = null, ?ignoreMods:Bool = false) {
		var path = getPath(key, type, library, !ignoreMods);
		
		if(OpenFlAssets.exists(path, type)) {
			return true;
		} else {
			trace('[fileExists::OpenFL] File doesn\'t exists: $key | path: $path');
			return false;
		}
	}
	
	inline static public function getContent(key:String, ?ignoreMods:Bool = false) {
		var path:String = getPath(key, TEXT, !ignoreMods);
		#if sys
		if (FileSystem.exists(path)) return File.getContent(path); else {
			trace('[getContent] Cannot get the content of "$key" | Path: "$path" | Tried FileSystem');
			return null;
		}
		#else
		if (OpenFlAssets.exists(path, TEXT)) return Assets.getText(path); else {
			trace('[getContent] Cannot get the content of "$key" | Path: "$path" | Tried OpenFL Assets');
			return null;
		}
		#end
	}

	/**
		Parses an JSON, uses tjson if available 
		@param path Path to json name (e.g. 'music/ActClear')
		@return Dynamic
	**/
	public static function parseJson(path:String):Dynamic {
		#if tjson
		trace('[parseJson] Path: $path.json | Using TJSON.');
		return tjson.TJSON.parse(getContent('$path.json'));
		#else
		trace('[parseJson] Path: $path.json | Using haxe.Json.');
		return haxe.Json.parse(getContent('$path.json'));
		#end
	}
}