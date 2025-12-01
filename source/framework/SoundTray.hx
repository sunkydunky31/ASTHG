package framework;

import flixel.system.ui.FlxSoundTray;

class SoundTray extends FlxSoundTray {

    public function new() {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(100, 100, FlxColor.RED);
        add(bg);
    }
}