package asthe.data;

typedef CharacterAnimation = {
	/**
		Name of the animation
	**/
	name:String,

	/**
		How should your animation be displayed?
	**/
	?displayName:String,

	/**
		How much spritesheets your animation use?
		Separated by comma (`,`)
	**/
	?sheets:String,

	/**
		Name in SparrowAtlas file
	**/
	?prefix:String,

	/**
		Frames per second of this animation
	**/
	?fps:Float,

	/**
		Does this animation loops?
	**/
	?loop:Bool,

	/**
		Offset to apply in this animation
		*Only when it's played*
	**/
	?offset:Array<Int>,

	/**
		Frame indices to use
		You can sort here if needed
	**/
	?indices:Array<Int>
}

/**
	Contains default animations used by all characters

	Use `addAnim()` if you want to add a new one, or set them on the character JSON file in "extraAnimations" array
**/
enum abstract AnimList(String) from String to String {
	// I KNOW THAT ITS A LOT OF ANIMATIONS, but I will use them on the future, I guess... be patient!
	// Also, this animation list are gotten from the Retro Engine 4 (Sonic 2), so?...
	var ANI_STOPPED         = "ANI_STOPPED";
	var ANI_WAITING         = "ANI_WAITING";
	var ANI_BORED           = "ANI_BORED";
	var ANI_LOOK_UP         = "ANI_LOOK_UP";
	var ANI_LOOK_DOWN       = "ANI_LOOK_DOWN";
	var ANI_WALKING         = "ANI_WALKING";
	var ANI_RUNNING         = "ANI_RUNNING";
	var ANI_SKIDDING        = "ANI_SKIDDING";
	var ANI_SUPER_PEEL_OUT  = "ANI_SUPER_PEEL_OUT";
	var ANI_SPINDASH        = "ANI_SPINDASH";
	var ANI_JUMPING         = "ANI_JUMPING";
	var ANI_BOUNCING        = "ANI_BOUNCING";
	var ANI_HURT            = "ANI_HURT";
	var ANI_DYING           = "ANI_DYING";
	var ANI_DROWNING        = "ANI_DROWNING";
	var ANI_FAN_ROTATE      = "ANI_FAN_ROTATE";
	var ANI_BREATHING       = "ANI_BREATHING";
	var ANI_PUSHING         = "ANI_PUSHING";
	var ANI_FLAILING1       = "ANI_FLAILING1";
	var ANI_FLAILING2       = "ANI_FLAILING2";
	var ANI_FLAILING3       = "ANI_FLAILING3";
	var ANI_HANGING         = "ANI_HANGING";
	var ANI_GRABBED         = "ANI_GRABBED";
	var ANI_CLINGING_ON     = "ANI_CLINGING_ON";
	var ANI_TWIRL_H         = "ANI_TWIRL_H";
	var ANI_TWIRL_V         = "ANI_TWIRL_V";
	var ANI_WATER_SLIDE     = "ANI_WATER_SLIDE";
	var ANI_CONTINUE        = "ANI_CONTINUE";
	var ANI_CONTINUE_UP     = "ANI_CONTINUE_UP";
	var ANI_SUPER_TRANSFORM = "ANI_SUPER_TRANSFORM";
}