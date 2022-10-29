package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import pkg.config.Config;
import pkg.states.StartState;

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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
