package asthg.framework;

using util.StringUtil;

import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;
import openfl.media.Sound;

class AsthgSound extends FlxSound {
	static var tagData:Null<Xml> = null;
	public static var tags:Map<String, Dynamic> = new Map<String, Dynamic>();

	public static var sampleRate:Int = 44100;

	static var _soundn:String = "";
	static var _params:Null<SoundParameters> = {};

	private static var oflSound:Sound;

	/**
		Plays a sound
		@param sound Sound file
		@param loop Loops or not the sound
		@param volume Volume for this sound
		@return FlxSound
		@author Sunnydev31 (@unreal.sunnydev)
	**/
	inline public static function playSound(sound:String, ?params:SoundParameters) {
		_soundn = sound;
		_params = params;

		FlxG.sound.play(Paths.sound(sound), ClientPrefs.data.options.sfxVolume * (params?.volume ?? 1.0), (params?.loop ?? false));
	}

	/**
		Custom music player!
		@param sound Music name or path
		@param volume Volume to play `this` music
		@param group Sets a sound group for `this` music
		@author Sunnydev31 (@unreal.sunnydev)
	**/
	public static function playMusic(sound:String, ?params:SoundParameters) {_soundn = sound;
		_params = params;

		var asset = Paths.music(sound);

		var OFLSound:OpenFLSound = OpenFLSound.fromAudioBuffer(lime.media.AudioBuffer.fromFile(Paths.getPath('music/$sound.${Constants.SOUND_EXT}', MUSIC)));

		if (Paths.fileExists('music/$sound.xml', TEXT)) {
			try {
				parseTags(Paths.getContent('music/$sound.xml') ?? "");
			}
			catch(e:Dynamic) {
				trace('Failed to parse tag data for "{0}": {1}.'.error(), sound, e);
			}
		}
		else
			throw "The tag file doesn't exists! (music/{0}.xml)".format([sound]);

		var looped:Bool = (getTag(TagElements.LOOP) ?? false) #if (mobile && android) ||
		(getTag(TagElements.ANDROID_LOOP) ?? false) #end;

		var loopTimeVal:Float = 0;
		var sample:Int  = (getTag(TagElements.LOOP_SAMPLES) ?? 0);
		if (looped && sample > 0) {
			loopTimeVal = getSampleLoop(sample, OFLSound.sampleRate);
		}
		else {
			trace("Loop Sample is minor/equal than 0, skipping looping time".info());
		}

		if (FlxG.sound?.music == null)
			FlxG.sound.music = new FlxSound();
		else if (FlxG.sound?.music?.active)
			FlxG.sound.music.stop();

		FlxG.sound.music.loadEmbedded(asset, looped);

		// Applys metadata before playing to not break the loop
		FlxG.sound.music.looped = looped;
		if (loopTimeVal > 0)
			FlxG.sound.music.loopTime = loopTimeVal;
		FlxG.sound.music.volume = ClientPrefs.data.options.musicVolume * (params?.volume ?? 1.0);
		FlxG.sound.music.persist = (params?.persist ?? true);
		FlxG.sound.music.group = (params?.group ?? FlxG.sound.defaultMusicGroup);

		if (params?.onComplete != null) {
			FlxG.sound.music.onComplete = params.onComplete;
		}

		FlxG.sound.music.play();
	}

	/**
		Parses a XML Tag data exported from Audacity, yes, from Audacity.
		@param xml The XML data string
		@author Sunnydev31 (@unreal.sunnydev)
	**/
	public static function parseTags(xml:String):Void {
		if (StringUtil.isBlank(xml))
			return;

		try {
			tagData = Xml.parse(xml);
		}
		catch (e:Dynamic) {
			trace('Failed when parsing song tags: $e'.error());
			tagData = null;
			return;
		}

		if (tagData == null) {
			trace("XML data is null!");
			return;
		}

		tagData = tagData.firstElement();

		if (tagData == null) {
			trace("XML first element is null!");
			return;
		}

		try {
			for (i in tagData.elements()) {
				if (i.exists("name") && i.exists("value")) {
					var name = i.get("name"), value = i.get("value");
					setTag(name, value);
				}
				else {
					trace('Name/Value doesn\'t exists for [$i] or there\'s an error in the tag!');
					return;
				}
			}
		}
		catch(e:Dynamic)
			trace('Failed parsing elements: $e'.error());
	}

