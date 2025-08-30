package options;

class GraphicsSubState extends BaseOptionsMenu {
    public function new() {
        var option:Option = new Option("Low Quality", "Makes the game have a better performance for low-end platforms", 'lowQuality', BOOL);
        addOption(option);

        var option:Option = new Option("Anti-Aliasing", "Makes graphics HD-styled in cost of performance\n(Enabled by default on HD Fonts)", 'antialiasing', BOOL);
        addOption(option);
        super();
    }
}

