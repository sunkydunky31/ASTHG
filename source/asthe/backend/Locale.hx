package asthe.backend;

import firetongue.FireTongue;

using util.StringUtil;

/**
	Handler for translating text and assets in the game

	@author Sunnydev31 (unreal.sunnydev)
**/
class Locale {
	public static var tongue:Null<FireTongue> = null;

	/**
		Gets an translation phrase
		@param key String key on files
		@param defaultPhrase Phrase in English
		@param values Any phrase that has "`{1}`, `{2}`..." will be replaced with any value inserted following a sequence
		@return String
	**/
	inline public static function getString(key:String, context:String = "data", ?values:Array<Dynamic>):String {

		if (key.isBlank()) return "[!]";

		var str:String = "";

		if (tongue != null)
			str = tongue.get(formatKey(key), context, true);


		if (!ArrayUtil.isBlank(values) && tongue != null){
			str = str.format(values);
		}

		if (str == formatKey(key)) {
			trace("Context '{0}' has a file with missing flags! ({1})".warn(), context, key);
		}

		return str;
	}

	/**
		Gets a translatable file, More optimized for file loading
		@param key Default file path
		@param extension File extension to add ("txt", "png"...), "." will be added automatically
		@return String
	**/
	inline public static function getFile(key:String, ?extension:String = "") {
		var str:String = tongue.get(key.trim(), "files");

		if (StringUtil.isBlank(str))
			str = key;

		if (!StringUtil.isBlank(extension))
			str += "." + extension;

		return str;
	}

	inline static private function formatKey(key:String) {
		final hideChars = ~/[~&\\\/;:<>#.,'"%?!]/g;
		return hideChars.replace(key.replace(' ', '_'), '').trim().toLowerCase();
	}

	public static function init() {
		tongue ??= new FireTongue(OPENFL, Case.Unchanged);

		tongue.initialize({
			locale: (ClientPrefs.data.options.language ?? Constants.LANGUAGE_DEFAULT),
			replaceMissing: true,
			checkMissing: true,
			finishedCallback: onLoad
		});
	}

	/** Callback when FireTongue loads the locale. **/
	public static function onLoad():Void {
		trace("Loaded! Locale is {0}".info(), tongue.locale);
	}
}