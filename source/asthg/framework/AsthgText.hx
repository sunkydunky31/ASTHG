/*
	Sunnydev31 - 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthe.framework;

import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;

class ASTHEText extends FlxText {
	public function new(x:Float = 0.0, y:Float = 0.0, width:Float = 0.0, ?text:String, size:Int = 16, embedded:Bool = true) {
		super(x, y, width, text, size, embedded);
	}

	/**
		Creates a text box
		@param font Font file name
		@param x Horizontal position of the box
		@param y Vertical position of the box
		@param text Your text
		@param font Your font file name
		@param embedded If the font is a internal game font or a global one (from your platform)
		@return ASTHEText
	**/
	public static function create(x:Float, y:Float, text:String, ?font:String = "Mania.ttf", ?embedded:Bool = true):ASTHEText {
		var txt:ASTHEText = new ASTHEText(x, y, 0, text, 16, embedded);
		txt.font = (embedded) ? Paths.font(font) : font;

		return txt;
	}

	/**
		Formats a text field to make it more styled
		@param size Size of the font to render
		@param align Aligment to the font
		@param color
		@return ASTHEText
	**/
	public function format(size:Int = 16, ?align:TextAlign = TextAlign.LEFT, ?color:FlxColor = FlxColor.WHITE):ASTHEText {
		this.size = size;
		this.alignment = align;
		this.color = color;

		return this;
	}

	public function formatBorder(style:TextBorder = OUTLINE, borderColor:FlxColor = FlxColor.BLACK, ?borderSize:Int = 1):ASTHEText {
		switch (style) {
			case NONE: // Nothing
			case SHADOW: this.borderStyle = FlxTextBorderStyle.SHADOW;
			case SHADOW_XY(offX, offY): // Adds support for old flixel versions
				#if (flixel < "5.9.0")
				this.borderStyle = FlxTextBorderStyle.SHADOW;
				this.shadowOffset.set(offX, offY);
				#else
				this.borderStyle = FlxTextBorderStyle.SHADOW_XY(offX, offY);
				#end
			case OUTLINE: this.borderStyle = FlxTextBorderStyle.OUTLINE;
			case OUTLINE_FAST: this.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		}
		this.borderColor = borderColor;
		this.borderSize = borderSize;

		return this;
	}
}

enum TextBorder {
	NONE;
	SHADOW;
	SHADOW_XY(offX:Int, offY:Int); // Compatibility with Flixel 5.9.0+
	OUTLINE;
	OUTLINE_FAST;
}

enum abstract TextAlign(String) from String to flixel.text.FlxText.FlxTextAlign {
	var LEFT = "left";
	var RIGHT = "right";
	var CENTER = "center";
	var JUSTIFY = "justify";
}
