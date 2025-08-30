package states;

import flixel.FlxSubState;
import objects.Character;
import objects.LifeIcon;
import objects.StageBase;
import backend.Stage;
import flixel.util.helpers.FlxBounds;

class PlayState extends MusicBeatState
{
	public static var score:Int = 10;
	public static var time:String = "0:00";
	public static var rings:Int = 0;
	public static var lives:Int = 3;
	public static var hudPos:FlxPoint;
	public var camGame:FlxCamera;
	public var camFront:FlxCamera;
	public var camHUD:FlxCamera;
	public var uiGroup:FlxSpriteGroup;

	var scoreTxt:FlxBitmapText;
	var timeTxt:FlxBitmapText;
	var ringsTxt:FlxBitmapText;
	var livesTxt:FlxBitmapText;
	#if debug
	var posXTxt:FlxBitmapText;
	var posYTxt:FlxBitmapText;
	#end

	public static var player:Character = null;
	public static var stageBase:StageBase = null;
	public static var stage:Stage = null;
	static var isSuper:Bool;

	public static var livesIcon:LifeIcon;

	override public function create() {
		stageBase = new StageBase("greenHill", 1);
		player = new Character(50, 50, Character.defaultPlayer);


	/*	stage = new Stage(stageBase.json.folder, StageBase.curAct);
		stage.map.loadEntities(stage.placeEntities, "entities");
		add(stage); */

		
	//	FlxG.worldBounds.copyFrom(stage.bounds);
	//	FlxG.camera.setBounds(0, 0, stage.bounds.width, stage.bounds.height, true);

		hudPos = new FlxPoint(8,10);

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_playing', "Testing PlayState"), Language.getPhrase("discordrpc_playing-player", "Playing as {1}", [player.json.name]));
		#end
		Paths.clearStoredMemory();

		
		camGame = new FlxCamera();
		camGame.visible = true;
		FlxG.cameras.add(camGame);

		camHUD = new FlxCamera();
		camHUD.visible = !ClientPrefs.data.hideHud;
		FlxG.cameras.add(camHUD, false);

		camFront = new FlxCamera();
		camFront.visible = true;
		FlxG.cameras.add(camFront, false);
		
		camHUD.bgColor.alpha = 0; //I hate this fucking little shi-
		camFront.bgColor.alpha = 0;

		//playTitleCard(["#000236", "#ffff00", "#ff0000"]);

		uiGroup = new FlxSpriteGroup();
		uiGroup.cameras = [camHUD];
		add(uiGroup);
		
		// Player init
		add(player);
		camGame.follow(player, TOPDOWN, 1);
		super.create();
		
		var hudTxt:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y, Language.getPhrase("hud_text", "Score\nTime\nRings"), Paths.fontBitmap("HUD"));
		hudTxt.scrollFactor.set();
		uiGroup.add(hudTxt);

		var hudX = hudTxt.x + hudTxt.width + 67;
		scoreTxt = new FlxBitmapText(hudX, hudTxt.y, '', Paths.fontBitmap("HUD"));
		scoreTxt.scrollFactor.set();
		scoreTxt.x -= (scoreTxt.width);
		uiGroup.add(scoreTxt);

		timeTxt = new FlxBitmapText(hudX, hudTxt.y + 16, '', Paths.fontBitmap("HUD"));
		timeTxt.scrollFactor.set();
		timeTxt.x -= (timeTxt.width);
		uiGroup.add(timeTxt);

		ringsTxt = new FlxBitmapText(hudX, hudTxt.y + 32, '', Paths.fontBitmap("HUD"));
		ringsTxt.scrollFactor.set();
		ringsTxt.x -= (ringsTxt.width);
		uiGroup.add(ringsTxt);

		livesIcon = new LifeIcon(player.lifeIcon);
		livesIcon.x = hudPos.x;
		livesIcon.y = FlxG.height - 26;
		uiGroup.add(livesIcon);
		
		livesTxt = new FlxBitmapText(livesIcon.x + livesIcon.frameWidth + 1, livesIcon.y + 3, 'livesTxt', Paths.fontBitmap("HUD"));
		livesTxt.scrollFactor.set();
		uiGroup.add(livesTxt);

