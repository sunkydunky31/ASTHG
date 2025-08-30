package objects;
import backend.Stage;

class StageBase {
	@:allow(states.PlayState, backend.Stage)
	var json:StageFile;
	@:allow(states.PlayState, backend.Stage)
	var jsonAct:ActFile;

	public static var curAct:Int;
	public static var curStage:String;
	public function new (name:String, act:Int) {
		loadStage(name);
		loadAct(act);
	}

	public function loadStage(stage:String) {
			curStage = stage;
			var jsonPath = 'stages/$stage/stage.json';
			if (Paths.fileExists('data/$jsonPath', TEXT)) {
				trace('Found stage $stage');
				json = cast haxe.Json.parse(Paths.getContent('data/$jsonPath', TEXT));
			}
			else {
				trace("Stage file not found! Using Green Hill Zone instead");
				json = {
					folder: "zone1"
				}
			}
	}

	public function loadAct(act:Int) {
		curAct = act;
		//var path:String = 'assets/stages/${json.folder}/act$act.json';
		var path:String = 'stages/$curStage/act$act.json';

		if (Paths.fileExists('data/$path', TEXT)) {
			trace('Found act $act');
			jsonAct = cast haxe.Json.parse(Paths.getContent('data/$path', TEXT));
		}
		else {
			trace("Act file not found, using GHZ Act 1 instead");
			jsonAct = {
				titleCard: "GREEN HILL",
				music: "GreenHill1",
				musicLoop: [776160, 44100]
			}
		}
	}
}

typedef StageFile = {
	var folder:String;
}

typedef ActFile = {
	/**
	 * Name for TitleCard
	 */
	var titleCard:String;

	/**
	 * Music that should play for this act
	 */
	var music:String;

	/**
	 * LoopStart of the music
	 * Values: [Samples, Sound Hz]
	 */
	var musicLoop:Array<Int>;
}