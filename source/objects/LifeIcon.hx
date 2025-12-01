/*
	By Sunkydev31
	2025.11.30
	You are allowed to copy, modify and distribute the code in this file.
*/

package objects;

class LifeIcon extends FlxSprite {
	var charObj:Character;
	public function new(char:String) {
		super();

		if (states.PlayState.instance != null)
			charObj = states.PlayState.instance.player;

		init(char);

		scrollFactor.set();
	}

	/**
		Life icons!

		@param char Cur character
	**/
	public function init(char:String) {
		var img = 'characters/${charObj.json.name}/liveIcon';
		var strike:Bool = Paths.fileExists('images/$img.png', IMAGE);

		if (!strike) { // Strike 1: Char file not found -> Use JSON entry
			img = "characters/" + charObj.json.name + "/" + charObj.json.liveIcon;
			trace("Not found! Searching with JSON entry");
		}
	
		if (!strike) { //Strike 2: Char file with JSON name not found -> Use placeholder
			img = "characters/Sonic/liveIcon";
			trace("Not found again! Getting placeholder");
		}
	
		if (!strike)  //Strike 3: Impossible to find files to use / Even fallback was not found
			throw "Holy damn! WHAT DID YOU DO WITH YOUR ASSETS???????????";

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