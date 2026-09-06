package asthe.backend;

#if (DISCORD_ALLOWED && cpp)
import lime.app.Application;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

@:nullSafety()
/**
	@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/Discord.hx
**/
class DiscordClient {
	public static var isInitialized:Bool = false;
	private static final _defaultID:String = "1403567132179959928";
	public static var clientID(default, set):String = _defaultID;
	private static var presence:DiscordRichPresence = DiscordRichPresence.create();

	public static function check() {
		if(ClientPrefs.data.options.discordRPC) initialize();
		else if(isInitialized) shutdown();
	}

	public static function prepare() {
		if (!isInitialized && ClientPrefs.data.options.discordRPC)
			initialize();

		Application.current.window.onClose.add(function() {
			if(isInitialized) shutdown();
		});
	}

	public dynamic static function shutdown() {
		Discord.shutdown();
		isInitialized = false;
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void {
		log('Client has connected!');

		final username = cast(request[0].username, String);
		final discriminator = cast(request[0].discriminator, String);

		log("User: " + (discriminator != "0" ? '${username}#${discriminator}' : '@${username}') );
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void {
		log('Error (${errorCode}: ${cast(message, String)})');
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void {
		log('Disconnected (${errorCode}: ${cast(message, String)})');
	}

	public static function initialize() {
		var discordHandlers:DiscordEventHandlers = DiscordEventHandlers.create();
		discordHandlers.ready        = cpp.Function.fromStaticFunction(onReady);
		discordHandlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		discordHandlers.errored      = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(clientID, cpp.RawPointer.addressOf(discordHandlers), 1, "");

		if(!isInitialized) log("Initialized!");

		sys.thread.Thread.create(() -> {
			var localID:String = clientID;
			while (localID == clientID) {
				#if DISCORD_DISABLE_IO_THREAD
				Discord.updateConnection();
				#end
				Discord.runCallbacks();

				// Wait 0.5 seconds until the next loop...
				Sys.sleep(0.5);
			}
		});
		isInitialized = true;
	}

	public static function changePresence(?params:DiscordParameters) {
		var startTimestamp:Float = 0, endTimestamp:Float = 0;
		if (params != null) {
			if (params?.hasStartTimestamp == true)
				startTimestamp = Date.now().getTime();
			if (params.endTimestamp != null && params.endTimestamp > 0)
				endTimestamp = startTimestamp + params.endTimestamp;
		}

		presence.details        = params?.details        ?? "In the Menus";
		presence.largeImageKey  = params?.imageLargeKey  ?? "icon";
		presence.largeImageText = params?.imageLargeText ?? "In menus";
		presence.smallImageKey  = params?.imageSmallKey  ?? "";
		presence.smallImageText = params?.imageSmallText ?? "";
		presence.state          = params?.state          ?? "";
		presence.partyId        = params?.partyId        ?? "";

		// Obtained times are in milliseconds so they are divided so Discord can use it
		presence.startTimestamp = Std.int(startTimestamp / 1000);
		presence.endTimestamp   = Std.int(endTimestamp   / 1000);
		updatePresence();
	}

	public static function updatePresence()
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));

	public static function resetClientID()
		clientID = _defaultID;

	private static function set_clientID(newID:String) {
		var change:Bool = (clientID != newID);
		clientID = newID;

		if(change && isInitialized) {
			shutdown();
			initialize();
			updatePresence();
		}
		return newID;
	}

	static function log(msg:String, ?args:haxe.PosInfos) {
		trace(msg.infoCustom("DISCORD", AnsiList.BG_BLUE), args);
	}
}

typedef DiscordParameters = {
	var ?details:String;

	var ?state:Null<String>;

	var ?imageLargeKey:String;
	var ?imageLargeText:String;
	var ?imageSmallKey:String;
	var ?imageSmallText:String;

	var ?partyId:String;

	var ?hasStartTimestamp:Bool;
	var ?endTimestamp:Float;
}
#end