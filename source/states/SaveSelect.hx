package states;

class SaveSelect extends MusicBeatState {

	override function create() {
		Paths.clearStoredMemory();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Language.getPhrase('discordrpc_save_select', 'Save Select'), null);
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff4d4dff);
		add(bg);

		super.create();
		CoolUtil.playMusic("SaveSelect", {sample: 131290});
	}

	override function update(e:Float) {
		super.update(e);

		if (controls.justPressed('accept'))
			LoadingState.loadAndSwitchState(new states.PlayState(), true);
		if (controls.justPressed('back')) {
			CoolUtil.mus.stop();
			MusicBeatState.switchState(new MainMenu());
		}
	}
}