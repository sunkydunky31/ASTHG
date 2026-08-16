package util;

import haxe.io.Path;

import sys.FileSystem;
import sys.io.File;

/**
	Utilities used for File and FileSystem management
**/
@:nullSafety
class FileUtil {

	/**
		Deletes a directory, recursively or not
		Throws an error if it isn't a directory
		@param path The path to the directory
		@param recursive Should it delete all the files included?
	**/
	public static function deleteDirectory(path:String, ?recursive:Bool = false):Void {
		if (!FileSystem.exists(path)) return;

		if (FileSystem.isDirectory(path)) {
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
			throw("The passed path doesn't is not a directory! (" + path + ")");
	}
}