package asthe.options.types;

import asthe.options.Option;

class NumberOption extends Option<Float> {
	/**
		Minimal value for this option
		@default `0.0`
	**/
	public var min:Float;

	/**
		Maximum value for this option
		@default `10.0`
	**/
	public var max:Float;

	/**
		If true, the value will be displayed as a percentage
		@default `false`
	**/
	public var percentageMode:Bool = false;

	/**
		How much increase/decrease values when changing the option
	**/
	public var amount:Float;

	/**
		Creates a number option entry
		@param flag Translatable flag, used to display the name and description
		@param saveVar The save variatble to use
		@param defaultValue Default value of this option
		@param min Minimun value that this option accepts
		@param max Minimun value that this option accepts
		@param amount How much this number increases per change?
		@param percentageMode 
	**/
	public function new(flag:String, saveVar:String, defaultValue:Float = 0.0, min:Float = 0.0, max:Float = 10.0, amount:Float = 0.5, ?percentageMode:Bool = false) {
		this.min = min;
		this.max = max;
		this.amount = amount;
		this.percentageMode = percentageMode;
		super(flag, saveVar, defaultValue);
	}

	override public function onChange(s:Float) {
		var v = MathUtil.clamp((value ?? 0) + (s * amount), min, max);
		value = v;
	}

	override public function formatValue() {
		var v = value ?? 0;
		if (percentageMode) v *= 100;

		// Format our value
		var fm = display.format([Std.string(v)]);
		if (percentageMode && !fm.contains("%")) fm += "%";

		return fm;
	}
}