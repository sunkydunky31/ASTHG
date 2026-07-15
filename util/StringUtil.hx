package util;

#if flixel
import flixel.util.FlxStringUtil;
#end

import StringBuf;
using StringTools;

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
		@author ??? (Maybe ShadowMario?- Idk who made it.)
	**/
	inline public static function capitalize(text:String):String {
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
	}

	/**
		The capitalize function, but inversed! Makes the first Letter lowercase and the rest of the string uppercase
		@param text Text to inverse capitalize
		@return String
	**/
	inline public static function inverseCapitalize(text:String):String {
		return text.charAt(0).toLowerCase() + text.substr(1).toUpperCase();
	}

	/**
		Converts a string to snake_case, replacing spaces with underscores,
		returns `Empty` if the `s` is null/empty
		NOTE: The string is not formatted to lower case
		@param text Your string
		@return String
	**/
	inline public static function toSnakeCase(s:String):String {
		if (isBlank(s)) return "";
		return s.replace(" ", "_");
	}

	/**
		Converts a string to kebab-case
		NOTE: The string is not formatted to lower case
		@param text Your string
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
	inline public static function isBlank<T>(s:String):Bool {
		return @:nullSafety(Off) (s == null || s.trim().length <= 0); // Depending on target, we can get -1
	}

	/**
		Formats the string allowing to use placeholders in it
		.NET Styled

		Placeholder format: `{index}` OR `{index:modifier[X]}`
		e.g.: `{0:X}` -> Placeholder `Index 0`, Modifier `Int/Float to Hex`

		Usage example:
		```haxe
		trace(StringUtil.format("I have {0} years old.", 5752));
		// Return: I have 5752 years old.

		// With "using" instead of "import"

		using StringUtil;

		class Main {
			public static function main()
				trace("Gotten color: #{0:x}", 0xFFFF00);
				//Returns: "Gotten color: #ffff00"
				// It's the same as `trace("Gotten color: #" + StringTools.hex(0xFFFF00)`, but with support to Float type.
		}
		```

		@param str   The string to format
		@param values If a placeholder is found, replace it with the value in this parameter
		@return Bool
	**/
	public static function format(str:String, values:Array<Dynamic>):String {
		// HOLY SHIT, I LOVED MAKING THIS FUNCTIONAL!!! YAAYY!

		if (isBlank(str))
			throw "The String is null/empty to format it!";
		else if (ArrayUtil.isBlank(values))
			throw "`values` parameter is null/empty! Did you forget to insert a value in here?";

		#if cs
		return untyped String.Format(str, values);
		#else
		return StringFormat.format(str, values);
		#end
	}

	/**
		-- Edited version of FlxStringUtil.formatTime to show a "Sonic" time format --

		Format seconds as minutes with a colon, an optionally with milliseconds too.

		@param	Seconds     The number of seconds (for example, time remaining, time spent, etc).
		@param	ShowMS      Whether to show milliseconds after a `"` as well.  @default -> false.
		@return	A nicely formatted String, like `1:03` or `5'19"43`.
	**/
	public static function formatTime(Seconds:Float, ShowMS:Bool = false):String {
		var str = "";
		var minSplit = ShowMS ? "'" : ":";
		var secSplit = '"';

		var min  = Std.int(Seconds / 60);
		var sec  = Std.int(Seconds) % 60;
		var msec = Std.int((Seconds - Std.int(Seconds)) * 100);

		str = StringTools.lpad(Std.string(min), "0", 1) + minSplit + StringTools.lpad(Std.string(sec), "0", 2);

		if (ShowMS)
		{
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
			v = Math.floor(v/16);
		} while (v > 0);

		if (digits != null)
			s = StringTools.lpad(s, "0", digits);

		return s;
	}

	public static function replaceMulti(s:String, sub:Array<String>, by:Array<String>) {
		if (by.length != sub.length)
			throw "`by` argument is not the same length as `sub`.";

		for (i in 0...sub.length) {
			s = s.replace(sub[i], by[i]);
		}

		return s;
	}
}

/**
	Dedicated class for parsing Placeholders in .NET style
	format: `{index[:modifier[amount]]}`
**/
class StringFormat {
	// Redundant? Yes, but its here to you personalize it
	static final PLACEHOLDER_START:String    = "{";
	static final PLACEHOLDER_MODIFIER:String = ":";
	static final PLACEHOLDER_END:String      = "}";

	static var _str:String = "";
	static var _args:Array<Dynamic> = [];

	public static function format(str:String, args:Array<Dynamic>):String {
		var f = new StringBuf();
		var i = 0;

		_str = str ?? "No string";
		_args = args;

		while ((i = str.indexOf(PLACEHOLDER_START, i)) != -1) {
			var end = str.indexOf(PLACEHOLDER_END, i);
			var content = str.substring(i + 1, end);
			var modifier = content.indexOf(PLACEHOLDER_MODIFIER);

			var index:Int;
			var modV:String = "";
			var modN:Null<Float> = null;

			if (!content.contains(PLACEHOLDER_MODIFIER)) {
				index = Std.parseInt(content);
			}
			else {
				index = Std.parseInt(content.substring(0, modifier));
				modV = content.substr(modifier + 1, 1).trim();
				modN = Std.parseFloat(content.substr(modifier + 2));
			}

			f.addSub(str, 0, i);
			f.add(modApply(args[index], modV, modN));
			str = str.substring(end + 1);
			i = 0;
		}

		return f + str;
	}

	/**
		Applys text formating into placeholders
		@param v Value to format
		@param m The modifier to apply
		@return String
	**/
	static function modApply(v:Dynamic, m:String, n:Float):String {
		if (StringUtil.isBlank(m))
			return Std.string(v);

		// List of modifiers, add new ones here
		switch (m.toUpperCase()) {
			case s if (s.startsWith("X")): // Hex Number (add a number to set the length)
				if (!Std.isOfType(v, Int) && !Std.isOfType(v, Float)) {
					trace("Invalid value type for 'HEX' format, expected Int/Float.");
					return Std.string(v);
				}

				var digits = (n > 1) ? n : 1;
				trace('Digits: $digits');
				var ret:String = Std.isOfType(v, Int) ? StringTools.hex(v, Std.int(digits)) : StringUtil.hexFloat(v, Std.int(digits));

				return (m == "X") ? ret.toLowerCase() : ret;
			case "U": // Uppercase
				return Std.string(v).toUpperCase();
			case "L": // Lowercase
				return Std.string(v).toLowerCase();
			case "C": // Currency - only if on Flixel
			#if flixel
				return FlxStringUtil.formatMoney(Std.parseInt(v));
			#else
				trace("Formatting strings into Currency is not supported.");
				return Std.string(v);
			#end
			default:
				return Std.string(v);
		}
	}
}