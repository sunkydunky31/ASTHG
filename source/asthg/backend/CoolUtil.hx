package asthg.backend;


class CoolUtil {

	public static function getProjectInfo(metaIndex:String) {
		return FlxG.stage.application.meta.get(metaIndex);
	}

	/**
		Parses an String and convert it into a Bool
		@param k
		@return Null<Bool> (Bool->false if invalid value)
		@author Sunnydev31 (@unreal.sunnydev)
	**/
	public static function parseBool(k:String):Bool {
		return switch (k) {
			case "true": true;
			case "false": false;
			default: false;
		}
	}
}

