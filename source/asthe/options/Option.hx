//@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/options/Option.hx

package asthe.options;

enum OptionType { BOOL; STRING; NUMBER; }

class Option {
	// { region Variables
	public var name:String = "Unknown Option";
	public var desc:String = "This option does not have a description.";
	public var type:OptionType = OptionType.BOOL;
	public var options:OptionSettings;
	public var flag:String = "";
	public var saveVar(default, null):Null<String>;
	public var value(get, set):Dynamic;
	public var defaultV:Null<Dynamic>;

	public var child:AstheText;
	public var text(get, set):Null<String>;
	// } end region

	/**
		Creates a new option
		@param flag Translatable key (Not the text!)
		@param saveVar Variable name to identify your option
		@param type Type: `BOOL, STRING, INT, FLOAT`
		@param options Options per type, `BOOL` doesn't need that.
	**/
	inline public function new(flag:String = "", saveVar:String = "", ?type:OptionType = OptionType.BOOL, ?options:Null<OptionSettings> = null) {

		this.name = Locale.getString(flag, "options");
		this.desc = Locale.getString(flag + "_desc", "options");
		this.type = type;
		this.saveVar = saveVar;
		this.options = options;
		this.flag = (flag ?? "");
		this.value = Reflect.getProperty(ClientPrefs.data.options, saveVar);

		switch (type) {
			case OptionType.BOOL:
				this.options ??= { display: "{0}" };
				defaultV ??= false;
			case OptionType.NUMBER:
				this.options ??= {
					min: 0.0,
					max: 10.0,
					amount: 0.5,
					display: "{0}",
					percentageMode: false
				};
				defaultV ??= 0.0;
			case OptionType.STRING:
				this.options ??= {
					list: ["No Options"],
					display: "{0}"
				};
				defaultV ??= options?.list[0] ?? "No Option";
		}

		this.value ??= defaultV;
	}

	public function toString():String {
		return "Option(name: {0}, desc: {1}, type: {2}, options: {3}, flag: {4})".format([name, desc, type, options, flag]);
	}

	private function get_value():Dynamic
		return Reflect.getProperty(ClientPrefs.data.options, saveVar);

	private function set_value(value:Dynamic):Dynamic {
		Reflect.setProperty(ClientPrefs.data.options, saveVar, value);
		return value;
	}

	var _text:String = null;

	private function get_text()
		return _text;

	private function set_text(newValue:String = '') {
		if (child != null) {
			_text = newValue;
			child.text = !StringUtil.isBlank(flag) ? Locale.getString(flag + "-" + value, "options") : _text;
			return _text;
		}

		return null;
	}
}

typedef OptionSettings = {
	/**
		Set's a display format, how the option will look
		Placeholder values:

		`{0}`: Value of the option
		`{1}`: Default value
	**/
	?display:String,

	/**
		Minimal value for this `NUMBER` option
		Default: `0.0`
	**/
	?min:Float,

	/**
		Maximum value for this `NUMBER` option
		Default: `10.0`
	**/
	?max:Float,

	/**
		If true, the value will be displayed as a percentage
		Only availabe for `NUMBER` options.
	**/
	?percentageMode:Bool,

	/**
		How much increase/decrease values when changing `NUMBER` options
	**/
	?amount:Float,

	/**
		Only available for `STRING` options.
		Set's a list of values for this option.
	**/
	?list:Array<String>
}