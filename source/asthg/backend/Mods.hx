package asthg.backend;
import polymod.Polymod;
import polymod.Polymod.PolymodErrorCode;
import polymod.PolymodConfig;
import polymod.Polymod.Framework;
import polymod.backends.PolymodAssets.PolymodAssetType;

class Mods {
	/**
		Defines the path to `mods` folder.
	**/
	inline public static final MOD_ROOT:String = #if mac '../../../' + #end
	#if debug "../../../../" + #end // Use the mods folder on project path, not the executable one
	"mods";

	inline public static final API_VERSION_RULE = ">=1.2.3 <1.5.0";

	public static var cachedMods:Array<ModMetadata> = [];

	/**
		Function to load mods.
		@param dirs Directories to load mods
	**/
	public static function loadMods(dirs:Array<String>):Void {
		Polymod.onError = getError;

		var loadedMods:Array<ModMetadata> = Polymod.init({
			modRoot: MOD_ROOT,
			dirs: dirs,
			framework: Framework.OPENFL,
			frameworkParams: getFrameworkParams(),
			apiVersionRule: API_VERSION_RULE,
			useScriptedClasses: true,
			#if TRANSLATIONS_ALLOWED
			firetongue: Locale.tongue
			#end
		});


		if (ArrayUtil.isBlank(loadedMods))
			trace("Loading complete! No mods was loaded.".infoCustom("MODS", AnsiList.BG_GREEN));
		else {
			trace("Loading complete! {0} mods was loaded.".infoCustom("MODS", AnsiList.BG_GREEN), loadedMods.length);

			for (num => i in loadedMods) {
				trace("{0}. {1} v{2} - {3}".infoCustom("MODS", AnsiList.BG_GREEN), num + 1, i.title, i.modVersion, i.id);
			}
		}
	}

	public static function getAll():Array<ModMetadata> {
		trace("Scanning mod folder...".infoCustom("MODS", AnsiList.BG_GREEN));

		cachedMods = [];

		var mods:Array<ModMetadata> = Polymod.scan({
			modRoot: MOD_ROOT,
			apiVersionRule: API_VERSION_RULE,
			errorCallback: getError
		});

		for (i in mods) {
			cachedMods.push(i);
		};

		trace("Scan finished, got {0} mods.".infoCustom("MODS", AnsiList.BG_GREEN), mods.length);

		return mods;
	}

	static function getFrameworkParams():polymod.Polymod.FrameworkParams {
		return {
			assetLibraryPaths: ['default' => 'default'] //lol
		}
	}

	public static function getError(e:PolymodError):Void {
		function error(m:Dynamic)    { trace('$m'.error().infoCustom("POLYMOD", AnsiList.BG_MAGENTA)); }
		function warn(m:Dynamic)     { trace('$m'.warn().infoCustom("POLYMOD", AnsiList.BG_MAGENTA)); }
		function log(m:Dynamic)      { trace('$m'.info().infoCustom("POLYMOD", AnsiList.BG_MAGENTA)); }
		function logDebug(m:Dynamic) { trace('$m'.infoCustom("DEBUG", [199, 68, 181]).infoCustom("POLYMOD", AnsiList.BG_MAGENTA)); }

		switch (e.code) {

			// Mod loading
			case MOD_LOAD_FAILED:
				error('Failed to load mod: ${e.message}');

			// Mod missing resources
			case MOD_MISSING_ID:
				error('Tried to load a mod that doesn\'t exists! ${e.message}');
			case MOD_MISSING_METADATA:
				error('Failed to load mod metadata for "${e.message}"!');
			case MOD_MISSING_ICON:
				error('Failed to load mod icon for "${e.message}"!');

			// Versions
			case MOD_API_VERSION_MISMATCH:
				warn('Tried to load a mod, but this uses an old API version! ${e.message}');
			case MOD_API_VERSION_PARSE_FAILED:
				warn("Tried to load a mod, but the API version could not be parsed.");

			// Assets
			case ASSET_MERGE_FAILED:
				error('Failed to merge file! ${e.message}');
			case ASSET_APPEND_FAILED:
				var text:String = e.message;
				var fileId:String = text.substring(text.indexOf("(") + 1, text.indexOf(")"));
				var fileExt:String = text.substring(text.lastIndexOf("(") + 1, text.lastIndexOf(")"));
				error('Failed to append file! ${e.message}');

			// Script parsing
			case SCRIPT_PARSE_FAILED:
				error('Failed to parse script: ${e.message}');
			case SCRIPTED_CLASS_BLACKLISTED_MODULE:
				warn('You can\'t use module "${e.message}": It was blacklisted.');
			case SCRIPTED_CLASS_BLACKLISTED_FIELD:
				warn('You can\'t use field "${e.message}": It was blacklisted.');

			// Non-important Infos
			case MOD_LOAD_START | MOD_LOAD_DONE | SCRIPT_PARSE_START | SCRIPT_PARSE_DONE | FRAMEWORK_INIT:
				return;

			// Other errors
			default:
				switch (e.severity) {
					case PolymodErrorType.ERROR:   error(e.message);
					case PolymodErrorType.WARNING: warn(e.message);
					case PolymodErrorType.INFO:    log(e.message);
					case PolymodErrorType.DEBUG:   logDebug(e.message);
				}
		}
	}
}