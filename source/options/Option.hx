package options;

enum OptionType {
	BOOL;
	STRING;
	INT;
	FLOAT;
}

class Option {
	public var name:Null<String> = "unknown_option";
	public var type:OptionType = OptionType.BOOL;
	public var saveVar(default, null):String = null;
	public var options:Dynamic = null;
	public var value(get, set):Dynamic;
	public var defaultV:Dynamic = null;
	
	public var child:FlxText;
	public var text(get, set):String;

	inline public function new(name:String = "", saveVar:String = "", ?type:OptionType = OptionType.BOOL, ?options:Dynamic) {
		_name = name;
		_translationKey = _name;

		this.name = Locale.getString(name, "options");
		this.desc = Locale.getString('${name}_desc', "options");
		this.type = type;
		this.saveVar = saveVar;
		this.options = options;
		this.value = Reflect.getProperty(ClientPrefs.data, saveVar);

		switch (type) {
			case OptionType.BOOL:
				if (defaultV == null) defaultV = false;
			case OptionType.FLOAT:
				this.options = {min: 0.0, max: 10.0, amount: 0.5, display: "%v"};
				if (defaultV == null) defaultV = 0.0;
			case OptionType.INT:
				this.options = {min: 0, max: 10, amount: 1, display: "%v"};
				if (defaultV == null) defaultV = 0;
			case OptionType.STRING:
				this.options = {list: ["No Options"], display: "%v"};
				if (defaultV == null) defaultV = options.list[0];
		}
	}

	private function get_value():Dynamic { return Reflect.getProperty(ClientPrefs.data, saveVar); }

	private function set_value(value:Dynamic):Dynamic {
		Reflect.setProperty(ClientPrefs.data, saveVar, value);
		return value;
	}

	var _name:String = null;
	var _text:String = null;
	var _translationKey:String = null;

	private function get_text()
		return _text;

	private function set_text(newValue:String = '')
	{
		if (child != null)
		{
			_text = newValue;
			child.text = Locale.getString('$_translationKey-${value}', _text);
			return _text;
		}
		return null;
	}
}
