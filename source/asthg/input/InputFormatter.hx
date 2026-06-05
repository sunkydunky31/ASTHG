package asthg.input;

import openfl.display3D.textures.RectangleTexture;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;

/**
	@see[Original Source](https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/InputFormatter.hx)
**/
class InputFormatter {
	public static function getKeyName(key:FlxKey):String {
		switch (key) {
			case BACKSPACE: return "BckSpc";
			case CONTROL: return "Ctrl";
			case ALT: return "Alt";
			case CAPSLOCK: return "Caps";
			case PAGEUP: return "PgUp";
			case PAGEDOWN: return "PgDown";
			case ZERO: return "0";
			case ONE: return "1";
			case TWO: return "2";
			case THREE: return "3";
			case FOUR: return "4";
			case FIVE: return "5";
			case SIX: return "6";
			case SEVEN: return "7";
			case EIGHT: return "8";
			case NINE: return "9";
			case NUMPADZERO: return "#0";
			case NUMPADONE: return "#1";
			case NUMPADTWO: return "#2";
			case NUMPADTHREE: return "#3";
			case NUMPADFOUR: return "#4";
			case NUMPADFIVE: return "#5";
			case NUMPADSIX: return "#6";
			case NUMPADSEVEN: return "#7";
			case NUMPADEIGHT: return "#8";
			case NUMPADNINE: return "#9";
			case NUMPADMULTIPLY: return "#*";
			case NUMPADPLUS: return "#+";
			case NUMPADMINUS: return "#-";
			case NUMPADPERIOD: return "#.";
			case SEMICOLON: return ";";
			case COMMA: return ",";
			case PERIOD: return ".";
			case SLASH: return "/";
			case GRAVEACCENT: return "`";
			case LBRACKET: return "[";
			case BACKSLASH: return "\\";
			case RBRACKET: return "]";
			case DELETE: return "Delete";
			case QUOTE: return "'";
			case PRINTSCREEN: return "PrtScrn";
			case NONE: return '---';
			default:
				var label:String = Std.string(key);
				if(label.toLowerCase() == 'null') return '---';

				var arr:Array<String> = label.split('_');
				for (i in 0...arr.length) arr[i] = StringUtil.capitalize(arr[i]);
				return arr.join(' ');
		}
	}

