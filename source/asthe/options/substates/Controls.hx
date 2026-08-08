/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/

package asthe.options.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

import asthe.input.InputFormatter;
import asthe.input.InputList;

enum abstract DeviceType(Int) {
	var KEYBOARD = 0;
	var GAMEPAD = 1;
}

class Controls extends SubStateManager {
	var currentDevice:DeviceType = DeviceType.KEYBOARD;

	/**
		List of keybinds
	**/
	var controlList:Array<InputList> = [
		UP, DOWN, LEFT, RIGHT,
		AUXILIAR, JUMP, ACCEPT, BACK,
		PAUSE,
		VOLUME_MUTE, VOLUME_UP, VOLUME_DOWN
	];


	var labels:Array<AstheText> = [];
	var binds:Array<Array<BindItem>> = [];

	var row:Int = 0;
	var col:Int = 0;

	var capturing:Bool = false;
	var captureBind:BindItem;

	var prompt:AstheText;
	var dim:FlxSprite;

	public function new() {
		super();

		var bg:AstheSprite = new AstheSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		var title:AstheBitmapText = AstheBitmapText.createAngelCode(FlxG.width/2, 8, Locale.getString("title_controls", "options"), "Roco");
		title.x -= title.width/2;
		add(title);

		var y:Float = 30;
		for (ctrl in controlList) {
			var lbl = AstheText.create(30, y, Locale.getString('key_$ctrl', 'options'));
			labels.push(lbl);
			add(lbl);

			var bindRow:Array<BindItem> = [];
			for (i in 0...2) {
				var b = new BindItem(260 + (i * 80), y, ctrl, i, currentDevice);
				bindRow.push(b);
				add(b);
			}
			binds.push(bindRow);

			y += 16;
		}

		dim = new AstheSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		dim.alpha = 0.8;
		dim.visible = false;
		add(dim);

		prompt = AstheText.create(0, FlxG.height / 2 - 38, "");
		prompt.fieldWidth = FlxG.width;
		prompt.alignment = CENTER;
		prompt.visible = false;
		add(prompt);

		refreshLabels();
		updateSelection();
	}

	function refreshLabels() {
		for (r in 0...binds.length)
			for (c in 0...binds[r].length)
				binds[r][c].updateDevice(currentDevice);
	}

	function updateSelection() {
		for (r in 0...binds.length)
			for (c in 0...binds[r].length)
				binds[r][c].color = (r == row && c == col) ? FlxColor.YELLOW : FlxColor.WHITE;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (!capturing) {
			if (controls.UP) {
				row = (row - 1 + binds.length) % binds.length;
				updateSelection();
				AstheSound.playSound(ConstantSound.MENU_SCROLL);
			}
			if (controls.DOWN) {
				row = (row + 1) % binds.length;
				updateSelection();
				AstheSound.playSound(ConstantSound.MENU_SCROLL);
			}
			if (controls.LEFT) {
				col = (col - 1 + 2) % 2;
				updateSelection();
				AstheSound.playSound(ConstantSound.MENU_SCROLL);
			}
			if (controls.RIGHT) {
				col = (col + 1) % 2;
				updateSelection();
				AstheSound.playSound(ConstantSound.MENU_SCROLL);
			}

			if (controls.ACCEPT) {
				startCapture(binds[row][col]);
				AstheSound.playSound(ConstantSound.MENU_ACCEPT);
			}

			if (FlxG.keys.justPressed.TAB || (FlxG.gamepads.anyJustPressed(FlxGamepadInputID.LEFT_SHOULDER) || FlxG.gamepads.anyJustPressed(FlxGamepadInputID.RIGHT_SHOULDER))) {
				currentDevice = (currentDevice == DeviceType.KEYBOARD ? DeviceType.GAMEPAD : DeviceType.KEYBOARD);
				refreshLabels();
				updateSelection();
				AstheSound.playSound(ConstantSound.MENU_ACCEPT);
			}

			if (controls.BACK) close();
		}
		else {
			if (currentDevice == DeviceType.KEYBOARD) captureKeyboard();
			else captureGamepad();
		}
	}

