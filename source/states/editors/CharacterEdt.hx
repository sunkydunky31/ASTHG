package states.editors;
import objects.Character;

class CharacterEdt extends BaseEditor {
	var camEditor:FlxCamera;
	var char:Character = new Character(0, 0);

	override public function new() {
		super("character");
	}

	override function create() {
		super.create();

		camEditor = new FlxCamera();
		FlxG.cameras.add(camEditor);

		char.changeChar('sonic');
		add(char);
	}
}