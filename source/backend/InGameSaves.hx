package backend;

class InGameSaves {
    public static var saveEmeralds:Map<Int, Dynamic> = new Map();

    public static function setEmeralds(save:Int, num:Int) {
        saveEmeralds.set(save, num);
        FlxG.save.data.emeralds = saveEmeralds;
        FlxG.save.data.flush();
    }
}