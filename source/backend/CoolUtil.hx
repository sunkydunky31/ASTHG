package backend;

import openfl.display.BitmapData;
import flixel.sound.FlxSoundGroup;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float) {
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		//trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	/**
		Checks if `string` is `null` or empty

		@param string The string to check
	**/
	inline public static function isNullString(string:String):Bool {
		if (string != null || string != "") {
			return false;
		}

		trace('[isNullString] String \'$string\' is Null or Empty!');
		return true;
	}

	inline public static function coolTextFile(path:String):Array<String> {
		var daList:String = null;

		if (Paths.fileExists(path, TEXT)) daList = Paths.getContent(path);
		trace('[coolTextFile] Path: $path | Exists: ${Paths.fileExists(path, TEXT)}');

		return daList != null ? listFromString(daList) : [];
	}

	public static function coolText(path:String):Array<String> {
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
	
		for (i in 0...daList.length)
			daList[i] = daList[i].trim();
	
		return daList;
	}

	inline public static function colorFromString(color:String):FlxColor {
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String> {
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float {
		if(decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int> {
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	inline public static function openFolder(folder:String, absolute:Bool = false) {
		#if sys
			if(!absolute) folder =  Sys.getCwd() + folder;

			folder = folder.replace('/', '\\');
			if(folder.endsWith('/')) folder.substr(0, folder.length - 1);

			#if linux
			var command:String = '/usr/bin/xdg-open';
			#elseif windows
			var command:String = 'explorer.exe';
			#end

			#if (windows || linux)
			Sys.command(command, [folder]);
			trace('$command $folder');
			#end
		#else
			FlxG.log.error("Platform is not supported for CoolUtil.openFolder");
		#end
	}

	/**
		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		final company:String = getProjectInfo('company');
		// #if (flixel < "5.0.0") return company; #else
		return '$company/${flixel.util.FlxSave.validate(getProjectInfo('file'))}';
		// #end
	}

	public static function getProjectInfo(metaIndex:String) {
		return FlxG.stage.application.meta.get(metaIndex);
	}

	/**
		Noticed that loopTime uses MILLISECONDS and not SAMPLES? this converts it into `ms`
		@param sample Sample of your track
		@param hz Hz of the file track, needs to be an entire Hz of the file, defaults to 44100
		@return Float
	**/
	inline public static function getSampleLoop(sample:Int, ?hz:Int = 44100):Float {
		var loop:Float = sample*1000;
		//trace('[getSampleLoop] Sample is ${loop/hz}');
		return loop/hz;
	}
	
	/**
		Plays a sound
		@param sound Sound file
		@param loop Loops or not the sound
		@param volume Volume for this sound
		@return FlxSound
	**/
	inline public static function playSound(sound:String, ?loop:Bool = false, ?volume:Float = 1.0) {
		FlxG.sound.play(Paths.sound(sound), volume, loop);
	}

	public static function makeBGGradient(colors:Array<FlxColor>, chuncks:UInt, angle:Int, interp:Bool):FlxSprite {
		return FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, colors, chuncks, angle, interp);
	}

	/**
		Parses an String and convert it into a Bool
		@param k 
		@return Null<Bool> (Bool->false if invalid value)
	**/
	public static function parseBool(k:String):Bool {
		if (k == 'true')
			return true;
		else if (k == 'false')
			return false;

		return false;
	}

	public static var musJson:Dynamic;

	/**
		Custom music player!
		@param sound Music name or path
		@param volume Volume to play `this` music
		@param group Sets a sound group for `this` music
	**/
	public static function playMusic(sound:String, ?volume:Float = 1.0, ?group:FlxSoundGroup) {
		var asset = Paths.music(sound);

		var musJson:Dynamic = null;
		if (Paths.fileExists('music/$sound.json', TEXT))
			musJson = Paths.parseJson('music/$sound');
		else {
			trace('[playMusic] No metadata found for music "$sound".');
			musJson = {
				name: sound,
				artist: "Unknown",
				album: "Unknown",

				loop: false,
				loopStart: 0
			};
		}

		var looped:Bool = (Reflect.hasField(musJson, "loop") && musJson.loop == true);
		var loopTimeVal:Float = 0;
		if (looped && Reflect.hasField(musJson, "loopStart")) {
			var hz:Int = (Reflect.hasField(musJson, "heartz") && musJson.heartz != null) ? musJson.heartz : 44100;
			loopTimeVal = CoolUtil.getSampleLoop(musJson.loopStart, hz);
		}

		if (FlxG.sound.music == null) FlxG.sound.music = new FlxSound();
		if (FlxG.sound.music.active) FlxG.sound.music.stop();

		FlxG.sound.music.loadEmbedded(asset, looped);

		// Applys metadata before playing to not break the loop
		FlxG.sound.music.looped = looped;
		FlxG.sound.music.loopTime = loopTimeVal;
		FlxG.sound.music.volume = volume;
		FlxG.sound.music.persist = true;
		FlxG.sound.music.group = (group == null) ? FlxG.sound.defaultMusicGroup : group;

		FlxG.sound.music.play();
    }

	/**
		Switches a global color into a custom color
		@param sprite Sprite to apply the palette
		@param pal The colors to replace in order, Must match the length of the for-loop on the function

		Note that the character must be added or loaded to work
	**/
	public static function applyPalette(sprite:FlxSprite, pal:Array<FlxColor>) {
		for (i in 0...Constants.PALETTE_OVERRIDE.length) {
			sprite.replaceColor(Constants.PALETTE_OVERRIDE[i], pal[i]);
		}
	}
}

