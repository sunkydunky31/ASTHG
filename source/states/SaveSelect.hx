package states;

import objects.Character;
import openfl.geom.Rectangle;
import flixel.tween.*;

class SaveSelect extends MusicBeatState {
	public var saveGroup:FlxTypedGroup<SaveEntry>;
	var curSelected:Int = 0;

	override function create() {
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		saveGroup = new FlxTypedGroup<SaveEntry>();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_save_select', 'Save Select'), null);
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff4d4dff);
		//bg.brightness = ClientPrefs.data.backLayers;
		add(bg);
		
		var bgLayer:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgLayer.alpha = ClientPrefs.data.backLayers;
		add(bgLayer);
		
		var title:FlxBitmapText = new FlxBitmapText(FlxG.width/2, FlxG.height - 26, Language.getPhrase("save_select", "Save Select"), Paths.getAngelCodeFont("Roco"));
		title.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 0);
		title.x -= title.width / 2;
		add(title);

		for (i in 0...Constants.SAVE_ENTRY_LIMIT) {
			var saveEntry:SaveEntry = new SaveEntry(i);
			saveEntry.x = 90 * i;
			saveEntry.y = 50;
			saveGroup.add(saveEntry);
		}
		add(saveGroup);

		var selectSave:FlxSprite = new FlxSprite().loadGraphic(Paths.image("saveSelect/selected"));
		selectSave.x = saveGroup.members[curSelected].x;
		selectSave.y = saveGroup.members[curSelected].y;
		FlxTween.color(selectSave, 0.2, FlxColor.fromString(Constants.SAVE_SELECTED_FRAME_COLOR1), FlxColor.fromString(Constants.SAVE_SELECTED_FRAME_COLOR2), {type: FlxTweenType.PINGPONG, ease: FlxEase.linear});
		add(selectSave);

		var selectUpZone:FlxSprite = new FlxSprite(saveGroup.members[curSelected].x + 30, saveGroup.members[curSelected].y + 14).loadGraphic(Paths.image("saveSelect/selectArrow"));
		selectUpZone.color = FlxColor.fromString(Constants.SAVE_SELECTED_ARROW_COLOR1);
		add(selectUpZone);

		var selectUpChar:FlxSprite = new FlxSprite(saveGroup.members[curSelected].x + 30, saveGroup.members[curSelected].y + 65).loadGraphic(Paths.image("saveSelect/selectArrow"));
		selectUpChar.color = FlxColor.fromString(Constants.SAVE_SELECTED_ARROW_COLOR2);
		add(selectUpChar);

		var selectDownZone:FlxSprite = new FlxSprite(selectUpZone.x, selectUpZone.y + 18).loadGraphic(Paths.image("saveSelect/selectArrowFlip"));
		selectDownZone.color = selectUpZone.color;
		add(selectDownZone);

		var selectDownChar:FlxSprite = new FlxSprite(selectUpChar.x, selectUpChar.y + 30).loadGraphic(Paths.image("saveSelect/selectArrowFlip"));
		selectDownChar.color = selectUpChar.color;
		add(selectDownChar);

		super.create();
		CoolUtil.playMusic("SaveSelect", {sample: 131290});
	}

	override function update(e:Float) {
		super.update(e);

		if (controls.justPressed('accept'))
			LoadingState.switchStates(new states.PlayState(), true);
		if (controls.justPressed('back')) {
			CoolUtil.mus.stop();
			MusicBeatState.switchState(new MainMenu());
		}
	}
}

class SaveEntry extends FlxSpriteGroup {
	public var character:Character = null;
	public var emeralds:Array<FlxSprite> = new Array<FlxSprite>();
	public function new(id:Int) {
		super();

		var save:FlxSprite = new FlxSprite().loadGraphic(Paths.image("saveSelect/save", null, false)); //false -> Allow pixel reading
		add(save);

		var colors:Array<Array<FlxColor>> = [
			[0xff0080e0, 0xff00b4cc, 0xff00c0e0, 0xff80e0e0],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
		];

		for (i in 0...7) {
			var emerald:FlxSprite = new FlxSprite(2, save.height - 12);
			emerald.x += (emerald.width * i) + i;
			CoolUtil.applyPalette(emerald, [colors[i][0], colors[i][1], colors[i][2], colors[i][3]]);
			add(emerald);
			emeralds.push(emerald);
		}
		
		character = new Character(30, 80, "sonic");
		add(character);
	}
}