package asthe.substates;

class Pause extends SubStateManager {
	public var curSelected:Int = 0;
	public var grpOptions:FlxTypedGroup<ASTHEText>;
	public var options:Array<String> = [];
	var options2:Array<String> = [
		'Resume',
		'Restart',
		'Exit to Menu'
	];

	var backd:FlxBackdrop;
	var backdFill:ASTHESprite;

	override function create() {
		options = options2;
		var bg:ASTHESprite = new ASTHESprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0.20;
		add(bg);

		var bottomFill:ASTHESprite = new ASTHESprite(0,FlxG.height-16).createGraphic(FlxG.width, 20, FlxColor.BLACK);
		add(bottomFill);

		backd = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backd.flipX = true;
		backd.x = FlxG.width - 130;
		backd.velocity.set(0, 20);
		backd.color = 0xff0c0c0c;
		add(backd);

		var fillWidth = FlxG.width - (backd.x + backd.width);
		backdFill = new ASTHESprite(backd.x + backd.width, 0).createGraphic(Std.int(fillWidth), FlxG.height, backd.color);
		add(backdFill);

		grpOptions = new FlxTypedGroup<ASTHEText>();
		add(grpOptions);

		var titleTxt:ASTHEBitmapText = ASTHEBitmapText.createAngelCode(20, bottomFill.y - 6, Locale.getString("title", "pause"), "Roco");
		add(titleTxt);

		regenerateMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var cantUnpause:Float = 0.1;
	override function update(e:Float) {
		cantUnpause -= e;
		super.update(e);

		if(controls.BACK) {
			close();
			return;
		}

		if (controls.UP || controls.DOWN) {
			var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
			var scroll = FlxG.mouse.wheel;
			if (controls.UP || controls.DOWN || scroll != 0) {
				changeItem(((controls.UP ? -1 : controls.DOWN ? 1 : 0) - scroll) * mult);
			}
		}

		var selected:String = options[curSelected];
		if ((controls.ACCEPT || controls.PAUSE) && (cantUnpause <= 0)) {
			ASTHESound.playSound(ConstantSound.MENU_ACCEPT);
			switch (selected.toLowerCase()) {
				case 'resume':
					close();
					FlxG.sound.music?.resume();
				case 'restart':
					FlxG.resetState();
				case 'exit to menu':
					#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
					FlxG.switchState(() -> new asthe.states.MainMenu());
			}
		}

	}

	function regenerateMenu() {
		for (i in 0...grpOptions.members.length) {
			var obj:ASTHEText = grpOptions.members[0];
			obj.kill();
			grpOptions.remove(obj, true);
			obj.destroy();
		}

		for (num => str in options) {
			var item:ASTHEText = ASTHEText.create(backd.x + 3, 60, Locale.getString(str, "pause"));
			item.y += (30 * (num - (options.length / 2))) + item.height;
			item.fieldWidth = backdFill.width;
			item.alignment = ASTHEText.TextAlign.CENTER;
			item.ID = num;
			grpOptions.add(item);
		}
		curSelected = 0;
		changeItem();
	}


	function changeItem(change:Int = 0) {
		if (ArrayUtil.isBlank(grpOptions.members))
			return;

		if (change != 0)
			ASTHESound.playSound(ConstantSound.MENU_SCROLL);

		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);
		for (num => item in grpOptions.members) {
			item.ID = num - curSelected;
			item.color = (item.ID != 0) ? FlxColor.WHITE : (ClientPrefs.data.options.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.RED);
		}
	}

}