package asthg.data;

import asthg.data.CharacterAnimation;

typedef CharacterData = {
	/**
		Name of this character
		Used on IDs and results text
	**/
	name:String,

	/**
		Sets the size scaling for this character.
	**/
	scale:Float,

	/**
		A Custom character icon for the HUD
	**/
	liveIcon:Null<LiveIconData>,

	/**
		Color that this character uses
		Used for Normal palette showing, super, etc.
	**/
	palettes:Null<PaletteData>,

	/**
		Some characters doesn't achieve Super forms, so there you are!
		NOTE: If set to `true`, the live icon needs to have 2 frames! and you need to offer the super palette.
	**/
	hasSuper:Bool,

	/**
		Stores default animation list like `STOPPED`, `WALKING`, etc.
	**/
	animations:Array<CharacterAnimation>,

	/**
		Stores custom animations like `DropDash`, `Super Peel Out` and etc.
	**/
	extraAnimations:Array<CharacterAnimation>
}

typedef LiveIconData = {
	name:Null<String>,
	scale:Null<Float>,
	offsets:Null<Array<Float>>
}

/**
	Defines the colors of the characters, like their normal colors, super form, etc.
	Used for color transform.
**/
typedef PaletteData = {
	/**
		Stores the normal/default character palette
	**/
	normal:Array<String>,

	/**
		Stores the super colors when the character achieves the Super form.
		Only used if character data has `hasSuper` set to true.
	**/
	?super:Null<Array<String>>
}