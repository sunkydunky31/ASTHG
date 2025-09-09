package options;

class GameplaySubState extends BaseOptionsMenu {
    public function new() {
        title = Language.getPhrase("options_gameplay", 'Gameplay');
        rpcState = Language.getPhrase("discordrpc_options-gameplay", "Gameplay Substate");
        
        var option:Option = new Option("Auto Pause", "", "autoPause", BOOL);
        addOption(option);
        
        var option:Option = new Option("Flashing Lights", "", "flashing", BOOL);
        addOption(option);
        
        var option:Option = new Option("Hide Hud", "", "hideHud", BOOL);
        addOption(option);

        super();
    }
}