package states;
import openfl.display.BitmapData;
import backend.Mods;

class ModsMenu extends MusicBeatState {
	var bg:FlxSprite;

	//Mod things
	var icon:FlxSprite;
	var modName:FlxText;
	var modDescription:FlxText;
	var modAuthor:FlxText;
	var modList:ModsList = null;

	var modsGroup:FlxTypedGroup<ModItem>;
	var curSelected:Int = 0;

	var startMod:String = null;
	public function new(startMod:String = null) {
		this.startMod = startMod;
		super();
	}

	override function create() {
		modList = Mods.parseList();
		modsGroup = new FlxTypedGroup<ModItem>();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_mods_menu', "Mods Menu"), null);
		#end

		bg = new FlxSprite().makeGraphic(1, 1, 0xFF350000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		var title:FlxBitmapText = new FlxBitmapText(FlxG.width/2, 10, Language.getPhrase("mods_title", "Mods Menu"), Paths.getAngelCodeFont("Roco"));
		title.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 0);
		title.shadowOffset.set(2, 2);
		title.x -= title.width / 2;
		add(title);

		for (i => mod in modList.all) {
			if (startMod == mod) curSelected = i;

			var modItem:ModItem = new ModItem(mod);
			if (!Mods.getModEnabled(mod) && modItem.icon != null) {
				modItem.icon.color = 0xFF707070;
			}
			modsGroup.add(modItem);
			trace('Found mod "${mod}"');
		}

		add(modsGroup);
		super.create();
	}

	override function update(e:Float) {
		super.update(e);

		if (controls.justPressed('back'))
			LoadingState.switchStates(new MainMenu());
	}
}

class ModItem extends FlxSpriteGroup {
	public var selectBg:FlxSprite;
	public var icon:FlxSprite;
	public var text:FlxText;
	public var totalFrames:Int = 0;

	// options
	public var name:String = 'Unknown Mod';
	public var desc:String = 'No description provided.';
	public var iconFps:Int = 10;
	public var pack:Dynamic = null;
	public var folder:String = 'unknownMod';
	public var mustRestart:Bool = false;
	public var settings:Array<Dynamic> = null;
	public var iconSettings:Dynamic = null;

	public function new(folder:String) {
		super();

		this.folder = folder;
		pack = Mods.getPack(folder);

		var path:String = Paths.mods('$folder/data/settings.json');
		if(FileSystem.exists(path)) {
			try {
				//trace('trying to load settings: $folder');
				settings = tjson.TJSON.parse(File.getContent(path));
			}
			catch(e:Dynamic) {
				var errorTitle = 'Mod name: ' + Mods.currentModDirectory;
				var errorMsg = 'An error occurred: $e';
				#if windows
				lime.app.Application.current.window.alert(errorMsg, errorTitle);
				#end
				trace('$errorTitle - $errorMsg');
			}
		}

		selectBg = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
		selectBg.alpha = 0.8;
		selectBg.visible = false;
		add(selectBg);

		if (FileSystem.exists(Paths.mods('$folder/pack.png'))) {
			icon = new FlxSprite(5, 5);
			icon.antialiasing = ClientPrefs.data.antialiasing;
			add(icon);
		}

		text = new FlxText(95, 38, 230, "", 16);
		text.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.borderSize = 2;
		text.y -= Std.int(text.height / 2);
		add(text);

		var file:String = Paths.mods('$folder/pack.png');
		
		var bmp:BitmapData = null;
		if (FileSystem.exists(file)) bmp = BitmapData.fromFile(file);

		var iSize:Float = 0;
		if(FileSystem.exists(file)) {
			var iSize = Math.round(icon.width / icon.height);
			if (pack.iconSettings.animated == true)
				icon.loadGraphic(Paths.cacheBitmap(file, bmp), true, Std.int(icon.width), Std.int(icon.height));
			else
				icon.loadGraphic(Paths.cacheBitmap(file, bmp), true, Math.round(icon.width / iSize), Std.int(icon.height));
			icon.antialiasing = false;
			icon.scale.set(0.5, 0.5);
			icon.updateHitbox();
		}
		
		this.name = folder;
		if (iconSettings != null && Reflect.hasField(iconSettings, "framerate")) {
			iconFps = Reflect.field(iconSettings, "framerate");
		}

		
		if(pack != null) {
			if(pack.name != null) this.name = pack.name;
			if(pack.description != null) this.desc = pack.description;
			if (pack.iconSettings != null) this.iconSettings = pack.iconSettings;
			this.mustRestart = (pack.restart == true);
		}
		text.text = this.name;

		if(bmp != null) {
			totalFrames = Math.floor(bmp.width / iSize) * Math.floor(bmp.height / iSize);
			icon.animation.add("icon", [for (i in 0...totalFrames) i], 10);
			icon.animation.play("icon");
		}
		selectBg.scale.set(width + 5, height + 5);
		selectBg.updateHitbox();
	}
}