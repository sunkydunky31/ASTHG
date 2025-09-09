package options;

class GraphicsSubState extends BaseOptionsMenu {
    public function new() {

        var option:Option = new Option("Background Layers", "Adds a black layer for the backgrounds making it not much luminous", 'backLayers', PERCENT);
        addOption(option);

		var option:Option = new Option("Show Framerate", "", "showFPS", BOOL);
		addOption(option);

		var option:Option = new Option("Framerate", "", "framerate", INT);
		addOption(option);

        var option:Option = new Option("Low Quality", "Makes the game have a better performance for low-end platforms", 'lowQuality', BOOL);
        addOption(option);

        super();
    }
}

