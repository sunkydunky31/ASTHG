package states;
import flixel.input.keyboard.FlxKey;

class TitleState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		ClientPrefs.loadPrefs();
		Language.reloadPhrases();

		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFFF00000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		CoolUtil.playMusic('TitleScreen', {sample: 0});

		super.create();
	}

	override function update(e:Float) {
		if (controls.justPressed('accept'))
			MusicBeatState.switchState(new PlayState());
	}
}