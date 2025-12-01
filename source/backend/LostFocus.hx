package backend;

class LostFocus extends openfl.display.Sprite {
    public function new() {
        super();

        var bg:FlxSprite().makeGraphic(FlxG.stage.stageWidth, FlxG.stage.stageHeight, FlxColor.BLACK);
        bg.alpha = 0.5;
        addChild(bg);

        var text:FlxText = new FlxText(0, FlxG.height / 2, FlxG.width, Locale.getString("lostfocus"), 32);
        text.setFormat(Paths.font("Mania.ttf"), 16, "center");
        addChild(text);

        visible = false;
    }
}