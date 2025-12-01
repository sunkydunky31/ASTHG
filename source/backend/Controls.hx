package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;

class Controls
{
	//Gamepad & Keyboard stuff
	public var keyboardBinds:Map<String, Array<FlxKey>>;
	public var gamepadBinds:Map<String, Array<FlxGamepadInputID>>;
	public function justPressed(key:String) {
		var result:Bool = (FlxG.keys.anyJustPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true;
	}

	/**
		Rumble a controller or vibrate an cell phone
		@param low (Strong) Low Frequence motor, period if on mobile
		@param high (Weak) High frequence motor.
		@param duration Duration of the vibration
		@author Sunkydev31
	**/
	public function vibrate(low:Float, high:Float, duration:Int) {
		#if (lime >= "8.3.0")
		if (controllerMode) {
			for (id in lime.ui.Gamepad.devices.keys()) {
				var pad = lime.ui.Gamepad.devices.get(id);
				if (pad != null) pad.rumble(low, high, duration);
			}
			return;
		}
		#end

		return lime.ui.Haptic.vibrate(Std.int(low), duration);
		
	}

	public function pressed(key:String) {
		var result:Bool = (FlxG.keys.anyPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadPressed(gamepadBinds[key]) == true;
	}

	public function justReleased(key:String) {
		var result:Bool = (FlxG.keys.anyJustReleased(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true;
	}

	public var controllerMode:Bool = false;
	private function _myGamepadJustPressed(keys:Array<FlxGamepadInputID>):Bool {
		if(keys != null) {
			for (key in keys) {
				if (FlxG.gamepads.anyJustPressed(key) == true) {
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadPressed(keys:Array<FlxGamepadInputID>):Bool {
		if(keys != null) {
			for (key in keys) {
				if (FlxG.gamepads.anyPressed(key) == true) {
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadJustReleased(keys:Array<FlxGamepadInputID>):Bool {
		if(keys != null) {
			for (key in keys) {
				if (FlxG.gamepads.anyJustReleased(key) == true) {
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}

	// IGNORE THESE
	public static var instance:Controls;
	public function new() {
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}
}