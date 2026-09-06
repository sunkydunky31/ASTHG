/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-30
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package util;

import util.formatter.HexFormatter;
#if flixel
import flixel.util.FlxStringUtil;
#end
import StringBuf;

using StringTools;

import haxe.Rest;

/**
	Contains tools for string manipulation and formatting
	@author Sunnydev31 (unreal.sunnydev)
**/
@:nullSafety
class StringUtil {
	/**
		Capitalizes the first letter of the string and makes the rest of the string lowercase
		@param text
		@return String
		@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/CoolUtil.hx#L41
		@author ???
	**/
	inline public static function capitalize(text:String):String {
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
	}

	/**
		The capitalize function, but inversed! Makes the first Letter
		lowercase and the rest of the string uppercase
		@param text Text to inverse capitalize
		@return String
	**/
	inline public static function inverseCapitalize(text:String):String {
		return text.charAt(0).toLowerCase() + text.substr(1).toUpperCase();
	}

	/**
		Converts a string to snake_case, replacing spaces with underscores,
		returns `Empty` (`""`) if the `s` is null/empty
		NOTE: The string is not formatted to lower case
		@param s Your string
		@return String
	**/
	inline public static function toSnakeCase(s:String):String {
		if (isBlank(s)) return "";
		return s.replace(" ", "_");
	}

	/**
		Converts a string to kebab-case
		returns `Empty` (`""`) if the `s` is null/empty
		NOTE: The string is not formatted to lower case
		@param s Your string
		@return String
	**/
	inline public static function toKebabCase(s:String):String {
		if (isBlank(s)) return "";
		return s.replace(" ", "-");
	}

	/**
		Checks if `s` is `null` or `empty`, maybe compatible with `@:nullSafety`

		@param s The string to check
		@return Bool
	**/
	inline public static function isBlank<T:Null<String>>(s:T):Bool {
		return @:nullSafety(Off) (s == null || s.trim().length <= 0 || Std.string(s) == "null"); // Depending on target, we can get -1
	}

	/**
		Formats the string allowing to use placeholders in it
		.NET Styled

		Placeholder format: `{index}` OR `{index:modifier[X]}`
		e.g.: `{0:X}` -> Placeholder `Index 0`, Modifier `Int/Float to Hex`

		Usage example:
		```haxe
		trace(StringUtil.format("I have {0} years old.", [5752]));
		// Return: I have 5752 years old.


		// With "using" instead of "import"
		using StringUtil;

		class Main {
			public static function main()
				trace("Gotten color: #{0:x}".format(0xFFFF00));
				//Returns: "Gotten color: #ffff00"
				// It's the same as `trace("Gotten color: #" + StringTools.hex(0xFFFF00)`, but with support to Float type.
		}
		```

		@param str    The string to format
		@param values If a placeholder is found, replace it with the value in this parameter
		@return Bool
	**/
	public static function format(str:String, values:haxe.Rest<Dynamic>):String {
		// HOLY SHIT, I LOVED MAKING THIS FUNCTIONAL!!! YAAYY!

		if (isBlank(str))
			throw "The String is blank to format it!";
		else if (ArrayUtil.isBlank(values.toArray()))
			throw "'values' parameter is blank! Did you forget to insert a value in here?";

		#if cs
		return untyped String.Format(str, values);
		#else // Parse placeholders here
		var f = new StringBuf();
		var i = 0;

		while ((i = str.indexOf("{", i)) != -1) {
			var end = str.indexOf("}", i);
			var content = str.substring(i + 1, end);
			var modifier = content.indexOf(":");

			var index:Int; // Placeholder index (`{index}`)
			var modKey:String = ""; // Placeholder modifier key (`{index:modKey}`)
			var modArg:String = ""; // Placeholder modifier argument (`{index:modKey` + modArg}`)

			if (modifier == -1) {
				index = Std.parseInt(content) ?? 0;
			}
			else {
				index = Std.parseInt(content.substring(0, modifier)) ?? 0;
				modKey = content.substr(modifier + 1, 1).trim();
				modArg = content.substr(modifier + 2).trim();
			}

			// Polymorphism: Add all formatters here to return the formatted string!
			var formatter:StringFormatter = switch(modKey) {
				case "X" | "x": new util.formatter.HexFormatter(modKey);
				case "U" | "u": new util.formatter.CaseFormatter(modKey);
				//case "C": new util.formatter.Formatter();
				default: new StringFormatter(modKey);
			}

			f.addSub(str, 0, i);
			f.add(formatter.apply(values[index], modArg));
			str = str.substring(end + 1);
			i = 0;
		}

		return f + str;
		#end
	}

	/**
		-- Edited version of FlxStringUtil.formatTime to show a "Sonic" time format --

		Format seconds as minutes with a colon, an optionally with milliseconds too.

		@param	Seconds     The number of seconds (for example, time remaining, time spent, etc).
		@param	ShowMS      Whether to show milliseconds after a `"` as well.  @default `false`.
		@return	A nicely formatted String, like `1:03` or `5'19"43`.
	**/
	public static function formatTime(Seconds:Float, ShowMS:Bool = false):String {
		var str = "";
		var minSplit = ShowMS ? "'" : ":";
		var secSplit = '"';

		var min = Std.int(Seconds / 60);
		var sec = Std.int(Seconds) % 60;
		var msec = Std.int((Seconds - Std.int(Seconds)) * 100);

		str = StringTools.lpad(Std.string(min), "0", 1) + minSplit + StringTools.lpad(Std.string(sec), "0", 2);

		if (ShowMS) {
			str += secSplit + StringTools.lpad(Std.string(msec), "0", 2);
		}

		return str;
	}

	/**
		Formats a `Float` into `Hex` values

		Very similar with `StringTools.hex`
		@param n The Float to parse
		@param digits How many digits right to pad.
		@return String
	**/
	public static function hexFloat(n:Float, ?digits:Int):String {
		var s = "";
		var hexChars = "0123456789ABCDEF";
		var v = n;

		do {
			var digit = Std.int(v % 16);
			s = hexChars.charAt(digit) + s;
			v = Math.floor(v / 16);
		} while (v > 0);

		if (digits != null)
			s = StringTools.lpad(s, "0", digits);

		return s;
	}

	/**
		Function to replace multiple String values to another multiple ones
		@param s Base string to replace
		@param sub Value to be replaced
		@param by Value to replace by
		@return String
	**/
	public static function replaceMulti(s:String, sub:Array<String>, by:Array<String>):String {
		if (by.length != sub.length)
			throw "'by' argument is not the same length as 'sub'.";

		for (i in 0...sub.length) {
			s = s.replace(sub[i], by[i]);
		}

		return s;
	}

	/**
		Function to get the first longest String from a list of Strings

		EXAMPLE:
		```haxe
		var long = StringUtil.getLongest(["the", "longest", "string"]);
		trace(long) // -> longest

		var b = StringUtil.getLongest(["Haxe", "OpenFL", "Flixel"]);
		trace(b) // -> OpenFL, because its the first longest string
		```

		@param a The list of Strings to use
		@return String
	**/
	public static function getLongest(a:Array<String>):String {
		var s:String = "";

		for (t in a) {
			if (t.length > s.length) {
				s = t;
			}
		}

		return s;
	}
}
