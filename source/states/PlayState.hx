package states;

import objects.Character;
import objects.LifeIcon;

class PlayState extends StateManager
{
	public static var instance:PlayState;

	public var score:Int = 10;
	public var time:String = "0:00";
	public var rings:Int = 0;
	public var lives:Int = 3;

	public var hudPos:FlxPoint;

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

	public var player:Character = null;

	public var livesIcon:LifeIcon;

	override public function create() {
		instance = this;

		score = 0;
		time = "0:00";
		rings = 0;
		player = new Character(50, 50, Character.defaultPlayer);

		hudPos = new FlxPoint(8,10);

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Locale.getString('playing', "discord"), Locale.getString("playing-player", "discord", [player.json.name]), "icon", "", player.json.name.toLowerCase(), player.json.name);
		#end
		Paths.clearStoredMemory();

		
		camGame = new FlxCamera();
		camGame.visible = true;
		FlxG.cameras.add(camGame);

		camHUD = new FlxCamera();
		camHUD.visible = !ClientPrefs.data.hideHud;
		camHUD.bgColor.alpha = 0; //I hate this so much
		FlxG.cameras.add(camHUD, false);

		camFront = new FlxCamera();
		camFront.visible = true;
		camFront.bgColor.alpha = 0;
		FlxG.cameras.add(camFront, false);
		

		//playTitleCard(["#000236", "#ffff00", "#ff0000"]);

		uiGroup = new FlxSpriteGroup();
		uiGroup.cameras = [camHUD];
		add(uiGroup);
		
		// Player init
		add(player);
		camGame.follow(player, TOPDOWN, 1);
		super.create();

