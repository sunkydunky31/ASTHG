package asthg.base;

import asthg.backend.StateManager;

class MenuBaseState extends StateManager {
	public var selected:Int = 0;
	public var options:Array<String> = [];
	public var grpOptions:FlxTypedGroup<Dynamic>;

	public var scrollCamera:Bool = false;
	public var camScroll:FlxCamera;
	public var camFollow:FlxObject = new FlxObject(FlxG.width / 2, 0, 2, 2);
	public var camMargin:Float = 100;

	#if DISCORD_ALLOWED
	public var discordParams:DiscordClient.DiscordParameters;
	#end

	override function create():Void {
		super();
		#if DISCORD_ALLOWED
		if (discordParams != null) {
			DiscordClient.changePresence(discordParams);
		}
		#end

		if (scrollCamera) {
			camFront = new FlxCamera();
			camFront.bgColor = 0x00000000;
			FlxG.cameras.add(camFront, false);

			camFront.deadzone.set(0, margin, camFront.width, camFront.height - margin * 2);
			camFront.minScrollY = 0;
		}

	}

	override function update(e:Float):Void {
		super.update(e);

		if (controls.ACCEPT) {
			onAccept();
		}

		if (controls.BACK) {
			onAccept();
		}
	}

	/**
		Event triggered when user press ACCEPT keybind
	**/
	public function onAccept():Void {}

	/**
		Event triggered when user press BACK keybind
	**/
	public function onBack():Void {}

	public function changeItem(change:Int = 0) {
		selected = FlxMath.wrap(selected + change, 0, gprOptions.length - 1);

		if (scrollCamera) {
			var opt = grpOptions.members[selected],
			optLast = grpOptions.members[grpOptions.length - 1];

			camFollow.y = FlxMath.bound(opt.y + (opt.height / 2) - (FlxG.height / 2), 0, (optLast.y + optLast.height - FlxG.height));
		}
	}
}