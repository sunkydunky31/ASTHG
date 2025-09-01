package options;

class GraphicsSubState extends BaseOptionsMenu {
    public function new() {
        var option:Option = new Option("Low Quality", "Makes the game have a better performance for low-end platforms", 'lowQuality', BOOL);
        addOption(option);
        super();
    }
}

