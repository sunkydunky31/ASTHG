/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.objects;

import flixel.math.FlxPoint;

class LifeIcon extends AsthgSprite {

	public var character:String = null;
	public var offsets:FlxPoint = FlxPoint.get(0, 0);

	public function new(char:String) {
		super();

		init(char);
		updatePalette([]);
		scrollFactor.set();
	}

	/**
		Initializes the life icon from character data.

		@param char Character identifier
		@throws HaxeException If character JSON is missing or icon file not found
	**/
	public function init(char:String):Void {
		if (character == char) return;

		final ps:Null<asthg.states.PlayState> = asthg.states.PlayState.instance;
		if (ps == null || ps.player?.json == null) {
			throw "PlayState or Character JSON not loaded!";
		}

		var charName:String = ps.player.json.name;
		var charIcon:String = ps.player.json.liveIcon?.name ?? "liveIcon";
		var img:String = findIconPath(charName, charIcon);

		character = char;

		var graphic = Paths.image(img);
		var fcount = Math.round(graphic.width / graphic.height); // Gets the number of frames
		loadGraphic(graphic, true, Math.floor(graphic.width / fcount), Math.floor(graphic.height));
		loadAnimations();
	}

	/**
		Searches for the icon file with fallback strategy.
		@return Path to the icon (guaranteed to exist)
		@throws HaxeException If no valid icon is found
	**/
	private function findIconPath(charName:String, charIcon:String):String {
		var attempts:Array<String> = [
			'characters/$charName/liveIcon',
			'characters/$charName/$charIcon',
			'characters/${Constants.DEFAULT_CHARACTER}/${Constants.LIFE_ICON}'
		];

		for (path in attempts) {
			if (Paths.fileExists('images/$path.png', IMAGE)) {
				return path;
			}
		}

		throw 'Life icon not found in any location. Last attempt: ${ArrayUtil.last(attempts)}';
	}

	/**
		Synchronizes the icon palette with the current player state.
	**/
	override public function updatePalette(pal:Array<FlxColor>):AsthgSprite {
		final ps:Null<asthg.states.PlayState> = asthg.states.PlayState.instance;
		if (ps == null || ps.player?.json?.palettes == null) return this;

		var palette:Array<String> = (ps.player.isSuper)
			? (ps.player.json.palettes.super ?? ps.player.json.palettes.normal)
			: ps.player.json.palettes.normal;

		if (palette != null && palette.length >= 4) {
			return super.updatePalette([
				FlxColor.fromString(palette[0]),
				FlxColor.fromString(palette[1]),
				FlxColor.fromString(palette[2]),
				FlxColor.fromString(palette[3])
			]);
		}
		return this;
	}

	// Leaving it public for scripts to override it
	public function loadAnimations():Void {
		animation.add("normal", [0], 0, false, false);
		animation.add("super", [1], 0, false, false);
		animation.play("normal");
	}

	public function setSuper(isSuper:Bool):Void {
		animation.play(isSuper ? "super" : "normal");
		updatePalette([]);
	}

	override public function updateHitbox():Void {
		super.updateHitbox();
		if (offsets != null) {
			offset += offsets;
		}
	}
}