	public static function setTag(n:String, v:Dynamic):Void {
		if (StringUtil.isBlank(n)) {
			trace('Tag name is null/empty! ($n)'.warn());
			return;
		}

		// -- Value normalizer -- //
		if (v == null || Std.string(v).trim() == "" || (Std.isOfType(v, Array) && v.length <= 0))
			trace('Value for tag "$n" is null/empty!'.warn());

		v = switch (n) {
			case TagElements.LOOP #if (mobile && android) | TagElements.ANDROID_LOOP #end:
				CoolUtil.parseBool(v);
			case TagElements.LOOP_SAMPLES | TagElements.HEARTZ | TagElements.YEAR :
				Std.parseInt(v);
			case _: v;
		}

		try {
			tags.set(n, v);
		}
		catch (e:Dynamic) {
			trace('Error on set tag: $e'.error());
		}
	}

	public static function getTag(n:Null<String>):Null<Dynamic> {
		if (n == null || n.trim().length <= 0) {
			trace('Tag name is null/empty! ($n)'.warn());
			return null;
		}

		if (!tags.exists(n)) {
			trace('Tag "$n" doesn\'t exists!'.warn());
			return null;
		}

		return tags.get(n);
	}

	/**
		Noticed that loopTime uses MILLISECONDS and not SAMPLES? this converts it into `ms`
		@param sample Sample of your track
		@return Float
		@author Sunnydev31 (@unreal.sunnydev)
	**/
	inline public static function getSampleLoop(sample:Int = 0, hz:Int = 44100):Float {
		return ((sample ?? 0) * 1000) / hz;
	}
}

/**
	Parameters for sound playing
**/
typedef SoundParameters = {

	/**
		Loops or not the sound
		Redundant for `MUSIC` type.
	**/
	var ?loop:Bool;

	/**
		Volume for this sound.
	**/
	var ?volume:Float;

	/**
		Should this sound persists per state?
	**/
	var ?persist:Bool;

	/**
		Sets a sound group for this sound.
	**/
	var ?group:FlxSoundGroup;

	/**
		Function event that executes when the sound finishes.
	**/
	var ?onComplete:Void->Void;
}

/**
	List of tag elements for music data following Audacity's export format,
	this is only used since we can't load tag data from OGG Vorbis files... or we can?
**/
enum abstract TagElements(String) to String from String {
	/**
		Determines the title of the track
	**/
	var TITLE = "TITLE";

	/**
		Determines the artist/composer of the track

		We don't use "COMPOSER" tag because it could be redundant and most tracks uses "ARTIST" instead.
	**/
	var ARTIST = "ARTIST";

	/**
		Determines the album of this track
	**/
	var ALBUM = "ALBUM";

	/**
		Determines the album artist of this track
	**/
	var ALBUMARTIST = "ALBUMARTIST";

	/**
		Determines the genre of this track
	**/
	var GENRE = "GENRE";

	/**
		Determines the year date of this track
	**/
	var YEAR = "YEAR";

	/**
		Determines the track number of this track
	**/
	var TRACK = "TRACK";

	/**
		Custom element that determines if the track should loop or not
	**/
	var LOOP = "LOOP";

	/**
		Custom element that determines the sample to loop, only if `LOOP` is set to `true`
		This is converted into `ms` for Flixel to understand
	**/
	var LOOP_SAMPLES = "LOOP_SAMPLES";

	/**
		Custom element that defines the heartz of the track
		Used for sample looping
	**/
	var HEARTZ = "HEARTZ";

	#if (mobile && android)
	/**
		Special tag data used for Android platform that loops the track
		NOTE: If this is found as `true`, the `LOOP` tag will be set to true!
	**/
	var ANDROID_LOOP = "ANDROID_LOOP";
	#end
}