		var hudTxtScore:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y, Locale.getString("hud_text_score"), Paths.getAngelCodeFont("HUD"));
		hudTxtScore.scrollFactor.set();
		uiGroup.add(hudTxtScore);
		
		var hudTxtTime:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y + 16, Locale.getString("hud_text_time"), Paths.getAngelCodeFont("HUD"));
		hudTxtTime.scrollFactor.set();
		uiGroup.add(hudTxtTime);

		var hudTxtRings:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y + 32, Locale.getString("hud_text_rings"), Paths.getAngelCodeFont("HUD"));
		hudTxtRings.scrollFactor.set();
		uiGroup.add(hudTxtRings);

		scoreTxt = new FlxBitmapText(hudTxtScore.x + hudTxtScore.width + 37, hudTxtScore.y, '', Paths.getAngelCodeFont("HUD"));
		scoreTxt.scrollFactor.set();
		scoreTxt.x -= (scoreTxt.width);
		uiGroup.add(scoreTxt);

		timeTxt = new FlxBitmapText(hudTxtTime.x + hudTxtTime.width + 37, hudTxtTime.y + 16, '', Paths.getAngelCodeFont("HUD"));
		timeTxt.scrollFactor.set();
		timeTxt.x -= (timeTxt.width);
		uiGroup.add(timeTxt);

		ringsTxt = new FlxBitmapText(hudTxtRings.x + hudTxtRings.width + 37, hudTxtRings.y + 32, '', Paths.getAngelCodeFont("HUD"));
		ringsTxt.scrollFactor.set();
		ringsTxt.x -= (ringsTxt.width);
		ringsTxt.x = timeTxt.x = scoreTxt.x;
		uiGroup.add(ringsTxt);

		livesIcon = new LifeIcon(player.lifeIcon);
		livesIcon.x = hudPos.x;
		livesIcon.y = FlxG.height - 26;
		CoolUtil.applyPalette(livesIcon, [
			FlxColor.fromString(player.json.palettes[player.curPalette][0]),
			FlxColor.fromString(player.json.palettes[player.curPalette][1]),
			FlxColor.fromString(player.json.palettes[player.curPalette][2]),
			FlxColor.fromString(player.json.palettes[player.curPalette][3])
		]);
		uiGroup.add(livesIcon);
		
		livesTxt = new FlxBitmapText(livesIcon.x + livesIcon.frameWidth + 1, livesIcon.y + 3, 'livesTxt', Paths.getAngelCodeFont("HUD"));
		livesTxt.scrollFactor.set();
		uiGroup.add(livesTxt);

		#if debug
		var posX:FlxSprite = new FlxSprite(FlxG.width - 60, hudPos.y).loadGraphic(Paths.image("HUD/posX"));
		posX.color = (player.x >= 0xFFFF) ? 0xFFFF0000 :  0xFFFFFF00;
		uiGroup.add(posX);

		posXTxt = new FlxBitmapText(posX.x + posX.width + 1, posX.y, '', Paths.getAngelCodeFont("HUD"));
		uiGroup.add(posXTxt);

		var posY:FlxSprite = new FlxSprite(posX.x, hudPos.y + 13).loadGraphic(Paths.image("HUD/posY"));
		posY.color = (player.y >= 0xFFFF) ? 0xFFFF0000 : 0xFFFFFF00;
		uiGroup.add(posY);
		
		posYTxt = new FlxBitmapText(posY.x + posY.width + 1, posY.y, '', Paths.getAngelCodeFont("HUD"));
		uiGroup.add(posYTxt);
		#end

		CoolUtil.playMusic("GreenHill1");
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
		posXTxt.text = StringTools.hex(Std.int(player.x), 6);
		posYTxt.text = StringTools.hex(Std.int(player.y), 6);
		#end

		if (FlxG.keys.justPressed.SIX) { 
			rings += 10;
			CoolUtil.playSound("Ring", true);
		}

		
		updateMoves();
		super.update(elapsed);

		if (controls.justPressed('pause')) openPauseMenu();
	}

	function openPauseMenu() {
		if (FlxG.sound.music != null) FlxG.sound.music.pause();

		openSubState(new substates.Pause());
	}

	/**
		Shows the title card
		@param colors Order: Background, Bottom Backdrop, Left backdrop
	**/
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
		backdrop2.y = FlxG.height - 50;
		add(backdrop2);

		var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backdrop.color = FlxColor.fromString(colors[2]);
		backdrop.cameras = [camFront];
		add(backdrop);

		var actName:FlxBitmapText = new FlxBitmapText(FlxG.width - 90, 87, "STAGE NAME", Paths.getAngelCodeFont("Roco"));
		actName.x -= actName.width;
		actName.cameras = [camFront];
		add(actName);

		var zoneName:FlxBitmapText = new FlxBitmapText(FlxG.width - 90, 105, "ZONE", Paths.getAngelCodeFont("Roco"));
		zoneName.x -= (zoneName.width);
		zoneName.cameras = [camFront];
		add(zoneName);

		FlxTween.tween(bg2, {y: FlxG.height}, 0.4);
		FlxTween.tween(backdrop, {y: FlxG.height - 50}, 0.5);
		FlxTween.tween(backdrop2, {x: 50}, 0.5);
	}

	
	function updateMoves() {
		player.acceleration.x = 0;

		var inputUP:Bool = false;
		var inputDOWN:Bool = false;
		var inputLEFT:Bool = false;
		var inputRIGHT:Bool = false;

		inputUP = controls.pressed('up');
		inputDOWN = controls.pressed('down');
		inputLEFT = controls.pressed('left');
		inputRIGHT = controls.pressed('right');

		if (inputUP && inputDOWN)
			inputUP = inputDOWN = false;
		if (inputLEFT && inputRIGHT)
			inputLEFT = inputRIGHT = false; 

		if (inputLEFT || inputRIGHT) {
			if (inputLEFT) {
				player.facing = LEFT;
			}
			else if (inputRIGHT) {
				player.facing = RIGHT;
			}
		
			switch (player.facing) {
				case LEFT, RIGHT:
					if ((player.velocity.x != 0) && player.touching == NONE)
						player.playAnim("ANI_WALKING");

					player.acceleration.x = (player.facing == LEFT) ? -player.maxVelocity.x * 4 : player.maxVelocity.x * 4;
				case _:
			}
		}
		else {
			if (inputUP) {
				player.facing = UP;
				player.playAnim("ANI_LOOK_UP");
			}
			else if (inputDOWN) {
				player.facing = DOWN;
				player.playAnim("ANI_LOOK_DOWN");
			}
			else
				player.playAnim("ANI_STOPPED");
			
			player.velocity.x = 0;
			player.velocity.y = 0;
		}
	}
}
