/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-30
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package util;

/**
	Utiliy class dedicated to formatting strings
**/
class StringFormatter {
	public var key:String = "";
	public function new(key:String) { this.key = key; }

	/**
		Apply the string formatting
		@param value The string to format
		@param arg Optional arguments to use
		@return Null<String>
	**/
	public function apply(value:Null<Dynamic>, ?arg:String):String {
		return Std.string(value);
	}
}
