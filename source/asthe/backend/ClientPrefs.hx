//@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/ClientPrefs.hx

package asthe.backend;

import asthe.input.InputList;
import asthe.states.Init;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

/**
	Central manager of player preferences.

	Responsable for loading, saving, and managing all game settings and player data

	Basic use:
	```haxe
	ClientPrefs.loadPrefs();
	ClientPrefs.data.options.framerate = 120;
	ClientPrefs.saveSettings();
	```
**/
class ClientPrefs {
	/**
		Player's actual preference data.
		Always sincronized of what is saved (post `saveSettings`).
	**/
	public static var data:SaveVariables = {};

	/**
		Preferences default data.
		Used when reset to default data.
	**/
	public static var defaultData:SaveVariables = {};

	public static var keyBinds:Map<InputList, Array<FlxKey>> = [
		UP          => [UP],
		LEFT        => [LEFT],
		DOWN        => [DOWN],
		RIGHT       => [RIGHT],

		ACCEPT      => [A],
		BACK        => [S],
		JUMP        => [D],
		AUXILIAR    => [W],
		PAUSE       => [ENTER],

		VOLUME_MUTE => [NUMPADZERO],
		VOLUME_UP   => [NUMPADPLUS],
		VOLUME_DOWN => [NUMPADMINUS],
	];

	public static var gamepadBinds:Map<InputList, Array<FlxGamepadInputID>> = [
		UP          => [DPAD_UP],
		LEFT        => [DPAD_LEFT],
		DOWN        => [DPAD_DOWN],
		RIGHT       => [DPAD_RIGHT],

		ACCEPT      => [A],
		JUMP        => [X],
		BACK        => [B],
		AUXILIAR    => [Y],
		PAUSE       => [START],
	];

	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;

	private static var gameSave:FlxSave;
	public static var gameplay:Null<GameData>;
	public static var currentSlot:Int = -1;

