package backend;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.AtlasBase;
import flixel.graphics.atlas.TexturePackerAtlas;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import haxe.xml.Access;
import openfl.Assets;
import openfl.geom.Rectangle;
import flixel.graphics.frames.FlxFramesCollection;

/**
 * Just a atlas parser that I edited from SPARROW
 * @author Sunkdev31
 */
class CustomAtlasFrames extends FlxFramesCollection {
	var usedGraphics:Array<FlxGraphic> = [];
	
	public function new(parent:FlxGraphic, ?border:FlxPoint)
	{
		super(parent, FlxFrameCollectionType.ATLAS, border);
	}
	
	public static function fromASTHGSparrow(source:FlxGraphicAsset, xml:FlxXmlAsset):FlxAtlasFrames
	{
		var graphic:FlxGraphic = FlxG.bitmap.add(source);
		if (graphic == null)
			return null;
		// No need to parse data again
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		if (graphic == null || xml == null)
			return null;

		frames = new FlxAtlasFrames(graphic);

		var data:Access = new Access(xml.getXml().firstElement());

		for (texture in data.nodes.animation) {
			var idx:Int = 0;
			var name = texture.att.id;
			for (frame in texture.nodes.frame) {
				var rect = FlxRect.get(Std.parseFloat(frame.att.x), Std.parseFloat(frame.att.y), Std.parseFloat(frame.att.width), Std.parseFloat(frame.att.height));

				var size = new Rectangle((frame.has.centerX) ? Std.parseFloat(frame.att.centerX) : 0, (frame.has.centerY) ? Std.parseFloat(frame.att.centerY) : 0, rect.width, rect.height);

				var offset = FlxPoint.get(-size.left, -size.top);
				var sourceSize = FlxPoint.get(size.width, size.height);
				frames.addAtlasFrame(rect, sourceSize, offset, name + "_" + idx, 0, false, false);

				idx++;
			}

		}

		return frames;
	}
}