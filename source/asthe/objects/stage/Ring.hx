package asthe.objects.stage;

class Ring extends AstheSprite {
	public static final ANIMATION_NUM_FRAMES:Int = 15; // Sonic Mania sprite num frames -- REALLY SMOOTH, wow
	public static final ANIMATION_SPEED:Int      = 40; // Estimated animation speed, not sure because Retro Engine uses velocity, not FPS.

	public function new(x:Float = 0, y:Float = 0)  {
		super(x, y);

		loadGraphic(Paths.image("Objects/rings"), true, false);
		animation.add("idle", [for (i in 0...ANIMATION_NUM_FRAMES) i], 40, true);
		animation.play("idle");
	}

	override function kill() {
		super.kill();

		AstheSound.playSound(ConstantSounds.RING);
		game.HudGame.instance?.rings++;
	}
}