		#if debug
		var posX:FlxSprite = new FlxSprite(FlxG.width - 60, hudPos.y).loadGraphic(Paths.image("HUD/posX"));
		posX.color = (player.x >= 0xFFFF) ? 0xFFFF0000 :  0xFFFFFF00;
		uiGroup.add(posX);

		posXTxt = new FlxBitmapText(posX.x + posX.width + 1, posX.y, '', Paths.fontBitmap("HUD"));
		uiGroup.add(posXTxt);

		var posY:FlxSprite = new FlxSprite(posX.x, hudPos.y + 13).loadGraphic(Paths.image("HUD/posY"));
		posY.color = (player.y >= 0xFFFF) ? 0xFFFF0000 : 0xFFFFFF00;
		uiGroup.add(posY);
		posYTxt = new FlxBitmapText(posY.x + posY.width + 1, posY.y, '', Paths.fontBitmap("HUD"));
		uiGroup.add(posYTxt);
		#end

		CoolUtil.playMusic(stageBase.jsonAct.music, {sample: stageBase.jsonAct.musicLoop[0], hz: stageBase.jsonAct.musicLoop[1]});
	}

	override public function update(elapsed:Float) {
		if (rings > 999) rings = 999;
		else if (rings < 0) rings = 0;

		if (lives > 99) lives = 99;
		else if (lives < 0) lives = 0;

		scoreTxt.text = Std.string(score * 10);
		timeTxt.text = Std.string(time);
		ringsTxt.text = Std.string(rings);
		livesTxt.text = Std.string(lives);
		
		#if debug
		posXTxt.text = StringTools.hex(Std.int(player.x), 4);
		posYTxt.text = StringTools.hex(Std.int(player.y), 4);
		#end
		livesIcon.animation.curAnim.curFrame = (isSuper == true) ? 1 : 0;
		
		if (FlxG.keys.justPressed.NINE && isSuper == false) {
			isSuper = true;
		}
		else if (FlxG.keys.justPressed.NINE && isSuper == true) {
			isSuper = false;
		}

		if (FlxG.keys.justPressed.SIX) { 
			rings += 10;
			CoolUtil.playSound("Ring", true);
		}
		super.update(elapsed);

		if (controls.justPressed('pause')) openPauseMenu();
	}

	function openPauseMenu() {
		if (FlxG.sound.music != null) FlxG.sound.music.pause();

		openSubState(new substates.Pause());
	}

	/**
	 * Shows the title card
	 * @param colors Order: Background, Bottom Backdrop, Left backdrop
	 */
	public function playTitleCard(colors:Array<String>) {
		// Sonic 2 title card because yes

		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xff000000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.cameras = [camFront];
		add(bg);

		var bg2:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.fromString(colors[0]));
		bg2.scale.set(FlxG.width, FlxG.height);
		bg2.updateHitbox();
		bg2.cameras = [camFront];
		add(bg2);
		
		var backdrop2:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backdrop2.color = FlxColor.fromString(colors[1]);
		backdrop2.cameras = [camFront];
		backdrop2.y = FlxG.width - 50;
		add(backdrop2);

		var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backdrop.color = FlxColor.fromString(colors[2]);
		backdrop.cameras = [camFront];
		add(backdrop);

		var actName:FlxBitmapText = new FlxBitmapText(FlxG.width - 90, 87, stageBase.jsonAct.titleCard, Paths.fontBitmap("Roco"));
		actName.x -= actName.width;
		actName.cameras = [camFront];
		add(actName);

		var zoneName:FlxBitmapText = new FlxBitmapText(FlxG.width - 90, 105, "ZONE", Paths.fontBitmap("Roco"));
		zoneName.x -= (zoneName.width);
		zoneName.cameras = [camFront];
		add(zoneName);

		FlxTween.tween(bg2, {y: FlxG.height}, 0.4);
		FlxTween.tween(backdrop, {y: FlxG.height - 50}, 0.5);
		FlxTween.tween(backdrop2, {x: 50}, 0.5);
	}

}
