/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-16-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.framework;

import flixel.FlxSprite;
import flixel.addons.display.FlxSliceSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
	Custom instance for FlxSprite with better functions

	Example:
	```haxe
	var mySprite:AsthgSprite = new AsthgSprite();
	mySprite.create(0, 0, "My Sprite"); // calls `loadGraphic(Paths.image("My Sprite"));` + `setPosition(0, 0);`
	```
**/
class AsthgSprite extends FlxSprite {
	private static var fallback = flixel.system.FlxAssets.getBitmapData("flixel/images/logo/default");

	public function new(?x:Float = 0, ?y:Float = 0.0) {
		super(x, y);
	}

	/**
		Creates a simple sprite
		@param x Position of the sprite
		@param y Position of the sprite
		@param image The image to load
		@return AsthgSprite
	**/
	public static function create(x:Float = 0, y:Float = 0, image:Null<String>):AsthgSprite {
		var spr:AsthgSprite = new AsthgSprite(x, y);

		if (!StringUtil.isBlank(image)) {
			var graphic:FlxGraphic = Paths.image(image);
			if (graphic != null) {
				spr.loadGraphic(graphic);
			} else {
				trace("Image not found".warn());
				spr.loadGraphic(fallback);
			}
		} else {
			trace("'Image' argument is null/empty!".warn());
			spr.loadGraphic(fallback);
		}

		return spr;
	}

	/**
		Creates a sprite sheet
		@param x Position of the sprite
		@param y Position of the sprite
		@param fWidth Width per frame
		@param fHeight Height per frame
		@param image The image to load
		@return AsthgSprite
	**/
	public static function createSpriteSheet(x:Float = 0, y:Float = 0, fWidth:Int, fHeight:Int, image:Null<String> = null):AsthgSprite {
		var spr:AsthgSprite = new AsthgSprite(x, y);

		if (!StringUtil.isBlank(image)) {
			var graphic:FlxGraphic = Paths.image(image);
			if (graphic != null) {
				spr.loadGraphic(graphic, true, fWidth, fHeight);
			} else {
				trace('Image not found: $image'.warn());
				spr.loadGraphic(fallback);
			}
		} else {
			trace("'Image' argument is null/empty!".warn());
			spr.loadGraphic(fallback);
		}

		return spr;
	}

	/**
		Create a new SparrowAtlas V2 sprite.
		@param x Horizontal position.
		@param y Vertical position
		@param image Image name
		@return AsthgSprite
	**/
	public static function createSparrow(x:Float = 0, y:Float = 0, image:Null<String> = null):AsthgSprite {
		var spr:AsthgSprite = new AsthgSprite(x, y);

		if (!StringUtil.isBlank(image)) {
			var frames = Paths.getSparrowAtlas(image);
			if (frames != null) {
				spr.frames = frames;
			}
			else {
				trace('Atlas not found: $image'.warn());
				spr.loadGraphic(fallback);
			}
		}
		else {
			trace("'Image' argument is null/empty!".warn());
			spr.loadGraphic(fallback);
		}

		return spr;
	}

	/**
		Creates a FlxSprite gradient sprite
		@param width The width of the sprite
		@param height The height of the sprite
		@param colors The colors to create the gradient. Like: `[COLOR1, COLOR2]`...
		@param chuncks
		@param angle Angle of the gradient
		@param interp Should the colors interpolate?
		@return FlxSprite
	**/
	public static function createGradient(width:Int, height:Int, ?colors:Array<FlxColor>, ?chuncks:UInt = 2, ?angle:Int = 0, ?interp:Bool = true):FlxSprite {
		// Just calls FlxGradient, lol
		var spr:FlxSprite = new FlxSprite(); // We need to use FlxSprite here because FlxGradient returns that
		spr = FlxGradient.createGradientFlxSprite(width, height, colors, chuncks, angle, interp);
		return spr;
	}

