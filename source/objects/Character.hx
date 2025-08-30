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
	public var animData:Access; 
	public final lifeIcon:String = "liveIcon";

	/**
	 * Contains default animations used by all characters
	 * 
	 * use `addAnim()` if you want to add a new one
	 * 
	 * `playAnim()` handles it by default
	 */
	public var AnimationList:Map<String, Int> = [
		"ANI_STOPPED"			=>	0,
		"ANI_WAITING"			=>	1,
		"ANI_BORED"				=>	2,
		"ANI_LOOK_UP"			=>	3,
		"ANI_LOOK_DOWN"			=>	4,
		"ANI_WALKING"			=>	5,
		"ANI_RUNNING"			=>	6,
		"ANI_SKIDDING"			=>	7,
		"ANI_SUPER_PEEL_OUT"	=>	8,
		"ANI_SPINDASH"			=>	9,
		"ANI_JUMPING"			=>	10,
		"ANI_BOUNCING"			=>	11,
		"ANI_HURT"				=>	12,
		"ANI_DYING"				=>	13,
		"ANI_DROWNING"			=>	14,
		"ANI_FAN_ROTATE"		=>	15,
		"ANI_BREATHING"			=>	16,
		"ANI_PUSHING"			=>	17,
		"ANI_FLAILING1"			=>	18,
		"ANI_FLAILING2"			=>	19,
		"ANI_FLAILING3"			=>	20,
		"ANI_HANGING"			=>	21,
		"ANI_GRABBED"			=>	22,
		"ANI_CLINGING_ON"		=>	23,
		"ANI_TWIRL_H"			=>	24,
		"ANI_TWIRL_V"			=>	25,
		"ANI_WATER_SLIDE"		=>	26,
		"ANI_CONTINUE"			=>	27,
		"ANI_CONTINUE_UP"		=>	28,
		"ANI_SUPER_TRANSFORM"	=>	29,
		"ANI_CD_TWIRL"			=>	30,
		"ANI_S2_PEELOUT"		=>	31,
		"ANI_MANIA_PEELOUT"		=>	32,
		"ANI_HANG_MOVE"			=>	33,
	];

	// Anim name help

	public function new(x:Float, y:Float, ?char:String) {
		super(x, y);
		changeChar(char);

		maxVelocity.set(90, 200);
		acceleration.y = 0;
		velocity.x = maxVelocity.x * 4;

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		origin.set(width/2, height);
		updateHitbox();
	}

	function updateMoves() {
		acceleration.x = 0;

		var inputUP:Bool = false;
		var inputDOWN:Bool = false;
		var inputLEFT:Bool = false;
		var inputRIGHT:Bool = false;

		inputUP = Controls.instance.pressed('up');
		inputDOWN = Controls.instance.pressed('down');
		inputLEFT = Controls.instance.pressed('left');
		inputRIGHT = Controls.instance.pressed('right');

		if (inputUP && inputDOWN)
			inputUP = inputDOWN = false;
		if (inputLEFT && inputRIGHT)
			inputLEFT = inputRIGHT = false; 

		if (inputUP || inputDOWN || inputLEFT || inputRIGHT) {
			if (inputUP) {
				facing = UP;
			}
			else if (inputDOWN) {
				facing = DOWN;
			}
			else if (inputLEFT) {
				facing = LEFT;
			}
			else if (inputRIGHT) {
				facing = RIGHT;
			}
		
			switch (facing) {
				case UP:
					playAnim("ANI_LOOK_UP");
				case DOWN:
					playAnim("ANI_LOOK_DOWN");
				case LEFT, RIGHT:
					if ((velocity.x != 0) && touching == NONE)
						playAnim("ANI_WALKING");

					acceleration.x = (facing == LEFT) ? -maxVelocity.x * 4 : maxVelocity.x * 4;
				case _:
			}
		}
	}

	override function update(e:Float) {
		updateMoves();
		super.update(e);
	}

	function changeChar(char:String) {
		if (Paths.fileExists('data/characters/$char.json', TEXT)) {
			json = cast tjson.TJSON.parse(Paths.getContent('data/characters/$char.json', TEXT));
		}
		else {
			json = cast tjson.TJSON.parse(Paths.getContent('data/characters/sonic.json', TEXT));
			trace('Character not found, using default ($defaultPlayer)');
		}

		if (Reflect.hasField(json, "extraAnimations")) {
			for (extra in json.extraAnimations) {
		   		addAnim(extra.name, extra.ID);
   			}
		}

		loadAnimations();
		playAnim("ANI_STOPPED");
	}
	
	function loadAnimations() {
		frames = Paths.getASTHGAtlas('characters/${json.name}/animData');
		animData = new haxe.xml.Access(Xml.parse(Paths.getContent('images/characters/${json.name}/animData.xml', TEXT)).firstElement());
		
		for (anim in animData.nodes.animation) {
			var frameI:Array<Int> = [];
			for (i in 0...anim.nodes.frame.length) {
				frameI.push(i);
			}
			animation.addByIndices(anim.att.id, anim.att.id+"_", frameI, null, anim.has.fps ? Std.parseFloat(anim.att.fps) * frameI.length : 0, anim.has.loop ? CoolUtil.parseBool(anim.att.loop) : false);
			animation.getByName(anim.att.id).loopPoint = anim.has.loopStart ? Std.parseInt(anim.att.loopStart) : 0;
		}
	}

	public function playAnim(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		animation.play(Std.string(AnimationList.get(name)), force, reversed, frame);
	}

	/**
	 * Adds an animation to the list
	 * @param name Name of this animation (Prefered style: `ANI_ANIMATION`, e.g. `ANI_ROLLING`)
	 * @param id Internal ID on the AnimData.xml file
	 */
	public function addAnim(name:String, id:Int) {
		trace('[INFO] Added animation to the list. ("$name", $id)');
		AnimationList.set(name, id);
	}

	public function animExists(name:String):Bool {
		if (!AnimationList.exists(name))
			trace("[WARNING] Animation " + name + " doesn't exists in the list!");
		return AnimationList.exists(name);
	}
}

typedef CharacterData = {
	/**
	 * Name of this character
	 * Used on IDs, and for results text
	 */
	@:default("Unknown")
	var name:String;

	@:default({animated: false}) @:optional
	var continues:Array<CharContinues>;

	@:optional @:default("liveIcon")
	var liveIcon:String;

	/**
	 * Color that this character uses
	 * 
	 * Used for Normal palette showing, super, etc.
	 */
	@:default([['#0000F0', '#0000A0', '#000080', '#000060']])
	var palettes:Array<Array<String>>;

	/**
	 * Some characters doesn't achieve Super forms, so there you are!
	 * NOTE: If set to `true`, the live icon needs to have 2 frames!
	 */
	@:default(false) @:optional
	var hasSuper:Bool;

	@:default([[]]) @:optional
	var extraAnimations:Array<CharExtraAnimations>;
}

typedef CharExtraAnimations = {
	/**
	 * Display name, just to make it more easy to find
	 */
	var name:String;

	/**
	 * Identifier of `this` animation
	 */
	var ID:Int;
}

typedef CharContinues = {
	@:default("continue")
	var sprite:String;
	
	var animated:Bool;

	/**
	 * Frame Width
	 */
	@:optional
	var width:Int;

	/**
	 * Frame Height
	 */
	@:optional
	var height:Int;
}