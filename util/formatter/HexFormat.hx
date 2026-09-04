/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-30
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package util.formatter;

class HexFormatter extends StringFormatter {
	public function new() { super(); }

	override public function apply(v:String, ?arg:String = null):Null<String> {
		if (StringUtil.isBlank(v)) return null;
		var padding = Std.parseInt(arg) ?? 0;

		if (StringTools.contains(v, ".")) {
			var r = Std.parseInt(v);
			return StringTools.hex(r, padding);
		}
		else {
			var r = Std.parseFloat(v);
			return StringUtil.hexFloat(r, padding);
		}

		return v;
	}
}
