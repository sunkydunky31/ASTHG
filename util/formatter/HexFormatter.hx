/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-30
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package util.formatter;

class HexFormatter extends StringFormatter {
	public function new(key:String) { super(key); }

	override public function apply(v:Null<Dynamic>, ?arg:String = null):String {
		if (v == null)
			throw new haxe.Exception("The value to format is null!");

		var padding = Std.parseInt(arg) ?? 0;

		// The gotten value
		var got = "";
		if (v is Int) {
			var r:Int = v;
			got = StringTools.hex(r, padding);
		}
		else if (v is Float) {
			var r:Float = v;
			got = StringUtil.hexFloat(v, padding);
		}
		else {
			throw new haxe.Exception("Value is not Int or Float!");
		}

		return (key == "x") ? got.toLowerCase() : got;
	}
}
