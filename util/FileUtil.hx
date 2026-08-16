package util;

import haxe.io.Path;

import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

/**
	Utilities used for File and FileSystem management
**/
//@:nullSafety
class FileUtil {

	/**
		Deletes a directory, recursively or not
		Throws an error if it isn't a directory
		@param path The path to the directory
		@param recursive Should it delete all the files included?
		@returns Void
	**/
	public static function deleteDirectory(path:String, ?recursive:Bool = false):Void {
		recursive ??= false;

		if (!FileSystem.exists(path)) return;

		if (FileSystem.isDirectory(path)) {
			if (!recursive) {
				for (i in FileSystem.readDirectory(path)) {
					var p = Path.join([path, i]);
					if (FileSystem.isDirectory(p))
						deleteDirectory(p);
					else
						FileSystem.deleteFile(p);
				}
				FileSystem.deleteDirectory(path);
			}
			else
				FileSystem.deleteDirectory(path);
		}
		else
			throw("The passed path doesn't is not a directory! (" + path + ")");
	}

	/**
		Appends a `String` into a file
		@param path The path that the file is stored in
		@param msg The message you want to append
		@returns Void
	**/
	public static function appendToFile(path:String, msg:String):Void {
		var out:FileOutput = File.append(path, false);
		out.writeString(msg);
		out.close();
	}
}