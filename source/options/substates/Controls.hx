package options.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

import backend.InputFormatter;

enum abstract DeviceType(Int) {
	var KEYBOARD = 0;
	var GAMEPAD = 1;
}

class Controls extends SubStateManager {
	var currentDevice:DeviceType = DeviceType.KEYBOARD;

	/**Move Left
	 * List of keybinds
	 * 
	 * Column 1: Keybind ID,
	 * Cmlumn 2: Name in the menu 
	 */
	var controlList:Array<String> = [
		'up', 'left', 'down', 'right',
		'auxiliar', 'jump', 'accept', 'back',
		'pause',
		'volume_mute', 'volume_up', 'volume_down'
	];


	var labels:Array<FlxText> = [];
	var binds:Array<Array<BindItem>> = [];

	var row:Int = 0;
	var col:Int = 0;

	var capturing:Bool = false;
	var captureBind:BindItem;

	var prompt:FlxText;
	var dim:FlxSprite;

	public function new() {
		super();
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.updateHitbox();
		add(bg);
		
		var title:FlxBitmapText = new FlxBitmapText(FlxG.width/2, 8, Locale.getString("options_controls", "options"), Paths.getAngelCodeFont("Roco"));
		title.x -= title.width/2;
		add(title);

		var y:Float = 30;
		for (ctrl in controlList) {
			var lbl = new FlxText(30, y, 0, Locale.getString('key_$ctrl', 'options'), 16);
			lbl.font = Paths.font("Mania.ttf");
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

		dim = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		dim.alpha = 0.9;
		dim.visible = false;
		add(dim);

		prompt = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2 - 38, 0, "", 16);
		prompt.alignment = CENTER;
		prompt.font = Paths.font("Mania.ttf");
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
			if (controls.justPressed('up')) { 
				row = (row - 1 + binds.length) % binds.length;
				updateSelection();
				CoolUtil.playSound("MenuChange");
			}
			if (controls.justPressed('down')) {
				row = (row + 1) % binds.length;
				updateSelection();
				CoolUtil.playSound("MenuChange");
			}
			if (controls.justPressed('left')) {
				col = (col - 1 + 2) % 2;
				updateSelection();
				CoolUtil.playSound("MenuChange");
			}
			if (controls.justPressed('right')) {
				col = (col + 1) % 2; updateSelection(); 
				CoolUtil.playSound("MenuChange");
			}

			if (controls.justPressed('accept')) {
				startCapture(binds[row][col]);
				CoolUtil.playSound("MenuAccept");
			}
			if (FlxG.keys.justPressed.TAB) {
				currentDevice = (currentDevice == DeviceType.KEYBOARD ? DeviceType.GAMEPAD : DeviceType.KEYBOARD);
				refreshLabels();
				updateSelection();
				CoolUtil.playSound("MenuAccept");
			}
			if (controls.justPressed('back')) close();
		}
		else {
			if (currentDevice == DeviceType.KEYBOARD) captureKeyboard();
			else captureGamepad();
		}
	}

	function startCapture(b:BindItem) {
		capturing = true;
		captureBind = b;
		dim.visible = true;
		prompt.visible = true;
		prompt.text = (currentDevice == DeviceType.KEYBOARD)
			? Locale.getString("keybind_change", "options", [InputFormatter.getKeyName(FlxKey.ESCAPE), InputFormatter.getKeyName(FlxKey.DELETE)])
			: Locale.getString("keybind_change_gamepad", "options", [InputFormatter.getGamepadName(FlxGamepadInputID.B), InputFormatter.getGamepadName(FlxGamepadInputID.BACK)]);
	}

	function endCapture() {
		capturing = false;
		captureBind = null;
		dim.visible = false;
		prompt.visible = false;
		refreshLabels();
	}

	function captureKeyboard() {
		if (FlxG.keys.justPressed.ESCAPE) {
			endCapture();
			CoolUtil.playSound("MenuCancel");
			return;
		}
		if (FlxG.keys.justPressed.DELETE) {
			CoolUtil.playSound("MenuCancel");
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
			CoolUtil.playSound("MenuChange");
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
