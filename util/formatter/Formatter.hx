/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-30
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package util.formatter;

/**
	Base class used to create more formatters

	Ignore this class, until you want to add more of them.
**/
class Formatter extends util.StringFormatter {
	public function new() { super(); }

	override public function apply(v:String, ?arg:String = null):String {
		return v;
	}
}
