package pkg.substates;

import flixel.FlxSprite;
import flixel.FlxSubState;
import pkg.menu.PauseMenu;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class PauseSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	private var pauseMenu:PauseMenu;

	override public function create()
	{
		super.create();
		this.pauseMenu = new PauseMenu();
		// var startBg = new FlxSprite(0, 0);
		// startBg.loadGraphic(AssetPaths.dumbcat2__jpg);
		// add(startBg);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		trace("Updated pause substate");
	}
}
