/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthg.states;

import asthg.objects.Character;
import flixel.tween.*;

class SaveSelect extends StateManager {
	public var camFront:FlxCamera;
	public var camFollow:FlxObject = new FlxObject(FlxG.width / 2, 0, 2, 2);

	public var saveGroup:FlxTypedGroup<SaveEntry>;
	var curSelected:Int = 0;

	var selectSave:AsthgSprite;
	var arrow1:AsthgSprite;
	var arrow2:AsthgSprite;
	var arrow3:AsthgSprite;
	var arrow4:AsthgSprite;

	override function create() {
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		saveGroup = new FlxTypedGroup<SaveEntry>();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence({ details: Locale.getString('save_select', 'discord') });
		#end

		camFront = new FlxCamera();
		camFront.visible = true;
		camFront.bgColor.alpha = 5;
		FlxG.cameras.add(camFront, false);
		camFront.follow(camFollow, LOCKON, 0.12);

		var bg:AsthgSprite = AsthgSprite.create(0, 0, "menus/saveSelect/bg");
		add(bg);

		var bgLayer:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgLayer.alpha = ClientPrefs.data.options.backLayers;
		add(bgLayer);

		var title:FlxBitmapText = new FlxBitmapText(FlxG.width/2, FlxG.height - 26, Locale.getString("title", "save_select"), Paths.getAngelCodeFont("GameOver"));
		title.x -= title.width / 2;
		add(title);

		for (i in 0...Constants.SAVE_ENTRY_LIMIT) {
			var saveEntry:SaveEntry = new SaveEntry(i);
			saveEntry.setPosition(90 * i, 80);
			saveEntry.cameras = [camFront];
			saveGroup.add(saveEntry);
		}
		add(saveGroup);

		//Do not touch the position of this sprite
		selectSave = AsthgSprite.create(saveGroup.members[curSelected].x, saveGroup.members[curSelected].y, "menus/saveSelect/selected");
		FlxTween.color(selectSave, 0.2, Constants.SAVE_SELECTED_FRAME_COLOR[0], Constants.SAVE_SELECTED_FRAME_COLOR[1], {type: FlxTweenType.PINGPONG, ease: FlxEase.linear});
		selectSave.cameras = [camFront];
		add(selectSave);

		// Positions of all the sprites above are updated on `changeSelection()`
		arrow1 = AsthgSprite.create(0, 0, "menus/saveSelect/selectArrow");
		arrow1.color = Constants.SAVE_SELECTED_ARROW_COLOR[0];
		arrow1.cameras = [camFront];
		add(arrow1);

		arrow2 = AsthgSprite.create(0, 0, "menus/saveSelect/selectArrow");
		arrow2.color = Constants.SAVE_SELECTED_ARROW_COLOR[1];
		arrow2.cameras = [camFront];
		add(arrow2);

		arrow3 = AsthgSprite.create(0, 0, "menus/saveSelect/selectArrowFlip");
		arrow3.color = arrow1.color;
		arrow3.cameras = [camFront];
		add(arrow3);

		arrow4 = AsthgSprite.create(0, 0, "menus/saveSelect/selectArrowFlip");
		arrow4.color = arrow2.color;
		arrow4.cameras = [camFront];
		add(arrow4);

		changeSelection();

		super.create();
		AsthgSound.playMusic("SaveSelect");
	}

	override function update(e:Float) {
		super.update(e);

		if (controls.ACCEPT)
			LoadingState.switchStates(new asthg.states.PlayState(), true);

		if (controls.BACK)
			StateManager.switchState(new asthg.states.MainMenu());

		if (controls.LEFT || controls.RIGHT)
			changeSelection(controls.LEFT ? -1 : 1);
	}

	function changeSelection(count:Int = 0) {
		if (ArrayUtil.isBlank(saveGroup.members))
			return;

		curSelected = FlxMath.wrap(curSelected + count, 0, saveGroup.length - 1);

		var member = cast saveGroup.members[curSelected];
		if (member == null) {
			trace("member is null!".warn());
			return;
		}

		selectSave.setPosition	(member.x,	member.y);
		arrow1.setPosition		(member.x + (member.width / 2),	member.y + 14);
		arrow2.setPosition		(member.x + (member.width / 2),	member.y + 65);
		arrow3.setPosition		(member.x + (member.width / 2),	arrow1.y + 18);
		arrow4.setPosition		(member.x + (member.width / 2),	arrow2.y + 30);

		camFollow.setPosition(selectSave.x + (selectSave.width / 2), selectSave.y + (selectSave.height / 2));

		AsthgSound.playSound(ConstantSound.MENU_SCROLL);
	}
}


@:nullSafety
class SaveEntry extends FlxSpriteGroup {
	public var character:Null<Character>;
	public var emeralds:Array<AsthgSprite> = new Array<AsthgSprite>();
	public function new(id:Int) {
		super();

		var save:AsthgSprite = AsthgSprite.create(0, 0, "menus/saveSelect/save");
		add(save);

		var colors:Array<Array<FlxColor>> = [
			[0x0080E0, 0x00B4CC, 0x00C0E0, 0x80E0E0],
			[0x790000, 0xAE0000, 0xDA0000, 0xFF0000],
			[0x2BFF00, 0xDA0000, 0xAE0000, 0x790000],
			[0xFBFF00, 0xDA0000, 0xAE0000, 0x790000],
			[0xD4D4D4, 0xDA0000, 0xAE0000, 0x790000],
			[0xFF0000, 0xDA0000, 0xAE0000, 0x790000],
			[0xFF0000, 0xDA0000, 0xAE0000, 0x790000],
			[0xFF00D4, 0xDA0000, 0xAE0000, 0x790000],
		];

		for (i in 0...7) {
			var emerald:AsthgSprite = AsthgSprite.create(2, save.height - 12, "menus/saveSelect/emerald");
			emerald.x += (emerald.width * i) + i;
			emerald.applyPalette(colors[i]);
			add(emerald);
			emeralds.push(emerald);
		}
	}
}