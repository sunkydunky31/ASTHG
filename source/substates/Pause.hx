package substates;

class Pause extends MusicBeatSubstate {
	var curSelected:Int = 0;
	var grpOptions:FlxTypedGroup<FlxText>;
	var options:Array<String> = [];
	var options2:Array<String> = [
		'Resume',
		'Restart',
		'Exit to Menu'
	];

	var backd:FlxBackdrop;

	override function create() {
		options = options2;
		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.scrollFactor.set();
		bg.alpha = 0.20;
		add(bg);

		var bottomFill:FlxSprite = new FlxSprite(0,FlxG.height-16).makeGraphic(1, 1, FlxColor.BLACK);
		bottomFill.scale.set(FlxG.width, 20);
		bottomFill.updateHitbox();
		add(bottomFill);

		backd = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backd.flipX = true;
		backd.x = FlxG.width - 130;
		backd.velocity.set(0, 20);
		backd.color = 0xff0c0c0c;
		add(backd);

		var fillWidth = FlxG.width - (backd.x + backd.width);
		var backdFill:FlxSprite = new FlxSprite(backd.x + backd.width, 0).makeGraphic(Std.int(fillWidth), FlxG.height, backd.color);
		add(backdFill);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		var titleTxt:FlxBitmapText = new FlxBitmapText(20, bottomFill.y - 6, Language.getPhrase("pause_title", "Paused"), Paths.fontBitmap("Roco"));
		#if (flixel >= "5.9.0")
		titleTxt.setBorderStyle(FlxTextBorderStyle.SHADOW_XY(2, 2), FlxColor.BLACK, 1, 0);
		#else
		titleTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 0);
		titleTxt.shadowOffset.set(2, 2);
		#end
		add(titleTxt);

		regenerateMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var cantUnpause:Float = 0.1;
	override function update(e:Float) {
		cantUnpause -= e;
		super.update(e);
		
		if(controls.justPressed('back')) {
			close();
			return;
		}

		if (controls.justPressed('up')) {
			changeSelection(-1);
			CoolUtil.playSound("Menu Change", true);
		}

		if (controls.justPressed('down')) {
			CoolUtil.playSound("Menu Change", true);
			changeSelection(1);
		}

		var selected:String = options[curSelected];
		if (controls.justPressed('accept') && (cantUnpause <= 0)) {
			CoolUtil.playSound("Menu Accept", true);
			switch (selected) {
				case 'Resume':
					close();
				case 'Restart':
					MusicBeatState.resetState();
				case 'Exit to Menu':
					#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
					MusicBeatState.switchState(new states.MainMenu());
			}
		}

	}

	function regenerateMenu() {
		for (i in 0...grpOptions.members.length)
		{
			var obj:FlxText = grpOptions.members[0];
			obj.kill();
			grpOptions.remove(obj, true);
			obj.destroy();
		}

		for (num => str in options) {
			var item:FlxText = new FlxText(backd.x + 67, 60, 0, Language.getPhrase("pause_"+str, str).toUpperCase());
			item.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, 0xFF404040);
			item.y += (30 * (num - (options.length / 2))) + item.size;
			item.x -= (item.width/2);
			item.ID = num;
			grpOptions.add(item);
		}
		curSelected = 0;
		changeSelection();
	}


	function changeSelection(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);
		for (num => item in grpOptions.members) {
			item.ID = num - curSelected;
			item.color = FlxColor.WHITE;

			if (item.ID == 0) {
				item.color = FlxColor.RED;
			}
		}
	}

}