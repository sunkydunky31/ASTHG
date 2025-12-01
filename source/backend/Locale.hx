package backend;
/**
 * Handler for translating text and assets in the game
 * 
 * ### Functions
 * `getString`, `getFile`
 */
class Locale
{
	/**
		Gets an translation phrase
		@param key String key on files
		@param defaultPhrase Phrase in English
		@param values Any phrase that has "`{1}`, `{2}`..." will be replaced with any	
					  value inserted following a sequence
		@return String
	**/
	inline public static function getString(key:String, context:String = "data", ?values:Array<Dynamic> = null):String {
		var str:String = Main.tongue.get(formatKey(key), context, true);

		if (values != null)
			for (num => value in values)
				str = str.replace('<${num + 1}>', Std.string(value));

		return str;
	}

	/**
		Gets a translatable file, More optimized for file loading
		@param key Default file path
		@return String
		@authorTip Sunkydev31
	**/
	inline public static function getFile(key:String) {
		var str:String = Main.tongue.get(key.trim(), "files");
		if (!CoolUtil.isNullString(str)) key = str;
		return key;
	}

	inline static private function formatKey(key:String) {
		final hideChars = ~/[~&\\\/;:<>#.,'"%?!]/g;
		return hideChars.replace(key.replace(' ', '_'), '').trim().toLowerCase();
	}
}