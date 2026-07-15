package tools;

import sys.io.File;
import sys.FileSystem;

using util.StringUtil;
using StringTools;

class Language {
	static var trans:Map<String, String> = new Map<String, String>(); // Store translations here
	static var curLang:String = lime.system.Locale.currentLocale;

	public static function load() {

		if (!FileSystem.exists('_project/translations/$curLang.txt') || curLang == null) {
			curLang = "en_US";
		}

		var file = File.getContent("_project/translations/" +
		#if (target.unicode) curLang #else "en_US" #end
		+ ".txt");

		var reg = ~/^(\w+)=(.*)$/ig;
		for (line => text in file.split("\n")) {
			if (reg.match(text)) {
				trans.set(StringTools.trim(reg.matched(1)), StringTools.trim(reg.matched(2)));
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