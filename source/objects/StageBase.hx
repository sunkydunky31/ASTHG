package objects;

class StageBase {
	@:allow(states.PlayState)
	var json:StageFile;

	public static var curAct:Int;
	public static var curStage:String;
	public function new (name:String, act:Int) {
		loadStage(name);
		loadAct(act);
	}

	var path = 'stages/$stage/stage';
	public function loadStage(stage:String) {
			curStage = stage;
			if (Paths.fileExists('data/$path.json', TEXT)) {
				trace('Found stage $stage');
				json = cast Paths.parseJson('data/$path');
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

		if (Reflect.hasField(json)) {
			trace('Found act $act');
			jsonAct = cast Paths.parseJson('data/$path');
		}
		else {
			trace("Act file not found, using GHZ Act 1 instead");
			jsonAct = {
				titleCard: "GREEN HILL",
				music: "GreenHill1"
			}
		}
	}
}

typedef StageFile = {
	folder:String,
	?acts:Int = 1,
	
}

typedef ActFile = {
	/**
		Name for TitleCard
	*/
	var titleCard:String;

	/**
		Music that should play for this act
	*/
	var music:String;
}