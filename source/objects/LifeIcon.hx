package objects;

class LifeIcon extends FlxSprite {
	var charObj:Character;
	public var originalSprite:openfl.display.BitmapData;
	public function new(char:String) {
		super();

		if (states.PlayState.instance != null)
			charObj = states.PlayState.instance.player;

		init(char);

		scrollFactor.set();

		originalSprite = this.pixels.clone();
	}

	/**
	 * Life icons!
	 * 
	 * @param char Cur character
	 */
	public function init(char:String) {
		var img = 'characters/${charObj.json.name}/liveIcon';

		if (!Paths.fileExists("images/" + img + ".png", IMAGE)) {
			img = "characters/" + charObj.json.name + "/" + charObj.json.liveIcon;
			trace("[LIFEICON] Not found! Searching with JSON entry");
		}
	
		if (!Paths.fileExists("images/" + img + ".png", IMAGE)) {
			img = "characters/Sonic/liveIcon";
			trace("[LIFEICON] Not found again! Getting placeholder");
		}
		var graphic = Paths.image(img);

		loadGraphic(graphic, true, charObj.json.hasSuper ? Math.floor(graphic.width/2) : Math.floor(graphic.width), Math.floor(graphic.height));
		animation.add(char, [for (i in 0...frames.frames.length) i], 0, false, false);
		animation.play(char);

		if (graphic.width > 17 && graphic.height > 17) { // Sonic CD styled
			setGraphicSize(17, 17);
			updateHitbox();
		}
	}

	override function update(e:Float) {
		super.update(e);
	}
}