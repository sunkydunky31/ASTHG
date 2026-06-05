package asthg.framework;

using util.StringUtil;

import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;

class AsthgSound extends FlxSound {
	static var tagData:Null<Xml> = null;
	public static var tags:Map<String, Dynamic> = new Map<String, Dynamic>();

	static var _soundn:String = "";
	static var _params:Null<SoundParameters> = {};

		/**
		 * Obtém o sample rate de um arquivo de áudio (WAV, OGG, MP3).
		 * @param path Caminho do arquivo de áudio.
		 * @return Sample rate ou -1 se não conseguir ler.
		 */
		public static function getSampleRate(path:String):Int {
			try {
				var bytes = sys.io.File.getBytes(path);
				// WAV
				if (bytes.length > 28 && bytes.getString(0, 4) == "RIFF" && bytes.getString(8, 4) == "WAVE") {
					// Sample rate está nos bytes 24-27 (little-endian)
					return bytes.get(24) | (bytes.get(25) << 8) | (bytes.get(26) << 16) | (bytes.get(27) << 24);
				}
				// OGG Vorbis
				if (bytes.length > 40 && bytes.getString(0, 4) == "OggS") {
					// Procura pelo cabeçalho Vorbis ("vorbis" após o OggS)
					for (i in 0...bytes.length - 36) {
						if (bytes.getString(i, 6) == "vorbis") {
							// Sample rate: 4 bytes little-endian, offset +12 após "vorbis"
							var idx = i + 12;
							return bytes.get(idx) | (bytes.get(idx+1) << 8) | (bytes.get(idx+2) << 16) | (bytes.get(idx+3) << 24);
						}
					}
				}
				// MP3 (procura primeiro frame válido)
				if (bytes.length > 4 && (bytes.get(0) == 0xFF && (bytes.get(1) & 0xE0) == 0xE0)) {
					// Tabela de sample rates para MPEG1 Layer III
					var rates = [44100, 48000, 32000, -1];
					var srIdx = (bytes.get(2) >> 2) & 0x03;
					return rates[srIdx];
				}
			} catch(e:Dynamic) {}
			return -1;
		}


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
	public static function playMusic(sound:String, ?params:SoundParameters) {
		_soundn = sound;
		_params = params;

		var asset = Paths.music(sound);

		if (Paths.fileExists('music/$sound.xml', TEXT)) {
			try {
				parseTags(Paths.getContent('music/$sound.xml') ?? "");
			}
			catch(e:Dynamic) {
				trace('Failed to parse tag data for "$sound": $e.'.error());
			}
		}
		else
			throw "The tag file doesn't exists! (music/{0}.xml)".format([sound]);

		var looped:Bool = (getTag(TagElements.LOOP) ?? false) #if (mobile && android) ||
		(getTag(TagElements.ANDROID_LOOP) ?? false) #end;

		var loopTimeVal:Float = 0;
		if (looped && tags.exists(TagElements.LOOP_SAMPLES)) {
			if ((getTag(TagElements.LOOP_SAMPLES) ?? 0) > 0) {
				var sample:Int  = (getTag(TagElements.LOOP_SAMPLES) ?? 0);
				loopTimeVal = getSampleLoop(sample);
			}
			else
				trace("Loop Sample is minor/equal than 0, skipping looping time".info());
		}

		FlxG.sound.music ??= new FlxSound();
		if (FlxG.sound.music.active) {
			FlxG.sound.music.stop();
		}

		FlxG.sound.music.loadEmbedded(asset, looped);

		// Applys metadata before playing to not break the loop
		FlxG.sound.music.looped = looped;
		if (loopTimeVal > 0)
			FlxG.sound.music.loopTime = loopTimeVal;
		FlxG.sound.music.volume = ClientPrefs.data.options.musicVolume * (params?.volume ?? 1.0);
		FlxG.sound.music.persist = (params?.persist ?? false);
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

	public static function getTag(n:Null<String>):Dynamic {
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
	inline public static function getSampleLoop(sample:Int = 0):Float {
		return ((sample ?? 0) * 1000) / getSampleRate(Paths.getPath('music/${_soundn}'));
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