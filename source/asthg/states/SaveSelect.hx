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
	var curSlot:Int = 0;
	var curChar:Int = 0;
	var curZone:Int = 0;

	var selectSave:AsthgSprite;
	var arrow1:AsthgSprite;
	var arrow2:AsthgSprite;
	var arrow3:AsthgSprite;
	var arrow4:AsthgSprite;

	public var character:Character;

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
		selectSave = AsthgSprite.create(saveGroup.members[curSlot].x, saveGroup.members[curSlot].y, "menus/saveSelect/selected");
		FlxTween.color(selectSave, 0.2, Constants.SAVE_SELECTED_FRAME_COLOR[0], Constants.SAVE_SELECTED_FRAME_COLOR[1], {type: FlxTweenType.PINGPONG, ease: FlxEase.linear});
		selectSave.cameras = [camFront];
		add(selectSave);

		// Positions of all the sprites above are updated on `changeSlot()`
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

		changeSlot();

		super.create();
		AsthgSound.playMusic("SaveSelect");
	}

	override function update(e:Float) {
		super.update(e);

		if (controls.ACCEPT) {
			if (getSaveState(curSlot) == InProgress) {
				ClientPrefs.loadSlot(curSlot);
				LoadingState.switchStates(new asthg.states.PlayState(), true);
			}
			else {
				ClientPrefs.createSlot(curSlot, Constants.DEFAULT_CHARACTER);
				LoadingState.switchStates(new asthg.states.PlayState(), true);
			}

		}

		if (controls.BACK)
			StateManager.switchState(new asthg.states.MainMenu());

		if (controls.UP || controls.DOWN) {
			switch (getSaveState(curSlot)) {
				case New:
					changeCharacter(controls.UP ? -1 : 1);
				case Clear:
				default:
			}
		}

		if (controls.LEFT || controls.RIGHT) {
			changeSlot(controls.LEFT ? -1 : 1);
			AsthgSound.playSound(ConstantSound.MENU_SCROLL);
		}
	}

	function changeSlot(count:Int = 0) {
		if (ArrayUtil.isBlank(saveGroup.members))
			return;

		curSlot = FlxMath.wrap(curSlot + count, 0, saveGroup.length - 1);

		var member = cast saveGroup.members[curSlot];
		if (member == null) {
			trace("member is null!".warn());
			return;
		}

		selectSave.setPosition  (member.x, member.y);
		arrow1.setPosition      (member.x + (member.width / 2), member.y + 14);
		arrow2.setPosition      (member.x + (member.width / 2), member.y + 65);
		arrow3.setPosition      (member.x + (member.width / 2), arrow1.y + 18);
		arrow4.setPosition      (member.x + (member.width / 2), arrow2.y + 30);

		camFollow.setPosition(selectSave.x + (selectSave.width / 2), selectSave.y + (selectSave.height / 2));
	}

	function changeCharacter(count:Int = 0) {
		if (ArrayUtil.isBlank(saveGroup.members))
			return;

		curChar = FlxMath.wrap(curChar + count, 0, saveGroup.length - 1);
	}

	static function getSaveState(slot:Int):SaveState {
		if (!ClientPrefs.slotExists(slot)) {
			return New;
		}

		if (ClientPrefs.loadSlotData(slot).clear) {
			return Clear;
		}

		return InProgress;
	}
}

@:nullSafety
class SaveEntry extends FlxSpriteGroup {
	public function new(id:Int) {
		super();

		var data = ClientPrefs.loadSlotData(id);

		var portrait:AsthgSprite;
		if (!ClientPrefs.slotExists(id)) {
			portrait = AsthgSprite.create(2, 2, "menus/saveSelect/savePortrait_new");
			add(portrait);
		}

		var save:AsthgSprite = AsthgSprite.create(0, 0, "menus/saveSelect/save");
		add(save);

		//var label:AsthgBitmapText =

		for (i in 0...7) {
			var colors:Array<String> = [
				"cyan", "red", "green", "yellow", "gray", "purple", "blue"
			];

			var _emerl = Paths.image("menus/saveSelect/emeralds");
			var emerlSize = Math.round(_emerl.width / _emerl.height); // Sprite frames

			var emerald:AsthgSprite = AsthgSprite.createSpriteSheet(2, save.height - 12, Math.round(_emerl.width / emerlSize), _emerl.height, "menus/saveSelect/emeralds");
			emerald.x += ((emerald.width / emerlSize) * i) + i;

			emerald.animation.add(colors[i], [i], false, false);

			emerald.animation.play(colors[i]);

			emerald.visible = (ClientPrefs.slotExists(id)) ? (data?.emeralds[i] ?? false) : false;
			add(emerald);
		}
	}
}

enum SaveState {
	New;
	InProgress;
	Clear;
}