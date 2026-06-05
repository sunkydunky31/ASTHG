/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.framework;

import flixel.text.FlxBitmapText;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxText.FlxTextBorderStyle;
import asthg.framework.AsthgText;

class AsthgBitmapText extends FlxBitmapText {
	var fontName:String = "";

	public function new(?x:Float = 0.0, ?y:Float = 0.0, ?text:String) {
		super(x, y, text);
	}

	/**
		Creates a text box
		@param font Font file name
		@param x Horizontal position of the box
		@param y Vertical position of the box
		@param text Your text
		@param font Your font file name
		@param embedded If the font is a internal game font or a global one (from your platform)
		@return AsthgBitmapText
	**/
	public static function createAngelCode(x:Float, y:Float, text:String, ?font:String = "Roco"):AsthgBitmapText {
		// List of fonts that doesn't need lowercase letters / support them
		var noUpper = ["Roco", "TitleFont", "GameOver", "HUD"];

		for (i in noUpper)
			if (font == i)
				text = text.toUpperCase();

		var txt:AsthgBitmapText = new AsthgBitmapText(x, y, text);
		txt.font = Paths.getAngelCodeFont(font);
		return txt;
	}

	public function formatBorder(style:AsthgText.TextBorder = OUTLINE, borderColor:FlxColor = FlxColor.BLACK, ?borderSize:Int = 1):AsthgBitmapText {
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
