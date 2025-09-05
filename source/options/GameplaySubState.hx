package options;

class GameplaySubState extends BaseOptionsMenu {
    public function new() {
        title = Language.getPhrase("options_gameplay", 'Gameplay');
        rpcState = Language.getPhrase("discordrpc_options-gameplay", "Gameplay Substate");
        
        var option:Option = new Option("Haptics", "Make your device vibrate depending of the content on the screen", "haptics", BOOL);
        addOption(option);
        
        var option:Option = new Option("Haptics", "Make your device vibrate depending of the content on the screen", "haptics", BOOL);
        addOption(option);
        
        var option:Option = new Option("Haptics", "Make your device vibrate depending of the content on the screen", "haptics", BOOL);
        addOption(option);

        super();
    }
}