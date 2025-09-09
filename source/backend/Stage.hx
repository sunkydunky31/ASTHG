package backend;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.math.FlxRect;
import objects.StageBase;

class Stage extends flixel.group.FlxGroup {
    public var instance:Stage;
	public var map:FlxOgmo3Loader;
	public var walls:FlxTilemap;

    public function new(folder:String, act:Int) {
        super();
		instance = this;
        loadAssets(folder, act);
		FlxG.collide(states.PlayState.instance.player, walls);
	}
    
	public function loadAssets(folder:String, act:Int) {
		var mapPath = Paths.getPath('stages/$folder');
	
		map = new FlxOgmo3Loader('$mapPath/act$act.ogmo', '$mapPath/act${act}.json');
		walls = map.loadTilemap(mapPath + "/tiles", "tile");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
	}
	
	public function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			states.PlayState.instance.player.setPosition(entity.x, entity.y);
		}
	}
}