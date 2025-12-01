/*
	By Sunkydev31
	2025.11.30
	You are allowed to copy, modify and distribute the code in this file.
*/

package framework;


class CustomText extends flixel.text.FlxText {
	cText:FlxText;

	/**
		Creates a new text display
		@param x Position of the text box horizontally
		@param y Position of the text box vertically
	**/
	public static function new(x:Float = 0, y:Float = 0, fieldWidth:Int, ?text:String = "", ?size:Int = 8, ?embedded:Bool = true) {
		super(x, y, fieldWidth, text, size, embedded);
	}

	public static function setFormat(font:String, size:Int, alignment:Int, ?color:FlxColor = FlxColor.WHITE):CustomText {
		cText.font = Paths.font(font);
		cText.size = size;
		cText.alingment = alignment;
		cText.color = color;
		return cText;
	}

	/**
		Set border's styles, color, and any other properties 
		@param style Border Style	
					Options: `NONE`, `SHADOW`, `SHADOW_XY`, `OUTLINE`, `OUTLINE_FAST`
		@param color 
	**/
	public static function setBorder(style:BorderStyle = OUTLINE, color:FlxColor = FlxColor.BLACK, size:Float = 1.0, quality:Float = 1.0):CustomText {

		#if (flixel < 5.9.0)
		if (style == BorderStyle.SHADOW_XY(x, y)) {
			cText.borderStyle = BorderStyle.SHADOW;
			cText.shadowOffset = FlxPoint.get(x, y);
		} else {
			cText.borderStyle = style;
		}
		#else
		cText.borderStyle = style;
		#end
		cText.borderColor = color;
		cText.borderSize = size;
		cText.borderQuality = quality;
	}
}

enum BorderStyle {
	NONE;
	SHADOW;

	/**
		Flixel 5.9 imported option
		Returns `SHADOW` with custom offsets
	**/
	SHADOW_XY(x:Float, y:Float);
	OUTLINE;
	OUTLINE_FAST
}