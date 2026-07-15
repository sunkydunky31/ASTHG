package util;

@:nullSafety
class MathUtil {
	inline public static function clamp(value:Float, min:Float, max:Float):Float {
		return (value < min) ? min : (value > max ? max : value);
	}

	inline public static function clampInt(value:Int, min:Int, max:Int):Int {
		return (value < min) ? min : (value > max ? max : value);
	}
}