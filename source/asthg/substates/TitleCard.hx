package asthe.substates;

class TitleCard extends SubStateManager{

	/**
		Shows the title card
		@param colors Order: Background, Bottom Backdrop, Left backdrop
	**/
	public function new(?colors:Array<String> = ["#2040c0", "#e0e000", "#e00000"]) {
		var bg:ASTHESprite = new ASTHESprite().createGraphic(FlxG.width, FlxG.height, 0xff000000);
		add(bg);

		var bg2:ASTHESprite = new ASTHESprite().createGraphic(FlxG.width, FlxG.height, FlxColor.fromString(colors[0]));
		add(bg2);

		var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backdrop.color = FlxColor.fromString(colors[1]);
		backdrop.x = FlxG.width * 0.72;
		add(backdrop);

		var backdrop2:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backdrop2.color = FlxColor.fromString(colors[2]);
		backdrop2.y = FlxG.height * 0.7;
		add(backdrop2);

		var actName:ASTHEBitmapText = ASTHEBitmapText.createAngelCode(FlxG.width - 90, 87, "STAGE NAME", "Roco");
		actName.x -= actName.width;
		add(actName);

		var zoneName:ASTHEBitmapText = ASTHEBitmapText.createAngelCode(FlxG.width - 90, 105, "ZONE", "Roco");
		zoneName.x -= (zoneName.width);
		add(zoneName);

		FlxTween.tween(bg2, {y: FlxG.height}, 0.4);
		FlxTween.tween(backdrop, {y: FlxG.height - 50}, 0.5);
		FlxTween.tween(backdrop2, {x: 50}, 0.5);
	}
}