	function startCapture(b:BindItem) {
		var keyDelete = (currentDevice == DeviceType.KEYBOARD) ? InputFormatter.getKeyName(FlxKey.DELETE) : InputFormatter.getGamepadName(FlxGamepadInputID.BACK);
		var keyCancel = (currentDevice == DeviceType.KEYBOARD) ? InputFormatter.getKeyName(FlxKey.ESCAPE) : InputFormatter.getGamepadName(FlxGamepadInputID.B);

		capturing = true;
		captureBind = b;
		dim.visible = true;
		prompt.visible = true;
		prompt.text = Locale.getString((currentDevice == DeviceType.KEYBOARD) ? "keybind_change" : "keybind_change_gamepad", "options");
		prompt.text += "\n\n" + Locale.getString("keybind_actions", "options", [keyCancel, keyDelete]);
	}

	function endCapture() {
		capturing = false;
		captureBind = null;
		dim.visible = false;
		prompt.visible = false;
		refreshLabels();
		updateSelection();
	}

	function captureKeyboard() {
		if (FlxG.keys.justPressed.ESCAPE) {
			endCapture();
			AstheSound.playSound(ConstantSound.MENU_BACK);
			return;
		}
		if (FlxG.keys.justPressed.DELETE) {
			AstheSound.playSound(ConstantSound.MENU_BACK);
			writeKeyboard(FlxKey.NONE);
			endCapture();
			return;
		}
		if (FlxG.keys.justPressed.ANY) {
			var k:FlxKey = cast FlxG.keys.firstJustPressed();
			if (k != FlxKey.ESCAPE && k != FlxKey.DELETE) {
				writeKeyboard(k);
				endCapture();
			}
			AstheSound.playSound(ConstantSound.MENU_SCROLL);
		}
	}

	function writeKeyboard(k:FlxKey) {
		var arr = ClientPrefs.keyBinds.get(captureBind.control);
		if (arr != null) {
			arr[captureBind.index] = k;
			ClientPrefs.clearInvalidKeys(captureBind.control);
		}
	}

	function captureGamepad() {
		if (FlxG.gamepads.anyJustPressed(FlxGamepadInputID.B)) { endCapture(); return; }
		if (FlxG.gamepads.anyJustPressed(FlxGamepadInputID.BACK)) {
			writeGamepad(FlxGamepadInputID.NONE);
			endCapture();
			return;
		}

		var pressed:FlxGamepadInputID = FlxGamepadInputID.NONE;
		for (i in 0...FlxG.gamepads.numActiveGamepads) {
			var gp:FlxGamepad = FlxG.gamepads.getByID(i);
			if (gp != null) {
				var id:FlxGamepadInputID = gp.firstJustPressedID();
				if (id != FlxGamepadInputID.NONE) { pressed = id; break; }
			}
		}
		if (pressed != FlxGamepadInputID.NONE
			&& pressed != FlxGamepadInputID.B
			&& pressed != FlxGamepadInputID.BACK) {
			writeGamepad(pressed);
			endCapture();
		}
	}

	function writeGamepad(b:FlxGamepadInputID) {
		var arr = ClientPrefs.gamepadBinds.get(captureBind.control);
		if (arr != null) {
			arr[captureBind.index] = b;
			ClientPrefs.clearInvalidKeys(captureBind.control);
		}
	}
}

private class BindItem extends FlxText {
	public var control:String;
	public var index:Int;
	public var device:DeviceType;

	public function new(x:Float, y:Float, control:String, index:Int, device:DeviceType) {
		super(x, y, 0, "", 16);
		this.control = control;
		this.index = index;
		this.device = device;
		setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, LEFT);
		borderStyle = OUTLINE;
		borderColor = FlxColor.BLACK;
		borderSize = 1;
		updateDevice(device);
	}

	public function updateDevice(dev:DeviceType) {
		device = dev;
		if (device == DeviceType.KEYBOARD) {
			var arr = ClientPrefs.keyBinds.get(control);
			var k:FlxKey = (arr != null && index < arr.length) ? arr[index] : FlxKey.NONE;
			text = InputFormatter.getKeyName(k);
		} else {
			var arr = ClientPrefs.gamepadBinds.get(control);
			var b:FlxGamepadInputID = (arr != null && index < arr.length) ? arr[index] : FlxGamepadInputID.NONE;
			text = InputFormatter.getGamepadName(b);
		}
		color = (text == '---') ? 0xFFA0A0A0 : FlxColor.WHITE;
	}
}
