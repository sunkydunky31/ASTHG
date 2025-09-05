package states.editors;

import haxe.ui.RuntimeComponentBuilder;
import haxe.ui.core.Component;
import haxe.ui.Toolkit;
import haxe.ui.core.Screen;

/**
 * "Father" class state, for creating editors
 */
class BaseEditor extends MusicBeatState {
	public var comp:Component;
	var xmlName:String;

	public function new(state:String) {
		super();
		xmlName = state;
	}

	override function create() {
		Toolkit.init();

		xmlName = (xmlName == null) ? "default" : xmlName;

        if (comp == null) comp = RuntimeComponentBuilder.fromAsset(Paths.getPath('data/ui-editors/$xmlName.xml'));
		Screen.instance.addComponent(comp);
	}

}