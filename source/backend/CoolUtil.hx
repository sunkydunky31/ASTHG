package backend;

import openfl.display.BitmapData;
import flixel.sound.FlxSoundGroup;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		//trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); //prevent "shared:", "preload:" and other library names on file path
		path = formatted[formatted.length-1];
		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	public static function coolText(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
	
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}
	
		return daList;
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0) {
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if(countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
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
			if(!absolute) folder =  Sys.getCwd() + '$folder';

			folder = folder.replace('/', '\\');
			if(folder.endsWith('/')) folder.substr(0, folder.length - 1);

			#if linux
			var command:String = '/usr/bin/xdg-open';
			#elseif windows
			var command:String = 'explorer.exe';
			#end
			Sys.command(command, [folder]);
			trace('$command $folder');
		#else
			FlxG.error("Platform is not supported for CoolUtil.openFolder");
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
		final company:String = FlxG.stage.application.meta.get('company');
		// #if (flixel < "5.0.0") return company; #else
		return '${company}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
		// #end
	}

	public static function getProjectInfo(metaIndex:String) {
		return FlxG.stage.application.meta.get(metaIndex);
	}

	public static function setTextBorderFromString(text:FlxText, border:String, ?options:Array<Dynamic>)
	{
		switch(border.toLowerCase().trim())
		{
			case 'shadow':
				text.borderStyle = SHADOW;
			case 'shadow_xy', 'shadowxy':
				#if (flixel >= "5.9.0")
				if (Std.isOfType(options[0], Int) && Std.isOfType(options[1], Int))
					text.borderStyle = FlxTextBorderStyle.SHADOW_XY(options[0], options[1]);
				else
					text.borderStyle = FlxTextBorderStyle.SHADOW_XY(1, 1);
				#else
				text.borderStyle = FlxTextBorderStyle.SHADOW;
				if (Std.isOfType(options[0], Int) && Std.isOfType(options[1], Int))
					text.shadowOffset.set(options[0], options[1]);
				else
					text.shadowOffset.set(1, 1);
				#end
			case 'outline':
				text.borderStyle = OUTLINE;
			case 'outline_fast', 'outlinefast':
				text.borderStyle = OUTLINE_FAST;
			default:
				text.borderStyle = NONE;
		}
	}

	/**
	Noticed that loopTime uses MILLISECONDS and not SAMPLES? this converts it into ms
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
	@param sound Sound file (or name if using the MAP)
	@param fromMap see backend.Paths.hx
	@param loop Loops or not the sound
	@param volume Volume for this sound
	@param group Sound group
	@param autoDestroy 
	@param onComplete Extra params for complete
	@return FlxSound
	**/
	inline public static function playSound(sound:String, ?fromMap:Bool = false, ?loop:Bool = false, ?volume:Float = 1.0) {
		FlxG.sound.play(Paths.sound(sound, fromMap), volume, loop);
	}

	public static function makeBGGradient(colors:Array<FlxColor>, chuncks:UInt, angle:Int, interp:Bool):FlxSprite {
		return FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, colors, chuncks, angle, interp);
	}

	public static function parseBool(k:String):Bool {
		if (k == 'true')
			return true;
		else if (k == 'false')
			return false;

		return false;
	}

	public static var mus:FlxSound;

	/**
	Custom music player!
	@param sound Music name or path (starting from "assets/shared/music" or "[mod]/music")
	@param loopStart Loops the music or not.
	Usage: `{ sample: Your Sample, hz: Hz of your track }`
	Settings: `0` -> No loop, `1` -> loop from start, `*another value*` -> loop in the given sample
	@param volume Volume to play `this` music
	@param group Sets a sound group for `this` music
	**/
	public static function playMusic(sound:String, loopStart:SoundLoop, ?volume:Float = 1.0, ?group:FlxSoundGroup) {

		if (mus == null) { mus = new FlxSound(); }
		else if (mus.active) { mus.stop(); }
		
		mus.loadEmbedded(Paths.music(sound));
		switch (loopStart.sample) {
		case 0:
			mus.looped = false;
			//trace("Cur music will not loop");
		case 1:
			mus.looped = true;
			//trace("Cur music will loop from start");
		case v if (v > 1):
			mus.looped = true;
			mus.loopTime = CoolUtil.getSampleLoop(loopStart.sample, (loopStart.hz == null) ? 44100 : loopStart.hz);
			//trace("Cur music will loop in " + mus.loopTime);
		}
		mus.volume = volume;
		mus.persist = true;
		group = (group == null) ? FlxG.sound.defaultMusicGroup : group;
		mus.play();
	}

	/**
	 * Switches S2 Sonic colors into a char palette index!
	 * @param sprite Sprite to apply the palette
	 * @param palIndex Palette array index to use
	 * 
	 * Note that the character must be added or loaded to work
	 */
	public static function applyPalette(sprite:FlxSprite, pal:Array<FlxColor>) {
		//trace(Constants.PALETTE_OVERRIDE.length);
		var bmp = sprite.pixels;
		for (y in 0...bmp.height) {
				for (x in 0...bmp.width) {
						var px = bmp.getPixel(x, y);
						trace('Pixel ($x,$y) = 0x' + StringTools.hex(px, 8));
				}
		}
		for (i in 0...Constants.PALETTE_OVERRIDE.length - 1) {
			sprite.replaceColor(Constants.PALETTE_OVERRIDE[i], pal[i]);
		}
	}

	public static function readEnv(path:String = ".env"):Map<String,String> {
		var m = new Map<String,String>();
		if (!sys.FileSystem.exists(path)) return m;
		else throw "Env file doesn't even exists!";
		for (line in sys.io.File.getContent(path).split('\n')) {
			var l = line.trim();
			if (l == "" || l.startsWith("#")) continue;
			var parts = l.split("=");
			if (parts.length >= 2) {
				var k = parts.shift().trim();
				var v = parts.join("=").trim();
				m.set(k, v);
			}
		}
		return m;
	}


}

typedef SoundLoop = {
	sample:Int,
	?hz:Null<Int>
}
