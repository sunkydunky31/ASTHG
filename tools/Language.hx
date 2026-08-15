package tools;

import sys.io.File;
import sys.FileSystem;

using util.StringUtil;
using StringTools;

class Language {
	static var trans:Map<String, String> = new Map<String, String>(); // Store translations here
	static var curLang:String = #if (target.unicode) lime.system.Locale.currentLocale ?? "en_US" #else "en_US" #end;

	public static function load() {
		if (!FileSystem.exists('_project/translations/$curLang.txt') || curLang == null) {
			trace("Unnable to load translation data for language '" + curLang + "'!");
			return;
		}

		var file = File.getContent('_project/translations/${curLang}.txt');

		for (line => text in file.split("\n")) {
			text = text.trim();

			var sep = text.indexOf("=");

			if (sep != -1) {
				var key = text.substr(0, sep);
				var value = text.substr(sep + 1);

				trans.set(key, value);
			}
		}
	}

	inline public static function translate(key:String, ?replaces:Array<Dynamic>):String {
		var str = trans.get(key);
		str ??= key;

		if (replaces != null) {
			str = str.format(replaces);
		}

		str = str.replaceMulti(["\\n","\\t", "\\r"], ["\n", "\t", "\r"]);

		return str;
	}
}