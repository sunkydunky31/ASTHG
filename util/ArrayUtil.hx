package util;

class ArrayUtil {
	/**
		Checks if an array is null or empty, maybe compatible with Null Safety

		@param arr The array to check
		@return Bool
		@author Sunnydev31 (unreal.sunnydev)
	**/
	inline public static function isBlank<T>(arr:Null<Array<Dynamic>>):Bool {
		return @:nullSafety(Off) (arr == null || arr.length == 0);
	}

	/**
		--- DESCRIPTION ---
		Makes a array that parses into a FlxRect

		--- EXAMPLE ---
		```haxe
		var rect:FlxRect = ArrayUtil.toRect([0, 0, 100, 100]);
		// Returns: FlxRect.new(0, 0, 100, 100);
		```
		@param arr Your rect values [X, Y, Width, Height]
		@return FlxRect
		@author Sunnydev31 (unreal.sunnydev)
	**/
	#if flixel
	public static function toRect(arr:Array<Float>):flixel.math.FlxRect
	#else
	public static function toRect(arr:Array<Float>):{x:Float,y:Float,width:Float,height:Float}
	#end
	{
		if (arr.length < 4)
			throw "Array must have at least 4 values to convert to FlxRect";
		else if (arr.length > 4)
			trace("WARNING: Array has more than 4 values, the other ones will be ignored!");
		#if flixel
		return new flixel.math.FlxRect(arr[0], arr[1], arr[2], arr[3]);
		#else
		return {x: arr[0], y: arr[1], width: arr[2], height: arr[3]};
		#end
	}

	/**
		Makes a array that parses into a Point/Vector2 object

		@param arr Your point values [X:Float, Y:Float]
		@return FlxPoint / Dynamic {x, y}
		@author Sunnydev31 (unreal.sunnydev)
	**/
	#if flixel
	public static function toPoint(arr:Array<Float>):flixel.math.FlxPoint
	#else
	public static function toPoint(arr:Array<Float>):{x:Float, y:Float}
	#end
	{
		if (arr.length == 1) {
			trace("WARNING: Array must have at least 2 values to convert to FlxPoint, leaving the second entry as 0");
			#if flixel
			return new flixel.math.FlxPoint(arr[0], 0);
			#else
			return {x: arr[0], y: 0};
			#end
		}
		else if (arr.length > 2)
			trace("WARNING: Array has more than 2 values, the other ones will be ignored!");

		#if flixel
		return new flixel.math.FlxPoint(arr[0], arr[1]);
		#else
		return {x: arr[0], y: arr[1]};
		#end
	}

	/**
		Returns the last element of `arr`
		@param arr The `Array` to return
		@return Type
	**/
	inline public static function last<T>(arr:Null<Array<T>>):T {
		if (isBlank(arr)) throw "The array is null/empty to give the last element";
		return arr[arr.length - 1];
	}
}