	/**
		Creates a colored rectangle
		@param width The width of the rectangle
		@param height The height of the rectangle
		@param color The color to fill
		@return AsthgSprite
	**/
	public function createGraphic(width:Float = 1, height:Float = 1, color:FlxColor = FlxColor.WHITE):AsthgSprite {
		var graph:FlxGraphic = FlxG.bitmap.create(2, 2, color, false, 'graphic($width,$height,#${color.toWebString()})');
		frames = graph.imageFrame;
		scale.set(width / 2, height / 2);
		updateHitbox(); // We can't use our tool because it's not a FlxSprite-type
		return this;
	}

	/**
		Creates a 9-Sliced sprite!
		@param x Position horizontally
		@param y Vertical position
		@param width Width to final sprite
		@param height Height to final sprite
		@param image The image stored in `images/`
		@param slice Slice parameters (`[Left, Top, Spaces from Left, Spaces from Top]`)
		@param imageRect The image part you want to crop (`[X, Y, Width, Height]`)
		@return FlxSliceSprite
	**/
	public static function createSliced(x:Float, y:Float, width:Float, height:Float, image:String, slice:Array<Float>, ?imageRect:Array<Float>):FlxSliceSprite {
		// FINALLY I GOT IT HOW THIS THING WORKS -- @sunnydev31
		var sliceSprite:FlxSliceSprite = new FlxSliceSprite(Paths.image(image),
			ArrayUtil.toRect(slice), width, height,
			ArrayUtil.toRect(imageRect));
		sliceSprite.setPosition(x, y);
		return sliceSprite;
	}

	private var paletteApplied:Bool = false;
	/**
		Switches global colors into custom colors using GLSL shader
		Note that the sprite must be added or loaded to work
		The global color is stored at `backend.Constants.PALETTE_OVERRIDE`

		@param pal The colors to replace in order, Must match the length of Constants.PALETTE_OVERRIDE
		@param tolerance Color matching tolerance (0.0 - 1.0, default 0.1)
		@return AsthgSprite
	**/
	public function applyPalette(pal:Array<FlxColor>):AsthgSprite {
		if (ClientPrefs.data.options.cacheOnGPU) {
			trace("Caching sprites is enabled! Returning or it will throw an error...".warn());
			return this;
		}

		if (pal == null) {
			trace("Palette array is null! Cannot apply this palette into sprite".error());
			return this;
		}

		if (paletteApplied) {
			trace("Palette already applied to this sprite".warn());
			return this;
		}

		if (graphic == null) {
			trace("Cannot apply palette: sprite has no valid graphic!".error());
			return this;
		}

		// Caching and checkers
		final ogSize = Constants.PALETTE_OVERRIDE.length;
		final modSize = pal.length;

		if (modSize != ogSize) {
			trace("'The palette array on sprite '{0}' is not the same length as the default!'".error().format([this]));
			return this;
		}

		try {
			for (i in 0...ogSize)
				replaceColor(Constants.PALETTE_OVERRIDE[i], pal[i]);

			paletteApplied = true;
		}
		catch (e:Dynamic) {
			trace('Something gone wrong when applying palette: $e'.error());
		}

		return this;
	}

	/**
		Updates the palette even if it was already applied (for dynamic palette changes)
		@param pal The colors to replace in order
		@return AsthgSprite
	**/
	public function updatePalette(pal:Array<FlxColor>):AsthgSprite {
		paletteApplied = false;
		return applyPalette(pal);
	}

	/**
		Scales a sprite to a specific width and height
		@param width The target width
		@param height The target height
		@param updateHitbox Whether to update the hitbox after scaling
		@return AsthgSprite
	**/
	@:deprecated("This function will be removed soon, use `scale.set()` + `updateHitbox()`!")
	public function scaleSet(width:Float, height:Float, ?updHitbox:Bool = true):Void {
		scale.set(width, height);
		if (updHitbox) updateHitbox();
	}

}