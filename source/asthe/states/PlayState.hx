/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-27
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package asthe.states;

import asthe.objects.Character;
import asthe.objects.LifeIcon;
import asthe.game.HudGame;

class PlayState extends StateManager {
	public static var instance:Null<PlayState> = null;

	public var player:Character = null;
	public var hud:HudGame = null;
	var ground:AstheSprite;

	public var camGame:FlxCamera;
	public var camFront:FlxCamera;
	public var camHUD:FlxCamera;

	public var uiGroup:FlxSpriteGroup;

	override public function create() {
		//trace("Character: {0}", ClientPrefs.loadSlotData(ClientPrefs.currentSlot).character ?? "Constants.DEFAULT_CHARACTER");
		instance = this;

		player = new Character(50, 80, (ClientPrefs.loadSlotData(ClientPrefs.currentSlot).character ?? Constants.DEFAULT_CHARACTER));

		#if DISCORD_ALLOWED
		DiscordClient.changePresence({
			details: Locale.getString('playing', "discord"),
			state: Locale.getString("playing-player", "discord", [player.json.name]),
			imageSmall.text: player.json.name
		});
		#end
		Paths.clearStoredMemory();

		camGame = new FlxCamera();
		camGame.visible = true;
		FlxG.cameras.add(camGame);

		camHUD = new FlxCamera();
		camHUD.visible = !ClientPrefs.data.options.hideHud;
		camHUD.bgColor = FlxColor.TRANSPARENT; //I hate this so much
		FlxG.cameras.add(camHUD, false);

		camFront = new FlxCamera();
		camFront.visible = true;
		camFront.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camFront, false);

		uiGroup = new FlxSpriteGroup();
		uiGroup.cameras = [camHUD];
		add(uiGroup);

		// Player init
		add(player);
		camGame.follow(player, TOPDOWN, 1);
		super.create();

		hud = new HudGame(8, 6);
		uiGroup.add(hud);

		if (player != null) {
			// Override variable values ...
			hud.score = player.score;
			hud.rings = player.rings;
			hud.lives = player.lives;
		}

		ground = new AstheSprite(0,FlxG.height - 40).createGraphic(FlxG.width, 40);
		ground.immovable = true;
		add(ground);

		AstheSound.playMusic("GreenHill1");
	}

	override public function update(elapsed:Float) {
		if (FlxG.keys.justPressed.SIX) {
			player.rings += 10;
			AstheSound.playSound(ConstantSound.RING);
		}

		if (controls.AUX && player.state == JUMPING) {
			trace("called");
			(player.isSuper) ? player.untransform() : player.transform(elapsed);
		}

		player.updateMoves();
		FlxG.collide(player, ground);
		super.update(elapsed);

		if (controls.PAUSE)
			openPauseMenu();
	}

	function openPauseMenu() {
		FlxG.sound.music?.pause();

		openSubState(new asthe.substates.Pause());
	}
}
