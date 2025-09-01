package backend;

import flixel.math.FlxPoint;
import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

#if MODS_ALLOWED
import backend.Mods;
#end

enum ShaderTypes {
	VERTEX;
	FRAGMENT;
}

class Paths
{
	inline public static var SOUND_EXT = #if (web || flash) "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	/**
	Sounds of the game
	Map: [Name -> File];
	**/
	public static final SOUNDS:Map<String, String> = [
		"Menu Change" => 'menuChange',
		"Menu Accept" => 'menuAccept',
		"Menu Cancel" => 'menuCancel',
		"Jump" => "jump",
		"Ring" => "ring"
	];


	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> = ['assets/shared/music/freakyMenu.$SOUND_EXT'];
	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory() {
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys()) {
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key)) {
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) {
					// remove the key from all cache maps
					FlxG.bitmap._cache.remove(key);
					openfl.Assets.cache.removeBitmapData(key);
					currentTrackedAssets.remove(key);

					// and get rid of the object
					obj.persist = false; // make sure the garbage collector actually clears it up
					obj.destroyOnNoUse = true;
					obj.destroy();
				}
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory() {
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys()) {
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) {
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
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

	static public var currentLevel:String;
	static public function setCurrentLevel(name:String) {
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, ?type:AssetType = TEXT, ?library:Null<String> = null, ?modsAllowed:Bool = false):String {
		#if MODS_ALLOWED
		if(modsAllowed) {
			var customFile:String = file;
			if (library != null)
				customFile = '$library/$file';

			var modded:String = modFolders(customFile);
			if(FileSystem.exists(modded)) return modded;
		}
		#end

		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null) {
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, 'week_assets', currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}
		}

		return getSharedPath(file);
	}

	static public function getLibraryPath(file:String, library = "shared") {
		return (library == "shared") ? getSharedPath(file) : (library == "assets") ? getAssetsPath('$file') : getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String, ?level:String) {
		if(level == null) level = library;
		var returnPath = '$library:assets/$level/$file';
		return returnPath;
	}

	inline public static function getSharedPath(file:String = '') {
		return 'assets/shared/$file';
	}

	inline public static function getAssetsPath(file:String = '') {
		return 'assets/$file';
	}

	inline static public function shader(key:String, type:ShaderTypes, ?library:String) {
		var types:String;
		switch (type) {
			case VERTEX: types = 'vert';
			case FRAGMENT: types = 'frag';
		}

		return getPath('shaders/$key.$types', TEXT, library);
	}

	static public function video(key:String) {
		#if MODS_ALLOWED
		var file:String = modFolders('videos/$key.$VIDEO_EXT');
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return getPath('videos/$key.$VIDEO_EXT');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int)
		return sound(key + FlxG.random.int(min, max));

	inline static public function sound(key:String, ?fromMap:Bool = false):Sound
		return returnSound('sounds', fromMap ? getSound(key) : key);

	inline static public function music(key:String):Sound
		return returnSound('music', key);

	inline static public function getSound(key:String) {
	//	trace("Got sound '" + key + "' and returned '"+ SOUNDS.get(key)+"'");
		if (!SOUNDS.exists(key)) trace("FUUCK (Sound not exists");

		return SOUNDS.exists(key) ? SOUNDS.get(key) : '';
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	/**
	 * Gets a image
	 * @param key Name of the image (e.g. funkay)
	 * @param library Use another library? (Default: Shared)
	 * @param allowGPU Cache on GPU? (Default: True)
	 * @return openfl.display.BitmapData
	 */
	static public function image(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxGraphic {
		var bitmap:BitmapData = null;
		var file:String = null;

		#if MODS_ALLOWED
		file = modFolders('images/$key.png');
		if (currentTrackedAssets.exists(file)) {
			localTrackedAssets.push(file);
			return currentTrackedAssets.get(file);
		}
		else if (FileSystem.exists(file))
			bitmap = BitmapData.fromFile(file);
		else
		#end {
			file = getPath(Language.getFileTranslation('images/$key') + '.png', IMAGE, library);
			if (currentTrackedAssets.exists(file)) {
				localTrackedAssets.push(file);
				return currentTrackedAssets.get(file);
			}
			else if (OpenFlAssets.exists(file, IMAGE))
				bitmap = OpenFlAssets.getBitmapData(file);
		}

		if (bitmap != null) {
			var retVal = cacheBitmap(file, bitmap, allowGPU);
			if(retVal != null) return retVal;
		}

		trace('File not found ($file)');
		return null;
	}

	static public function cacheBitmap(file:String, ?bitmap:BitmapData = null, ?allowGPU:Bool = true) {
		if(bitmap == null) {
			#if MODS_ALLOWED
			if (FileSystem.exists(file))
				bitmap = BitmapData.fromFile(file);
			else
			#end
			{
				if (OpenFlAssets.exists(file, IMAGE))
					bitmap = OpenFlAssets.getBitmapData(file);
			}

			if(bitmap == null) return null;
		}

		localTrackedAssets.push(file);
		if (allowGPU && ClientPrefs.data.cacheOnGPU) {
			var texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
			texture.uploadFromBitmapData(bitmap);
			bitmap.image.data = null;
			bitmap.dispose();
			bitmap.disposeImage();
			bitmap = BitmapData.fromTexture(texture);
		}
		var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, file);
		newGraphic.persist = true;
		newGraphic.destroyOnNoUse = false;
		currentTrackedAssets.set(file, newGraphic);
		return newGraphic;
	}

	static public function getContent(key:String, type:AssetType, ?ignoreMods:Bool = false) {
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key))) {
			trace("Exists in FILE SYSTEM (Mods): "+ modFolders(key));
			return File.getContent(modFolders(key));
		}
		#end

		if (FileSystem.exists(getPath(key))) {
			trace("Exists in FILE SYSTEM: "+ getPath(key), 'ignoreMods: $ignoreMods');
			return File.getContent(getPath(key));
		}

		if (currentLevel != null) {
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(key, 'week_assets', currentLevel);
				if (FileSystem.exists(levelPath))
					return File.getContent(levelPath);
			}
		}
		#end
		var path:String = getPath(key, type);
		if(OpenFlAssets.exists(path, type))
			return Assets.getText(path);
		return null;
	}

	inline static public function font(key:String) {
		var folderKey:String = Language.getFileTranslation('fonts/$key');
		return 'assets/$folderKey';
	}

	/**
	 * Gets a AngelCode bitmap font
	 * @param key Name of the font file
	 */
	inline static public function getAngelCodeFont(key:String) {
			return FlxBitmapFont.fromAngelCode('assets/fonts/$key.png', 'assets/fonts/$key.fnt');
	}

	public static function fileExists(key:String, type:AssetType, ?library:String = null, ?ignoreMods:Bool = false) {
		
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return true;
		#end

		if (FileSystem.exists(getPath(key, type, library, false)))
			return true;
		#end

		if(OpenFlAssets.exists(getPath(key, type, library, false))) {
			return true;
		}
		return false;
	}

	static public function getAtlas(key:String, ?library:String = null, ?useSparrowAtlas:Bool = true, ?allowGPU:Bool = true):FlxAtlasFrames {
		trace('Getting atlas... ');
		var useMod = false;
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);

		var myXml:Dynamic = getPath(Language.getFileTranslation('images/$key') + '.xml', TEXT, library, true);
		var myJson:Dynamic = getPath(Language.getFileTranslation('images/$key') + '.json', TEXT, library, true);
		if(OpenFlAssets.exists(myXml)) {
			return useSparrowAtlas ? FlxAtlasFrames.fromSparrow(imageLoaded, myXml) : CustomAtlasFrames.fromASTHGSparrow(imageLoaded, myXml);
		}
		else if(OpenFlAssets.exists(myJson)) {
				return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, myJson);
			}
		
		return getPackerAtlas(key, library);
	}
	
	inline static public function getMultiAtlas(keys:Array<String>, ?parentFolder:String = null, ?useSparrow:Bool = true, ?allowGPU:Bool = true):FlxAtlasFrames {
		trace('Getting MULTIATLAS');
		var parentFrames:FlxAtlasFrames = Paths.getAtlas(keys[0].trim());
		if(keys.length > 1) {
			var original:FlxAtlasFrames = parentFrames;
			parentFrames = new FlxAtlasFrames(parentFrames.parent);
			parentFrames.addAtlas(original, true);
			for (i in 1...keys.length) {
				var extraFrames:FlxAtlasFrames = Paths.getAtlas(keys[i].trim(), parentFolder, allowGPU);
				if(extraFrames != null)
				{
					parentFrames.addAtlas(extraFrames, true);
					trace('Added extra frames!');
				}
			}
		}
		return parentFrames;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var xmlExists:Bool = false;

		var xml:String = modFolders('images/$key.xml');
		if(FileSystem.exists(xml)) xmlExists = true;

		return FlxAtlasFrames.fromSparrow(imageLoaded, (xmlExists ? File.getContent(xml) : getPath(Language.getFileTranslation('images/$key') + '.xml', library)));
		#else
		return FlxAtlasFrames.fromSparrow(imageLoaded, getPath(Language.getFileTranslation('images/$key') + '.xml', library));
		#end
	}

	inline static public function getASTHGAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var xmlExists:Bool = false;

		var xml:String = modFolders('images/$key.xml');
		if(FileSystem.exists(xml)) xmlExists = true;

		return backend.CustomAtlasFrames.fromASTHGSparrow(imageLoaded, (xmlExists ? File.getContent(xml) : getPath(Language.getFileTranslation('images/$key') + '.xml', library)));
		#else
		return backend.CustomAtlasFrames.fromASTHGSparrow(imageLoaded, getPath(Language.getFileTranslation('images/$key') + '.xml', library));
		#end
	}

	inline static public function getPackerAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var txtExists:Bool = false;
		
		var txt:String = modFolders('images/$key.txt');
		if(FileSystem.exists(txt)) txtExists = true;

		return FlxAtlasFrames.fromSpriteSheetPacker(imageLoaded, (txtExists ? File.getContent(txt) : getPath(Language.getFileTranslation('images/$key') + '.txt', library)));
		#else
		return FlxAtlasFrames.fromSpriteSheetPacker(imageLoaded, getPath(Language.getFileTranslation('images/$key') + '.txt', library));
		#end
	}

	inline static public function getAsepriteAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {

		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var jsonExists:Bool = false;

		var json:String = modFolders('images/$key.json');
		if(FileSystem.exists(json)) jsonExists = true;

		return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, (jsonExists ? File.getContent(json) : getPath(Language.getFileTranslation('images/$key') + '.json', library)));
		#else
		return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, getPath(Language.getFileTranslation('images/$key') + '.json', library));
		#end
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];
	/**
	 * Return a Sound
	 * @param path Path to sound
	 * @param key Name of the sound
	 * @param library Use another library path? (Default: Shared)
	 * @param modsAllowed Allow Mods?
	 * @param beepOnNull If the sound doesn't exist, return a Flixel Beep
	 */
	public static function returnSound(path:Null<String>, key:String, ?library:String) {
		#if MODS_ALLOWED
		var modLibPath:String = '';
		if (library != null) modLibPath = '$library/';
		if (path != null) modLibPath += '$path';

		var file:String = modFolders('$modLibPath/$key.$SOUND_EXT');
		if(FileSystem.exists(file)) {
			if(!currentTrackedSounds.exists(file)) {
				currentTrackedSounds.set(file, Sound.fromFile(file));
				//trace('precached mod sound: $file');
			}
			localTrackedAssets.push(file);
			return currentTrackedSounds.get(file);
		}
		#end

		// I hate this so god damn much
		var gottenPath:String = '$key.$SOUND_EXT';
		if(path != null) gottenPath = '$path/$gottenPath';
		gottenPath = getPath(gottenPath, SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		// trace(gottenPath);
		if(!currentTrackedSounds.exists(gottenPath)) {
			var retKey:String = (path != null) ? '$path/$key' : key;
			retKey = ((path == 'songs') ? 'songs:' : '') + getPath('$retKey.$SOUND_EXT', SOUND, library);
			if(OpenFlAssets.exists(retKey, SOUND)) {
				currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(retKey));
				//trace('precached vanilla sound: $retKey');
			}
		}
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}


	#if MODS_ALLOWED
	inline static public function mods(key:String = '')
		return 'mods/$key';

	static public function modFolders(key:String)
	{
		if(Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
		{
			var fileToCheck:String = mods(Mods.currentModDirectory + '/' + key);
			if(FileSystem.exists(fileToCheck))
				return fileToCheck;
		}

		for(mod in Mods.getModDirectories())
		{
			var fileToCheck:String = mods('$mod/$key');
			if(FileSystem.exists(fileToCheck))
				return fileToCheck;
		}
		return 'mods/$key';
	}
	#end
}