package options;

import openfl.utils.Assets;

class LanguageSubState extends MusicBeatSubstate
{
	#if TRANSLATIONS_ALLOWED
	var grpLanguages:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	var languages:Array<String> = [];
	var displayLanguages:Map<String, String> = [];
	var curSelected:Int = 0;
	public function new()
	{
		super();
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.alpha = 0.75;
		bg.updateHitbox();
		add(bg);
		add(grpLanguages);

		languages.push(ClientPrefs.defaultData.language); //English (US)
		displayLanguages.set(ClientPrefs.defaultData.language, Language.defaultLangName);
		var directories:String = Paths.getPath("data");
		for (file in FileSystem.readDirectory(directories))
		{
			if(file.toLowerCase().endsWith('.lang'))
			{
				var langFile:String = file.substring(0, file.length - '.lang'.length).trim();
				if(!languages.contains(langFile))
					languages.push(langFile);

				if(!displayLanguages.exists(langFile))
				{
					var path:String = '$directories/$file';
					#if MODS_ALLOWED 
					var txt:String = File.getContent(path);
					#else
					var txt:String = Assets.getText(path);
					#end

					var id:Int = txt.indexOf('\n');
					if(id > 0) //language display name shouldnt be an empty string or null
					{
						var name:String = txt.substr(0, id).trim();
						if(!name.contains(':')) displayLanguages.set(langFile, name);
					}
					else if(txt.trim().length > 0 && !txt.contains(':')) displayLanguages.set(langFile, txt.trim());
				}
			}
		}

		languages.sort(function(a:String, b:String)
		{
			a = (displayLanguages.exists(a) ? displayLanguages.get(a) : a).toLowerCase();
			b = (displayLanguages.exists(b) ? displayLanguages.get(b) : b).toLowerCase();
			if (a < b) return -1;
			else if (a > b) return 1;
			return 0;
		});

		trace(ClientPrefs.data.language);
		curSelected = languages.indexOf(ClientPrefs.data.language);
		if(curSelected < 0)
		{
			trace('Language not found: ' + ClientPrefs.data.language);
			ClientPrefs.data.language = ClientPrefs.defaultData.language;
			curSelected = Std.int(Math.max(0, languages.indexOf(ClientPrefs.data.language)));
		}

		for (num => lang in languages)
		{
			var name:String = displayLanguages.get(lang);
			if(name == null) name = lang;

			var text:FlxText = new FlxText(0, 300, 0, name);
			text.setFormat(Paths.font("Mania.ttf"), 16, FlxColor.WHITE, CENTER);
			text.ID = num;
			if(languages.length < 7)
			{
				text.screenCenter(Y);
				text.y += (20 * (num - (languages.length / 2))) + text.size;
			}
			text.screenCenter(X);
			grpLanguages.add(text);
		}
		changeSelected();
	}

	var changedLanguage:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		if(controls.justPressed('up')) changeSelected(-1 * mult);
		if(controls.justPressed('down')) changeSelected(1 * mult);
		if(FlxG.mouse.wheel != 0) changeSelected(FlxG.mouse.wheel * mult);

		if(controls.justPressed('back'))
		{
			if(changedLanguage)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				MusicBeatState.resetState();
			}
			else close();
			CoolUtil.playSound("Menu Cancel", true);
		}

		if(controls.justPressed('accept'))
		{
			CoolUtil.playSound("Menu Accept", true, 0.6);
			ClientPrefs.data.language = languages[curSelected];
			//trace(ClientPrefs.data.language);
			ClientPrefs.saveSettings();
			Language.reloadPhrases();
			changedLanguage = true;
		}
	}

	function changeSelected(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length-1);
		for (num => lang in grpLanguages)
		{
			lang.ID = num - curSelected;
			lang.alpha = 0.6;
			if(num == curSelected) lang.alpha = 1;
		}
		CoolUtil.playSound("Menu Change", true, 0.6);
	}
	#end
}