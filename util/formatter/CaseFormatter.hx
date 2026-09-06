/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-30
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package util.formatter;

/**
	Formats the string to `UPPERCASE` or `lowercase`
**/
class CaseFormatter extends util.StringFormatter {
	public function new(key:String) { super(key); }

	override public function apply(v:Null<Dynamic>, ?arg:String = null):String {
		v = Std.string(v);

		if (util.StringUtil.isBlank(v))
			throw new haxe.Exception("The value to format is blank!");

		return (key == "U") ? v : v.toLowerCase();
	}
}
