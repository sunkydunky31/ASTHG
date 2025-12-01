package backend;

import openfl.display3D.textures.RectangleTexture;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;

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
				for (i in 0...arr.length) arr[i] = CoolUtil.capitalize(arr[i]);
				return arr.join(' ');
		}
	}

	public static function getGamepadName(key:FlxGamepadInputID):String {
		var gamepad:FlxGamepad = FlxG.gamepads.firstActive;
		var model:FlxGamepadModel = gamepad != null ? gamepad.detectedModel : UNKNOWN;

		switch(key) {
			// Analogs
			case LEFT_STICK_DIGITAL_LEFT: return "Left";
			case LEFT_STICK_DIGITAL_RIGHT: return "Right";
			case LEFT_STICK_DIGITAL_UP: return "Up";
			case LEFT_STICK_DIGITAL_DOWN: return "Down";
			case LEFT_STICK_CLICK:
				switch (model) {
					case PS4, PSVITA: return "L3";
					case XINPUT: return "LS";
					default: return "Analog Click";
				}

			case RIGHT_STICK_DIGITAL_LEFT: return "C. Left";
			case RIGHT_STICK_DIGITAL_RIGHT: return "C. Right";
			case RIGHT_STICK_DIGITAL_UP: return "C. Up";
			case RIGHT_STICK_DIGITAL_DOWN: return "C. Down";
			case RIGHT_STICK_CLICK:
				switch (model) {
					case PS4, PSVITA: return "R3";
					case XINPUT: return "RS";
					default: return "C. Click";
				}

			// Directional
			case DPAD_LEFT: return "D. Left";
			case DPAD_RIGHT: return "D. Right";
			case DPAD_UP: return "D. Up";
			case DPAD_DOWN: return "D. Down";

			// Top buttons
			case LEFT_SHOULDER:
				switch(model) {
					case PS4, PSVITA: return "L1";
					case XINPUT: return "LB";
					default: return Locale.getString("flxgamepad_lshoulder", "input");
				}
			case RIGHT_SHOULDER:
				switch(model) {
					case PS4, PSVITA: return "R1";
					case XINPUT: return "RB";
					default: return Locale.getString("flxgamepad_rshoulder", "input");
				}
			case LEFT_TRIGGER, LEFT_TRIGGER_BUTTON:
				switch(model) {
					case PS4, PSVITA: return "L2";
					case XINPUT: return "LT";
					default: return Locale.getString("flxgamepad_ltrigger", "input");
				}
			case RIGHT_TRIGGER, RIGHT_TRIGGER_BUTTON:
				switch(model) {
					case PS4, PSVITA: return "R2";
					case XINPUT: return "RT";
					default: return Locale.getString("flxgamepad_rtrigger", "input");
				}

			// Buttons
			case A:
				switch (model) {
					case PS4, PSVITA: return Locale.getString("flxgamepad_ps_a", "input");
					case XINPUT: return "A";
					case OUYA: return "O";
					default: return Locale.getString("flxgamepad_a", "input");
				}
			case B:
				switch (model) {
					case PS4, PSVITA: return Locale.getString("flxgamepad_ps_b", "input");
					case XINPUT: return "B";
					case OUYA: return "A";
					default: return Locale.getString("flxgamepad_b", "input");
				}
			case X:
				switch (model) {
					case PS4, PSVITA: return Locale.getString("flxgamepad_ps_x", "input");
					case XINPUT: return "X";
					case OUYA: return "U";
					default: return Locale.getString("flxgamepad_x", "input");
				}
			case Y:
				switch (model) { 
					case PS4, PSVITA: return Locale.getString("flxgamepad_ps_y", "input");
					case XINPUT: return "Y";
					case OUYA: return "Y";
					default: return Locale.getString("flxgamepad_y", "input");
				}

			case BACK:
				switch(model) {
					case PS4: return Locale.getString("flxgamepad_ps4_back", "input");
					case XINPUT: return Locale.getString("flxgamepad_xbox_back", "input");
					default: return Locale.getString("flxgamepad_back", "input");
				}
			case START:
				switch(model) {
					case PS4: return Locale.getString("flxgamepad_ps4_start", "input");
					default: return Locale.getString("flxgamepad_start", "input");
				}

			case NONE: return '---';

			default:
				var label:String = Std.string(key);
				if(label.toLowerCase() == 'null') return '---';

				var arr:Array<String> = label.split('_');
				for (i in 0...arr.length) arr[i] = CoolUtil.capitalize(arr[i]);
				return arr.join(' ');
		}
	}

	public static function getControlNames(k:String):String {
		var arr:Dynamic;
		var b:Dynamic;
		
		if (Controls.instance.controllerMode) {
			arr = ClientPrefs.gamepadBinds.get(k);
			b = (arr != null && arr.length > 0) ? arr[0] : FlxGamepadInputID.NONE;
		}
		else {
			arr = ClientPrefs.keyBinds.get(k);
			b = (arr != null && arr.length > 0) ? arr[0] : FlxKey.NONE;
		}
	
		return (Controls.instance.controllerMode) ? getGamepadName(b) : getKeyName(b);
	}


}