	public static function getGamepadName(key:FlxGamepadInputID, ?translate:Bool = false):String {
		var gamepad:FlxGamepad = FlxG.gamepads.firstActive;
		var model:FlxGamepadModel = gamepad?.detectedModel ?? UNKNOWN;

		switch(key) {
			// Analogs
			case LEFT_STICK_DIGITAL_LEFT:  return (translate) ? Locale.getString("flxgamepad_stickl_left",  "input") : "Left";
			case LEFT_STICK_DIGITAL_RIGHT: return (translate) ? Locale.getString("flxgamepad_stickl_right", "input") : "Right";
			case LEFT_STICK_DIGITAL_UP:    return (translate) ? Locale.getString("flxgamepad_stickl_up",    "input") : "Up";
			case LEFT_STICK_DIGITAL_DOWN:  return (translate) ? Locale.getString("flxgamepad_stickl_down",  "input") : "Down";
			case LEFT_STICK_CLICK:
				switch (model) {
					case PS4 | PSVITA: return "L3";
					case XINPUT: return "LS";
					default: return (translate) ? Locale.getString("flxgamepad_stickl_click", "input") : "Analog Click";
				}

			case RIGHT_STICK_DIGITAL_LEFT:  return (translate) ? Locale.getString("flxgamepad_stickr_left",  "input") : "C. Left";
			case RIGHT_STICK_DIGITAL_RIGHT: return (translate) ? Locale.getString("flxgamepad_stickr_right", "input") : "C. Right";
			case RIGHT_STICK_DIGITAL_UP:    return (translate) ? Locale.getString("flxgamepad_stickr_up",    "input") : "C. Up";
			case RIGHT_STICK_DIGITAL_DOWN:  return (translate) ? Locale.getString("flxgamepad_stickr_down",  "input") : "C. Down";
			case RIGHT_STICK_CLICK:
				switch (model) {
					case PS4 | PSVITA: return "R3";
					case XINPUT:       return "RS";
					default:           return (translate) ? Locale.getString("flxgamepad_stickr_click", "input") : "C. Click";
				}

			// Directional
			case DPAD_LEFT:  return (translate) ? Locale.getString("flxgamepad_dpad_left",  "input") : "DPad Left";
			case DPAD_RIGHT: return (translate) ? Locale.getString("flxgamepad_dpad_right", "input") : "DPad Right";
			case DPAD_UP:    return (translate) ? Locale.getString("flxgamepad_dpad_up",    "input") : "DPad Up";
			case DPAD_DOWN:  return (translate) ? Locale.getString("flxgamepad_dpad_down",  "input") : "DPad Down";

			// Top buttons
			case LEFT_SHOULDER:
				switch (model) {
					case PS4 | PSVITA: return "L1";
					case XINPUT: return "LB";
					default: return (translate) ? Locale.getString("flxgamepad_lshoulder", "input") : "L. Shoulder";
				}
			case RIGHT_SHOULDER:
				switch (model) {
					case PS4 | PSVITA: return "R1";
					case XINPUT: return "RB";
					default: return (translate) ? Locale.getString("flxgamepad_rshoulder", "input") : "R. Shoulder";
				}
			case LEFT_TRIGGER, LEFT_TRIGGER_BUTTON:
				switch (model) {
					case PS4 | PSVITA: return "L2";
					case XINPUT: return "LT";
					default: return (translate) ? Locale.getString("flxgamepad_ltrigger", "input") : "L. Trigger";
				}
			case RIGHT_TRIGGER, RIGHT_TRIGGER_BUTTON:
				switch (model) {
					case PS4 | PSVITA: return "R2";
					case XINPUT: return "RT";
					default: return (translate) ? Locale.getString("flxgamepad_rtrigger", "input") : "R. Trigger";
				}

			// Buttons
			case A:
				switch (model) {
					case PS4 | PSVITA: return (translate) ? Locale.getString("flxgamepad_ps_a", "input") : "Cross";
					case XINPUT:       return "A";
					case OUYA:         return "O";
					default:           return (translate) ? Locale.getString("flxgamepad_a",    "input") : "Action Down";
				}
			case B:
				switch (model) {
					case PS4 | PSVITA: return (translate) ? Locale.getString("flxgamepad_ps_b", "input") : "Circle";
					case XINPUT:       return "B";
					case OUYA:         return "A";
					default:           return (translate) ? Locale.getString("flxgamepad_b",    "input") : "Action Right";
				}
			case X:
				switch (model) {
					case PS4 | PSVITA: return (translate) ? Locale.getString("flxgamepad_ps_x", "input") : "Square";
					case XINPUT:       return "X";
					case OUYA:         return "U";
					default:           return (translate) ? Locale.getString("flxgamepad_x",    "input") : "Action Left";
				}
			case Y:
				switch (model) {
					case PS4 | PSVITA: return (translate) ? Locale.getString("flxgamepad_ps_y", "input") : "Triangle";
					case XINPUT:       return "Y";
					case OUYA:         return "Y";
					default:           return (translate) ? Locale.getString("flxgamepad_y",    "input") : "Action Up";
				}

			case BACK:
				switch(model) {
					case PS4:    return (translate) ? Locale.getString("flxgamepad_ps4_back",  "input") : "Share";
					case XINPUT: return (translate) ? Locale.getString("flxgamepad_xbox_back", "input") : "Back";
					default:     return (translate) ? Locale.getString("flxgamepad_back",      "input") : "Select";
				}
			case START:
				switch(model) {
					case PS4: return (translate) ? Locale.getString("flxgamepad_ps4_start", "input") : "Options";
					default:  return (translate) ? Locale.getString("flxgamepad_start",     "input") : "Start";
				}

			case NONE: return '---';

			default:
				var label:String = Std.string(key);
				if(label.toLowerCase() == 'null') return '---';

				var arr:Array<String> = label.split('_');
				for (i in 0...arr.length)
					arr[i] = StringUtil.capitalize(arr[i]);
				return arr.join(' ');
		}
	}

	/**
		Returns the name of the model of the currently active gamepad
		@return String
	**/
	public static function getModelName():String {
		var gamepad:FlxGamepad = FlxG.gamepads.firstActive;
		var model:FlxGamepadModel = gamepad?.detectedModel ?? UNKNOWN;

		if (Controls.instance.controllerMode)
			return switch (model) {
				case LOGITECH: "Logitech";
				case OUYA: "Ouya";
				case PS4: "PS4";
				case PSVITA: "PSVita";
				case XINPUT: "XInput";
				case MAYFLASH_WII_REMOTE: "Mayflash Wii Remote";
				case WII_REMOTE: "Wii Remote";
				case MFI: "MFI";
				case SWITCH_PRO: "Switch Pro";
				case SWITCH_JOYCON_LEFT: "Switch Joycon Left";
				case SWITCH_JOYCON_RIGHT: "Switch Joycon Right";
				case UNKNOWN: "Unknown";
				default: "Unknown";
			}
		else
			return "Keyboard";
	}

	/**
		Function to get a keybind/gamepad button name
		@param k The control to get(e.g. `controls.UP`)
		@return String
		@author unreal.sunnydev
	**/
	public static function getControlNames(k:InputList):String {
		var arr:Dynamic;
		var b:Dynamic;

		if (Controls.instance.controllerMode) {
			arr = ClientPrefs.gamepadBinds.get(k);
			b = !ArrayUtil.isBlank(arr) ? arr[0] : FlxGamepadInputID.NONE;
		}
		else {
			arr = ClientPrefs.keyBinds.get(k);
			b = !ArrayUtil.isBlank(arr) ? arr[0] : FlxKey.NONE;
		}

		return (Controls.instance.controllerMode) ? getGamepadName(b) : getKeyName(b);
	}
}