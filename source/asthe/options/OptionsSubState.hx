/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-06-04
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
*/
package asthe.options;

import asthe.input.InputFormatter;
import asthe.options.Option;

using util.StringUtil;

import flixel.math.FlxMath;

class OptionsSubState extends SubStateManager {
	var selected:Int = 0;
	var options:Array<Option>;

	public var camFront:FlxCamera;
	public var camFollow:FlxObject = new FlxObject(FlxG.width / 2, 0, 2, 2);

	var grpOptions:FlxTypedGroup<AstheText>;
	var grpValues:FlxTypedGroup<AstheText>;

	var txtDesc:AstheText;
	var sprDesc:AstheSprite;

	public var title:String;

	public function new() {
		super();

		var bg = new AstheSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		camFront = new FlxCamera();
		camFront.bgColor = 0x00000000;
		camFront.follow(camFollow, LOCKON, 0.12);
		FlxG.cameras.add(camFront, false);

		var margin = 32;
		camFront.deadzone.set(0, margin, camFront.width, camFront.height - margin * 2);
		camFront.minScrollY = 0;

		grpOptions = new FlxTypedGroup<AstheText>();
		add(grpOptions);

		grpValues = new FlxTypedGroup<AstheText>();
		add(grpValues);

		add(camFollow);

		var title:AstheBitmapText = AstheBitmapText.createAngelCode(0, 8, !StringUtil.isBlank(title) ? Locale.getString("title", "options") : "Options");
		title.screenCenter(X);
		add(title);

		if (!ArrayUtil.isBlank(options)) {
			var xFactor:Float = 0.9;
			for (i in 0...options.length) {
				var optName:AstheText = AstheText.create(FlxG.width - (FlxG.width * xFactor), 30, options[i].name);
				optName.fieldWidth = 170;
				optName.alignment = AstheText.TextAlign.LEFT;
				optName.ID = i;
				optName.y += (23 * i);
				optName.cameras = [camFront];
				grpOptions.add(optName);

				var optValues:AstheText = AstheText.create(FlxG.width * xFactor, optName.y, Std.string(options[i].options.display).format([normalizeOptionValue(options[i])]));
				optValues.fieldWidth = optName.fieldWidth;
				optValues.alignment = AstheText.TextAlign.RIGHT;
				optValues.x -= optValues.width; // Apply adjustment to fit screen factor
				optValues.color = optName.color;
				optValues.cameras = optName.cameras;
				grpValues.add(optValues);
			}
		}
		else {
			var warn:AstheText = AstheText.create(0, 0, Locale.getString("no_options", "options"));
			warn.screenCenter();
			add(warn);
		}

		sprDesc = new AstheSprite(0, FlxG.height * 0.7);
		var fillWidth = FlxG.height - sprDesc.y;
		sprDesc.createGraphic(FlxG.width, Std.int(fillWidth), FlxColor.BLACK);
		sprDesc.visible = (!ArrayUtil.isBlank(options));
		add(sprDesc);

		txtDesc = AstheText.create(0, sprDesc.y + 4, "");
		txtDesc.fieldWidth = FlxG.width;
		txtDesc.alignment = AstheText.TextAlign.CENTER;
		add(txtDesc);

		changeSelection();
	}

	override public function update(e:Float) {

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		var scroll = FlxG.mouse.wheel;
		if (controls.UP || controls.DOWN || scroll != 0) {
			changeSelection(((controls.UP ? -1 : 1) * mult) - scroll);
			AstheSound.playSound(ConstantSound.MENU_SCROLL);
		}

		if(controls.BACK) {
			close();
			AstheSound.playSound(ConstantSound.MENU_BACK);
		}

		if (controls.LEFT || controls.RIGHT) {
			if (ArrayUtil.isBlank(options))
				return;

			var change:Float = (controls.RIGHT ? 1 : -1) * mult;

			var opt = options[selected];
			switch (opt.type) {
				case OptionType.BOOL:
					opt.value = !opt.value;

				case OptionType.NUMBER:
					change *= opt.options.amount;
					opt.value = MathUtil.clamp((opt.value ?? 0) + change, opt.options.min, opt.options.max);

				case OptionType.STRING:
					var list = opt.options.list;
					var index:Int = list.indexOf(opt.value);

					if (index == -1)
						index = 0;

					index = MathUtil.clampInt(index + Std.int(change), 0, list.length - 1);
					opt.value = list[index];
			}

			var display:String = opt.options?.display ?? "{0}";
			if ((opt.type == OptionType.NUMBER && opt.options?.percentageMode == true) && !display.contains("%"))
				display += "%";

			grpValues.members[selected].text = display.format([normalizeOptionValue(opt)]);
			AstheSound.playSound(ConstantSound.MENU_SCROLL);
		}
	}

	override public function destroy() {
		super.destroy();

		if (camFront != null)
			FlxG.cameras.remove(camFront);
	}

	override public function close() {
		ClientPrefs.saveSettings();
		super.close();
	}

	public function addOption(option:Option) {
		if(ArrayUtil.isBlank(options))
			options = [];

		options.push(option);
		return option;
	}

	function changeSelection(change:Int = 0) {
		if (ArrayUtil.isBlank(options) || ArrayUtil.isBlank(grpOptions.members))
			return;

		if (change != 0)
			AstheSound.playSound(ConstantSound.MENU_SCROLL);

		selected = FlxMath.wrap(selected + change, 0, options.length - 1);

		grpOptions.forEach(function(txt:AstheText) {
			txt.alpha = (txt.ID == selected) ? 1 : 0.5;

			if (txt.ID == selected)
				camFollow.y = txt.y;
		});

		txtDesc.text = options[selected].desc;
	}

	function normalizeOptionValue(opt:Option):String {
		switch (opt.type) {
			case OptionType.BOOL:
				return (opt.value == true) ? Locale.getString("enabled") : Locale.getString("disabled");
			case OptionType.NUMBER:
				var v = opt.value;
				if (v == null) return "";
				if (opt.options?.percentageMode) v *= 100;
				return Std.string(v);
			default: return Std.string(opt.value);
		}
	}
}