	/** @see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/CoolUtil.hx#L161 **/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		return CoolUtil.getProjectInfo('company') #if (flixel < "5.0.0") + "/" + FlxSave.validate(CoolUtil.getProjectInfo('file')) #end;

	}

	public static function resetKeys(controller:Null<Bool> = null) {
		if(controller == null || controller == false) {
			for (key in keyBinds.keys())
				if(defaultKeys != null && defaultKeys.exists(key))
					keyBinds.set(key, defaultKeys.get(key).copy());
		}
		if(controller == null || controller == true) {
			for (button in gamepadBinds.keys())
				if(defaultButtons != null && defaultButtons.exists(button))
					gamepadBinds.set(button, defaultButtons.get(button).copy());
		}
	}

	public static function clearInvalidKeys(key:String) {
		var keyBind:Array<FlxKey> = keyBinds.get(key);
		var gamepadBind:Array<FlxGamepadInputID> = gamepadBinds.get(key);
		while(!ArrayUtil.isBlank(keyBind) && keyBind.contains(NONE)) keyBind.remove(NONE);
		while(!ArrayUtil.isBlank(gamepadBind) && gamepadBind.contains(NONE)) gamepadBind.remove(NONE);
	}

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
	}

	/** Function used to save all preferences. **/
	public static function saveSettings() {
		try {
			for (key in Reflect.fields(data))
				Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));
			FlxG.save.flush();

			// Controls data
			var save:FlxSave = new FlxSave();
			save.bind('controls', getSavePath());
			save.data.keyboard = keyBinds;
			save.data.gamepad = gamepadBinds;
			save.flush();

			FlxG.log.add("Saved preferences!");
		} catch(e:Dynamic) {
			FlxG.log.error("Error when saving preferences: " + e);
		}
	}

	public static function loadPrefs() {
		try {
			for (key in Reflect.fields(data)) {
				if (Reflect.hasField(FlxG.save.data, key)) {
					Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
				}
			}

			#if (!html5 && !switch)
			FlxG.autoPause = ClientPrefs.data.options.autoPause;

			if(FlxG.save.data.framerate == null) {
				final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
				data.options.framerate = Std.int(MathUtil.clamp(refreshRate, 60, 240));
			}
			#end

			var targetFramerate = data.options.framerate;
			FlxG.drawFramerate = targetFramerate;
			FlxG.updateFramerate = targetFramerate;

			if(FlxG.save.data.volume != null)
				FlxG.sound.volume = FlxG.save.data.volume;
			if (FlxG.save.data.mute != null)
				FlxG.sound.muted = FlxG.save.data.mute;

			#if DISCORD_ALLOWED DiscordClient.check(); #end

			var save:FlxSave = new FlxSave();
			save.bind('controls', getSavePath());

			if (save?.data?.keyboard != null) {
				var loadedControls:Map<InputList, Array<Dynamic>> = save.data.keyboard;
				for (control => rawKeys in loadedControls) {
					if (!keyBinds.exists(control) || rawKeys == null) continue;
					var keys:Array<FlxKey> = [];
					for (raw in rawKeys) if (raw != null) keys.push(cast raw);
					if (keys.length > 0) keyBinds.set(control, keys);
				}
			}

			if (save?.data?.gamepad != null) {
				var loadedControls:Map<InputList, Array<Dynamic>> = save.data.gamepad;
				for (control => rawKeys in loadedControls) {
					if (!gamepadBinds.exists(control) || rawKeys == null)
						continue;

					var keys:Array<FlxGamepadInputID> = [];
					for (raw in rawKeys)
						if (raw != null)
							keys.push(cast raw);

					if (keys.length > 0)
						gamepadBinds.set(control, keys);
				}
			}

			trace("Loaded preferences!".info());
		}
		catch(e:Dynamic) {
			trace("Error when loading preferences: {0}".error(), e);
		}
	}

	public static function reloadVolumeKeys() {
		Init.muteKeys       = keyBinds.get(VOLUME_MUTE) ?? [];
		Init.volumeDownKeys = keyBinds.get(VOLUME_DOWN) ?? [];
		Init.volumeUpKeys   = keyBinds.get(VOLUME_UP)   ?? [];
		toggleVolumeKeys(true);
	}

	public static function toggleVolumeKeys(?turnOn:Bool = true) {
		FlxG.sound.muteKeys       = turnOn ? Init.muteKeys       : [];
		FlxG.sound.volumeDownKeys = turnOn ? Init.volumeDownKeys : [];
		FlxG.sound.volumeUpKeys   = turnOn ? Init.volumeUpKeys   : [];
	}

	public static function resetAllSettings() {
		try {
			data = defaultData;
			keyBinds = defaultKeys;
			gamepadBinds = defaultButtons;
			saveSettings();
			trace("Reset all settings to default values!".warn());
		}
		catch(e:Dynamic) {
			trace("Error when resetting preferences: {0}".error(), e);
		}
	}

	// ----------- GAMEPLAY SAVE DATA ----------- //

	public static function createSlot(slot:Int, char:String):Void {
		currentSlot = slot;

		gameSave = new FlxSave();
		gameSave.bind("slot" + slot, getSavePath());

		gameplay = {
			character: char,
			emeralds: [false, false, false, false, false, false, false],
			zoneId: 0, zoneAct: 0,
			clear: false
		}

		gameSave.data.gameplay = gameplay;
		gameSave.flush();
	}

	public static function saveSlot():Void {
		if (gameSave == null){
			throw("Cannot save game data! Slot is null".error());
		}

		gameSave.bind("slot" + currentSlot, getSavePath());
		gameSave.data.gameplay = gameplay;
		gameSave.flush();
	}

	public static function loadSlot(slot:Int) {
		currentSlot = slot;
		if (gameSave == null)
			gameSave = new FlxSave();

		gameSave.bind("slot" + slot, getSavePath());

		gameplay = gameSave.data.gameplay;
	}

	/**
		Loads an slot data without overriding global parameters
		@param slot Save slot to read
		@return GameData
	**/
	public static function loadSlotData(slot:Int):GameData {
		var save = new FlxSave();
		save.bind("slot" + slot, getSavePath());

		return save.data.gameplay;
	}

	public static function deleteSlot(slot:Int):Void {
		var save = new FlxSave();
		save.bind("slot" + slot, getSavePath());

		save.erase();
	}

	public static function slotExists(slot:Int):Bool {
		var save = new FlxSave();
		save.bind("slot" + slot, getSavePath());

		return save.data.gameplay != null;
	}
}

