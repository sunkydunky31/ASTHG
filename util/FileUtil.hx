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
		if (!FileSystem.exists(path)) return;

		if (FileSystem.isDirectory(path)) {
			if (recursive) {
				for (i in FileSystem.readDirectory(path)) {
					var p = Path.join([path, i]);
					if (FileSystem.isDirectory(p))
						deleteDirectory(p, recursive);
					else
						FileSystem.deleteFile(p);
				}
			}

			FileSystem.deleteDirectory(path);
		}
		else
			throw new haxe.Exception("The inserted path isn't a directory! (" + path + ")");
	}

	/**
		Appends a `String` into a file
		@param path The path that the file is stored in
		@param msg The message you want to append
		@returns Void
	**/
	public static function appendToFile(path:String, msg:String):Void {
		var p = new Path(path);

		if (!sys.FileSystem.exists(p.dir))
			sys.FileSystem.createDirectory(p.dir);

		try {
			var out:FileOutput = File.append(path, false);
			out.writeString(msg);
			out.close();
		}
		catch (e:Dynamic) {
			trace("Error when appending to file in '"+ path +"': " + e);
		}
	}

	/**
		Stores content in the file specified by path.  
		If the file cannot be written to, an exception is thrown.  
		If path or content are null, the result is unspecified.
		@param path 
		@param msg 
	**/
	public static function saveContent(path:Null<String> = null, content:Dynamic):Void {
		if (StringUtil.isBlank(path)) {trace("'path' is blank!"); return;}

		var p = new Path(path);

		if (!sys.FileSystem.exists(p.dir))
			sys.FileSystem.createDirectory(p.dir);

		try {
			File.saveContent(path, Std.string(content));
		}
		catch (e:Dynamic) {
			trace("Error when saving '"+ path +"': " + e);
		}
	}
}
