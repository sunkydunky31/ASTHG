/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-08-27
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package asthe.backend.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

class GitTools {
	static function main() {
		trace("Haxe is great!");
	}

	/**
		Gets the current commit hash from Git
		@return String
	**/
	public static macro function getCommitHash():Expr.ExprOf<String> {
		#if display
		return macro $v{"unknown"};
		#else
		var hash = "unknown";
		var p = new sys.io.Process("git", ["rev-parse", "--short", "HEAD"]);
		if (p.exitCode() != 0) {
			var msg = p.stderr.readAll().toString();
			var pos = Context.currentPos();
			Context.error("Failed when getting commit hash! do you have Git installed? (" + msg + ")", pos);
		}
		
		hash = p.stdout.readLine();
		return macro $v{hash};
		#end
	}
}