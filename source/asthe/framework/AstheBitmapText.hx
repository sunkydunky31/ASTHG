/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-14
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthe.framework;

import flixel.text.FlxBitmapText;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxText.FlxTextBorderStyle;
import asthe.framework.AstheText;

class AstheBitmapText extends FlxBitmapText {
	var fontName:String = "";
	public var caseCharSkips:Array<String> = [];

	public function new(?x:Float = 0.0, ?y:Float = 0.0, ?text:String) {
		super(x, y, text);
	}

	/**
		Creates a text box with a Angel Code font
		@param font Font file name
		@param x Horizontal position of the box
		@param y Vertical position of the box
		@param text Your text
		@param font Your font file name
		@return AstheBitmapText
	**/
	public static function createAngelCode(x:Float, y:Float, text:String, ?font:String):AstheBitmapText {
		var txt:AstheBitmapText = new AstheBitmapText(x, y, text);
		txt.loadAngelCode(font);
		return txt;
	}

	/**
		Creates a text box with a Monospaced font
		@param font Font file name
		@param x Horizontal position of the box
		@param y Vertical position of the box
		@param text Your text
		@param font Your font file name
		@return AstheBitmapText
	**/
	public static function createMonospace(x:Float, y:Float, text:String, ?font:String, ?glyphs:String, ?size:Array<Float>):AstheBitmapText {
		var txt:AstheBitmapText = new AstheBitmapText(x, y, text);
		txt.loadMonospace(font, glyphs, size);
		return txt;
	}

	/**
		Gets a AngelCode bitmap font
		@param key Name of the font file
	**/
	public function loadAngelCode(key:String = "Roco"):AstheBitmapText {

		// Fonts that doesn't need lowercase letters / support them
		for (i in ["Roco", "TitleFont", "GameOver", "HUD"]) {
			if (key == i)
				this.text = text.toUpperCase();
		}

		var file:String = Paths.getPath("fonts/" + key);
		this.font = FlxBitmapFont.fromAngelCode(file + ".png", file + ".fnt");
		return this;
	}

	public function loadMonospace(key:String, glyphs:String, size:Array<Float>):AstheBitmapText {
		var file:String = Paths.getPath("fonts/" + key);
		this.font = FlxBitmapFont.fromMonospace(file + ".png", glyphs, ArrayUtil.toPoint(size));
		return this;
	}

	public function formatBorder(style:AstheText.TextBorder = OUTLINE, borderColor:FlxColor = FlxColor.BLACK, ?borderSize:Int = 1):AstheBitmapText {
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