/**
	Structure that stores all player preferences.
	This is the main class that will be serialized and saved to disk.
	To add a new configuration, simply add a variable here.
**/
@:structInit class SaveVariables {
	/**
		Version of the save data format.
		Increment this number when changing the data structure.
		Current: `2.0.0`
	**/
	public var version:String = "2.0.0";

	// --------- Settings --------- //
	public var options:OptionsPrefs = {};
	public var mods:ModPrefs = {};
}

/**
	Stores options preferences of the Options menu
**/
@:structInit class OptionsPrefs {
	// ---- DISPLAY ---- //

	/**
		Framerate of the game. Unused by now
		@default `60`
	**/
	public var framerate:Int = 60;

	/**
		Used for applying a black layer on the backgrounds, leaving it more darker.
		@default `0.0`
	**/
	public var backLayers:Float = 0.0;

	/**
		Actually, this is unused
		@default `false`
	**/
	public var lowQuality:Bool = false;

	/**
		Actually unused, platform problems
		@default `false`
	**/
	public var showFPS:Bool = false;

	/**
		If enabled, shaders will be applyied on supported platforms, enhancing visual effects.
		@default `true`
	**/
	public var shaders:Bool = #if shaders_supported true #else false #end;

	/**
		If enabled, the game will use your system accent colors for certain UI elements.
		NOTE: This causes the game to freeze by ~3 seconds when loading the color.
		@default `false`
	**/
	public var accentColors:Bool = false;

	// --- GAMEPLAY ---- //

	/**
		If enabled, the game pauses if the window loses focus.
		@default `true`
	**/
	public var autoPause:Bool = true;

	/**
		If enabled, flashing lights will be less intense and flickers will be reduced.
		@default `true`
	**/
	public var flashing:Bool = true;

	/**
		If enabled, the HUD will be hidden during gameplay.
		@default `false`
	**/
	public var hideHud:Bool = false;

	/**
		If enabled, the game time counter will be displayed as `0'00"00` instead of `0:00`.
		@default `false`
	**/
	public var showMiliseconds:Bool = false;

	// ---- SYSTEM ---- //

	/**
		Game language data.
		Value can be get from `FireTongue:locale` too.
		@default `"en-US"`
	**/
	public var language:String = "en-US";

	/**
		If enabled, iterates with Discord Rich Presence.
		@default `true` (Depends on `DISCORD_ALLOWED` flag)
	**/
	public var discordRPC:Bool = #if DISCORD_ALLOWED true #else false #end;

	/**
		If enabled, allows haptic feedback (mobile) / gamepad rumble.
		@default `true`
	**/
	public var haptics:Bool = true;

	/**
		If enabled, caches sprites on GPU for better performance.
		@default `true` (`false` on Switch)
	**/
	public var cacheOnGPU:Bool = #if !switch false #else true #end;

	/**
		Changes the volume of the music.
		@default `0.4`
	**/
	public var musicVolume:Float = 0.4;

	/**
		Change the volume of the sound effects
		@default `0.4`
	**/
	public var sfxVolume:Float = 0.4;
}

/**
	Structure that stores mods preferences, like enabled mods and mod-specific settings.
**/
@:structInit class ModPrefs {
	/**
		List of enabled mods by ID.
		@default `[]`
	**/
	public var enabledMods:Array<String> = [];

	/**
		Custom settings for each mod.
		Format: `"<modId>" => {<options list>}`
		@default `[]`
	**/
	public var modSettings:Map<String, Dynamic> = [];
}

@:structInit class GameData {
	/**
		Current player character in-game
		@default `sonic`
	**/
	public var character:String = Constants.DEFAULT_CHARACTER;

	/**
		List of Chaos Emeralds that this player has
		ORDER: Cyan, Red, Green, Yellow, Gray, Purple, Blue
		@default `[false, false, false, false, false, false, false]`
	**/
	public var emeralds:Array<Bool> = [false, false, false, false, false, false, false];

	/**
		Current zone that the player selected/player saved in
		@default `0`
	**/
	public var zoneId = 0;

	/**
		Current zone act that the player selected/player saved in
		@default `0`
	**/
	public var zoneAct = 0;

	/**
		The player cleared their save file?
		@default `false`
	**/
	public var clear:Bool = false;
}