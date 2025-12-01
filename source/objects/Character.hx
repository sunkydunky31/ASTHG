/*
	By Sunkydev31
	2025.11.30
	You are allowed to copy, modify and distribute the code in this file.
*/

package objects;

import flixel.math.FlxRect;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import haxe.xml.Access;

class Character extends FlxSprite {
	public static final defaultPlayer:String = "sonic";
	public var json:CharacterData;
	public static var exAnim:Dynamic = {}; // Data store for new animations
	public final lifeIcon:String = "liveIcon";
	
	// Special events
	public var curPalette:Int = 0;

	// Anim name help

	public function new(x:Float, y:Float, ?char:String) {
		super(x, y);
		changeChar(char);
		
		maxVelocity.set(90, 200);
		acceleration.y = 0;
		velocity.x = 0;

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		origin.set(width/2, height);
		updateHitbox();
	}

	public var isSuper:Bool = false;

	override function update(e:Float) {
		super.update(e);
	}

	public function changeChar(char:String) {
		if (Paths.fileExists('data/characters/$char.json', TEXT)) {
			json = cast Paths.parseJson('data/characters/$char');
		}
		else {
			json = cast Paths.parseJson('data/characters/sonic');
			trace('Character not found, using default ($defaultPlayer)');
		}

		if (Reflect.hasField(json, "extraAnimations")) {
			for (extra in json.extraAnimations) {
		 		addAnim(extra.name);
			}
		}

		loadAnimations();
		playAnim("ANI_STOPPED");
	}
	
	function loadAnimations() {
		frames = Paths.getSparrowAtlas('characters/${json.name}/animData');
		
		var anims = json.animations;
		if(anims != null && anims.length > 0) {
			for (anim in anims) {
				if(anim.indices != null && anim.indices.length > 0)
					animation.addByIndices(Std.string(anim.name), Reflect.hasField(anim, "prefix")? anim.prefix : anim.name, anim.indices, "", anim.fps, anim.loop);
				else
					animation.addByPrefix(Std.string(anim.name), Reflect.hasField(anim, "prefix")? anim.prefix : anim.name, anim.fps, anim.loop);
			}
		}
	}

	public function playAnim(name:AnimList, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		animation.play(name, force, reversed, frame);
	}

	/**
		Adds an animation to the list
		@param name Name of this animation (Prefered style: `ANI_ANIMATION`, e.g. `ANI_ROLLING`)
	**/
	public function addAnim(name:String):Void {
		trace('[INFO] Added animation to the list. ($name)');
		Reflect.setField(exAnim, name, name);
	}

	public function animExists(name:AnimList):Bool {
		if (Reflect.hasField(exAnim, name)){
			var nameN:String = Std.string(Reflect.field(exAnim, name));
        	return nameN != null && animation.getByName(nameN) != null;
		}
		
		trace('[WARNING] Animation "$name" doesn\'t exists in the list!');
		return false;
	}
}

typedef AnimData = {
	var name:String;
	var sheets:String;

	/**
		Name in SparrowAtlas file
	**/
	@:optional var prefix:String;

	@:optional var fps:Float;
	@:optional var loop:Bool;

	/**
		Offset on character
	**/
	@:optional var offset:Array<Int>;
	@:optional var indices:Array<Int>;

}

typedef CharacterData = {
	/**
		Name of this character
		Used on IDs, and for results text
	**/
	var name:String;
	@:optional var liveIcon:String;

	/**
		Color that this character uses
		
		Used for Normal palette showing, super, etc.
	**/
	var palettes:Array<Array<String>>;

	/**
		Some characters doesn't achieve Super forms, so there you are!
		NOTE: If set to `true`, the live icon needs to have 2 frames!
	**/
	var hasSuper:Bool;

	@:optional var animations:Array<AnimData>;
	@:optional var extraAnimations:Array<AnimData>;
}


/**
	Contains default animations used by all characters
	
	use `addAnim()` if you want to add a new one	
**/
enum abstract AnimList(String) {
	var ANI_STOPPED			= "ANI_STOPPED";
	var ANI_WAITING			= "ANI_WAITING";
	var ANI_BORED			= "ANI_BORED";
	var ANI_LOOK_UP			= "ANI_LOOK_UP";
	var ANI_LOOK_DOWN		= "ANI_LOOK_DOWN";
	var ANI_WALKING			= "ANI_WALKING";
	var ANI_RUNNING			= "ANI_RUNNING";
	var ANI_SKIDDING		= "ANI_SKIDDING";
	var ANI_SUPER_PEEL_OUT	= "ANI_SUPER_PEEL_OUT";
	var ANI_SPINDASH		= "ANI_SPINDASH";
	var ANI_JUMPING			= "ANI_JUMPING";
	var ANI_BOUNCING		= "ANI_BOUNCING";
	var ANI_HURT			= "ANI_HURT";
	var ANI_DYING			= "ANI_DYING";
	var ANI_DROWNING		= "ANI_DROWNING";
	var ANI_FAN_ROTATE		= "ANI_FAN_ROTATE";
	var ANI_BREATHING		= "ANI_BREATHING";
	var ANI_PUSHING			= "ANI_PUSHING";
	var ANI_FLAILING1		= "ANI_FLAILING1";
	var ANI_FLAILING2		= "ANI_FLAILING2";
	var ANI_FLAILING3		= "ANI_FLAILING3";
	var ANI_HANGING			= "ANI_HANGING";
	var ANI_GRABBED			= "ANI_GRABBED";
	var ANI_CLINGING_ON		= "ANI_CLINGING_ON";
	var ANI_TWIRL_H			= "ANI_TWIRL_H";
	var ANI_TWIRL_V			= "ANI_TWIRL_V";
	var ANI_WATER_SLIDE		= "ANI_WATER_SLIDE";
	var ANI_CONTINUE		= "ANI_CONTINUE";
	var ANI_CONTINUE_UP		= "ANI_CONTINUE_UP";
	var ANI_SUPER_TRANSFORM	= "ANI_SUPER_TRANSFORM";
	var ANI_CD_TWIRL		= "ANI_CD_TWIRL";
	var ANI_HANG_MOVE		= "ANI_HANG_MOVE";

	@:from static function fromString(s:String):AnimList return cast s;
	@:to public function toString():String return (this : String);
}