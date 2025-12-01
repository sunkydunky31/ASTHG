package backend;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import states.Init;

// Add a variable here and it will get automatically saved
@:structInit class SaveVariables {
	public var gameplaySettings:Map<String, Dynamic> = [
		'practice' => false
	];
	
	// ----------- System -----------
	public var cacheOnGPU:Bool = #if !switch false #else true #end; //From Stilic
	public var checkForUpdates:Bool = true;
	public var discordRPC:Bool = #if DISCORD_ALLOWED true #else false #end;
	public var haptics:Bool = true;
	public var language:String = 'en-US'; //Default

	// ----------- Graphics -----------
	public var backLayers:Float = 0.0;
	public var framerate:Int = 60;
	public var lowQuality:Bool = false;
	public var showFPS:Bool = false;

	// ----------- Gameplay -----------
	public var autoPause:Bool = true;
	public var flashing:Bool = true;
	public var hideHud:Bool = false;
}

class ClientPrefs {
	public static var data:SaveVariables = {};
	public static var defaultData:SaveVariables = {};

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'up'			=> [UP],
		'left'			=> [LEFT],
		'down'			=> [DOWN],
		'right'			=> [RIGHT],
		
		'accept'		=> [A],
		'back'			=> [S],
		'jump'			=> [D],
		'auxiliar'		=> [W],
		'pause'			=> [ENTER],
		
		'volume_mute'	=> [NUMPADZERO],
		'volume_up'		=> [NUMPADPLUS],
		'volume_down'	=> [NUMPADMINUS],
	];
	public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [		
		'up'			=> [DPAD_UP],
		'left'			=> [DPAD_LEFT],
		'down'			=> [DPAD_DOWN],
		'right'			=> [DPAD_RIGHT],
		
		'accept'		=> [X],
		'jump'			=> [A],
		'back'			=> [B],
		'auxiliar'		=> [Y],
		'pause'			=> [START],
	];

	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;

	private static var importantMap:Map<String, Array<String>> =
	[
		"flixelSound" => ["volume"]
	];

	public static function resetKeys(controller:Null<Bool> = null) //Null = both, False = Keyboard, True = Controller
	{
		if(controller != true)
			for (key in keyBinds.keys())
				if(defaultKeys.exists(key))
					keyBinds.set(key, defaultKeys.get(key).copy());

		if(controller != false)
			for (button in gamepadBinds.keys())
				if(defaultButtons.exists(button))
					gamepadBinds.set(button, defaultButtons.get(button).copy());
	}

	public static function clearInvalidKeys(key:String)
	{
		var keyBind:Array<FlxKey> = keyBinds.get(key);
		var gamepadBind:Array<FlxGamepadInputID> = gamepadBinds.get(key);
		while(keyBind != null && keyBind.contains(NONE)) keyBind.remove(NONE);
		while(gamepadBind != null && gamepadBind.contains(NONE)) gamepadBind.remove(NONE);
	}

	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
	}

	public static function saveSettings() {
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		#if ACHIEVEMENTS_ALLOWED Achievements.save(); #end
		FlxG.save.flush();

		//Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		save.data.keyboard = keyBinds;
		save.data.gamepad = gamepadBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

		for (key in Reflect.fields(data))
			if (key != 'gameplaySettings' && Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));

		#if (!html5 && !switch)
		FlxG.autoPause = ClientPrefs.data.autoPause;


		if(FlxG.save.data.framerate == null) {
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			data.framerate = Std.int(FlxMath.bound(refreshRate, 60, 240));
		}
		#end

		if(data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = data.framerate;
			FlxG.drawFramerate = data.framerate;
		}
		else
		{
			FlxG.drawFramerate = data.framerate;
			FlxG.updateFramerate = data.framerate;
		}

		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
				data.gameplaySettings.set(name, value);
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		#if DISCORD_ALLOWED DiscordClient.check(); #end

		// controls on a separate save file
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		if(save != null)
		{
			if(save.data.keyboard != null)
			{
				var loadedControls:Map<String, Array<FlxKey>> = save.data.keyboard;
				for (control => keys in loadedControls)
					if(keyBinds.exists(control)) keyBinds.set(control, keys);
			}
			if(save.data.gamepad != null)
			{
				var loadedControls:Map<String, Array<FlxGamepadInputID>> = save.data.gamepad;
				for (control => keys in loadedControls)
					if(gamepadBinds.exists(control)) gamepadBinds.set(control, keys);
			}
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic = null, ?customDefaultValue:Bool = false):Dynamic
	{
		if(!customDefaultValue) defaultValue = defaultData.gameplaySettings.get(name);
		return /*PlayState.isStoryMode ? defaultValue : */ (data.gameplaySettings.exists(name) ? data.gameplaySettings.get(name) : defaultValue);
	}
	public static function reloadVolumeKeys()
	{
		Init.muteKeys = keyBinds.get('volume_mute').copy();
		Init.volumeDownKeys = keyBinds.get('volume_down').copy();
		Init.volumeUpKeys = keyBinds.get('volume_up').copy();
		toggleVolumeKeys(true);
	}
	public static function toggleVolumeKeys(?turnOn:Bool = true)
	{
		FlxG.sound.muteKeys = turnOn ? Init.muteKeys : [];
		FlxG.sound.volumeDownKeys = turnOn ? Init.volumeDownKeys : [];
		FlxG.sound.volumeUpKeys = turnOn ? Init.volumeUpKeys : [];
	}
}
