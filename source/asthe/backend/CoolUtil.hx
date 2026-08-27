package asthe.backend;

class CoolUtil {
	/**
		Parses an String and convert it into a Bool
		@param k
		@return Null<Bool> (Bool->false if invalid value)
		@author Sunnydev31 (unreal.sunnydev)
	**/
	public static function parseBool(k:String):Bool {
		return switch (k) {
			case "true" | "1": true;
			case "false" | "0": false;
			default: false;
		}
	}
}

