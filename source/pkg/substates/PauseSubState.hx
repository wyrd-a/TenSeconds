package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class PauseSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	override public function create()
	{
		super.create();
		var startBg = new FlxSprite(0, 0);
		startBg.loadGraphic(AssetPaths.dumbcat2__jpg);
		add(startBg);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		trace("Updated pause substate");
	}
}
