package asthe.options.types;

import asthe.options.Option;

@:nullSafety
class BoolOption extends Option<Bool> {
	/**
		Creates a Bool option entry
		@param flag Translatable flag, used to display the name and description
		@param saveVar The save variatble to use
		@param defaultValue Default value of this option
	**/
	public function new(flag:String, saveVar:String, defaultValue:Bool = false) {
		super(flag, saveVar, defaultValue);
	}

	override function onChange(s:Float) {
		value = !value;
	}

	override function formatValue() {
		return (value) ? Locale.getString("enabled") : Locale.getString("disabled");
	}
}