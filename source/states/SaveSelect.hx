package states;

import objects.Character;
import openfl.geom.Rectangle;
import flixel.tween.*;

class SaveSelect extends MusicBeatState {
	public var saveGroup:FlxTypedGroup<SaveEntry>;
	var curSelected:Int = 0;

	override function create() {
		Paths.clearStoredMemory();

		saveGroup = new FlxTypedGroup<SaveEntry>();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_save_select', 'Save Select'), null);
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff4d4dff);
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

		var selectUpZone:FlxSprite = new FlxSprite(saveGroup.members[curSelected].x + 50, saveGroup.members[curSelected].y).loadGraphic(Paths.image("saveSelect/selectArrow"));
		selectUpZone.color = FlxColor.fromString(Constants.SAVE_SELECTED_ARROW_COLOR1);
		add(selectUpZone);

		var selectUpChar:FlxSprite = new FlxSprite(saveGroup.members[curSelected].x + 50, saveGroup.members[curSelected].y + 50).loadGraphic(Paths.image("saveSelect/selectArrow"));
		selectUpChar.color = FlxColor.fromString(Constants.SAVE_SELECTED_ARROW_COLOR2);
		add(selectUpChar);

		var selectDownZone:FlxSprite = new FlxSprite(selectUpZone.x, selectUpZone.y + 18).loadGraphic(Paths.image("saveSelect/selectArrow"));
		selectDownZone.flipY = true;
		selectDownZone.color = selectUpZone.color;
		add(selectDownZone);

		var selectDownChar:FlxSprite = new FlxSprite(selectUpChar.x, selectUpChar.y + 30).loadGraphic(Paths.image("saveSelect/selectArrow"));
		selectDownChar.flipY = true;
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
	//public var character:Character = null;
	public var emeralds:Array<FlxSprite> = new Array<FlxSprite>();
	public function new(id:Int) {
		super();
	//	this.character = new Character(0, 0, "sonic");
	//	add(character);

		var save:FlxSprite = new FlxSprite().loadGraphic(Paths.image("saveSelect/save"));
		add(save);

		var colors:Array<Array<String>> = [
			["#0080e0", "#00b4cc", "#00c0e0", "#80e0e0"],
			["#ff0000", "#da0000", "#ae0000", "#790000"],
			["#ff0000", "#da0000", "#ae0000", "#790000"],
			["#ff0000", "#da0000", "#ae0000", "#790000"],
			["#ff0000", "#da0000", "#ae0000", "#790000"],
			["#ff0000", "#da0000", "#ae0000", "#790000"],
			["#ff0000", "#da0000", "#ae0000", "#790000"],
		];

		for (i in 0...7) {
			var emerald = new FlxSprite(2, save.height - 12);
			emerald.loadGraphic(Paths.image("saveSelect/emerald"));
			emerald.x += (emerald.width * i) + i;
			CoolUtil.applyPalette(emerald, [colors[i][0], colors[i][1], colors[i][2], colors[i][3]]);
			add(emerald);
			emeralds.push(emerald);
		}
		

	}
}