package backend;
/**
 * Handler for translating text and assets in the game
 * 
 * ### Functions
 * `getPhrases`, `getFileTranslation`
 * 
 * Be shure that you have a `lang` file to test your translation phrases!
 */
class Language
{
	public static var defaultLangName:String = 'English (US)'; // en-US
	#if TRANSLATIONS_ALLOWED
	private static var phrases:Map<String, String> = [];
	#end

	public static function reloadPhrases()
	{
		#if TRANSLATIONS_ALLOWED
		var langFile:String = ClientPrefs.data.language;
		var loadedText:Array<String> = Mods.mergeAllTextsNamed('data/$langFile.lang');
		// trace(loadedText);

		phrases.clear();
		var hasPhrases:Bool = false;
		for (num => phrase in loadedText)
		{
			phrase = phrase.trim();
			if (num < 1 && !phrase.contains(':'))
			{
				// First line ignores formatting and shit if the line doesn't have ":" because its language_name
				phrases.set('language_name', phrase.trim());
				continue;
			}

			if (phrase.length < 4 || phrase.startsWith('//'))
				continue;

			var n:Int = phrase.indexOf(':');
			if (n < 0) continue;

			var key:String = phrase.substr(0, n).trim().toLowerCase();

			var value:String = phrase.substr(n);
			n = value.indexOf('"');
			if (n < 0) continue;

			//trace("Mapped to " + key);
			phrases.set(key, value.substring(n + 1, value.lastIndexOf('"')).replace('\\n', '\n'));
			hasPhrases = true;
		}
		#end
	}

	/**
	 * Gets an translation phrase
	 * @param key Phrase key in `.lang` files
	 * @param defaultPhrase Phrase in English
	 * @param values Any phrase that has "`{1}`, `{2}`..." will be replaced with any
	 * value inserted following a sequence
	 * @return String
	 */
	inline public static function getPhrase(key:String, ?defaultPhrase:String, values:Array<Dynamic> = null):String
	{
		#if TRANSLATIONS_ALLOWED
		// trace(formatKey(key));
		var str:String = phrases.get(formatKey(key));
		if (str == null) str = defaultPhrase;
		#else
		var str:String = defaultPhrase;
		#end

		if (str == null)
			str = key;

		if (values != null)
			for (num => value in values)
				str = str.replace('{${num + 1}}', value);

		return str;
	}

	 /**
	 * Gets a translatable file, More optimized for file loading
	 * @param key Default file path
	 * @return String
	 * @author Sunkydev
	 */
	inline public static function getFileTranslation(key:String)
	{
		#if TRANSLATIONS_ALLOWED
		var str:String = phrases.get(key.trim().toLowerCase());
		if (str != null)
			key = str;
		#end
		return key;
	}

	#if TRANSLATIONS_ALLOWED
	inline static private function formatKey(key:String)
	{
		final hideChars = ~/[~&\\\/;:<>#.,'"%?!]/g;
		return hideChars.replace(key.replace(' ', '_'), '').toLowerCase().trim();
	}
	#end

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State)
	{
		Lua_helper.add_callback(lua, "getTranslationPhrase", function(key:String, ?defaultPhrase:String, ?values:Array<Dynamic> = null)
		{
			return getPhrase(key, defaultPhrase, values);
		});

		Lua_helper.add_callback(lua, "getTranslationFile", function(key:String)
		{
			return getFileTranslation(key);
		});
	}
	#end
}