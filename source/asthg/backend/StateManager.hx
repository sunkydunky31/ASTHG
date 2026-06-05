//@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/MusicBeatState.hx

package asthg.backend;

import flixel.FlxState;

class StateManager extends FlxState {
public var controls(get, never):Controls;
	private function get_controls() {
		return Controls.instance;
	}

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static function getVariables()
		return getState().variables;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;

		super.create();

		if(!skip) openSubState(new CustomFadeTransition(0.5, true));
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;
	}

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float) {
		if (FlxG.save.data?.fullscreen != null)
			FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);

		if (FlxG.keys.justPressed.F5) {
			hotReload();
		}

	}

	public static function hotReload() {
			trace("HOT RELOAD");
			Paths.clearStoredMemory();
			Paths.clearUnusedMemory();
			Locale.init();
			SystemUtil.ACCENT_COLOR = SystemUtil.loadAccentColor();
			resetState();
			return;
	}

	public static function switchState(nextState:FlxState = null) {
		nextState ??= FlxG.state;

		if(nextState == FlxG.state) {
			resetState();
			return;
		}

		if(FlxTransitionableState.skipNextTransIn) {
			#if (flixel < "5.6.0") // Reading "nextState", in the docs, says that this is deprecated but without any warning...
			FlxG.switchState(nextState);
			#else
			FlxG.switchState(() -> nextState);
			#end
		}
		else {
			startTransition(nextState);
		}
		FlxTransitionableState.skipNextTransIn = false;
	}

	public static function resetState() {
		if(FlxTransitionableState.skipNextTransIn)
			FlxG.resetState();
		else
			startTransition();
		FlxTransitionableState.skipNextTransIn = false;
	}

	// Custom made Trans in
	public static function startTransition(nextState:FlxState = null) {
		nextState ??= FlxG.state;

		FlxG.state.openSubState(new CustomFadeTransition(0.5, false));
		if(nextState == FlxG.state)
			CustomFadeTransition.finishCallback = function() FlxG.resetState();
		else
			CustomFadeTransition.finishCallback = function() {
				#if (flixel < "5.6.1") // Already deprecated in this version, but without any warning...
				FlxG.switchState(nextState);
				#else
				FlxG.switchState(() -> nextState);
				#end
			}
	}

	public static function getState():StateManager {
		return cast (FlxG.state, StateManager);
	}
}
