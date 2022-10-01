package pkg.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import pkg.substates.PauseSubState;

/**
	Main playstate, includes logic for switching between 
	various substates for different aspects of playing the
	game.
**/
class PlayState extends FlxState
{
	override public function create() {}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.pressed.SPACE)
		{
			var pausedSubState = new PauseSubState();
			openSubState(pausedSubState);
		}
	}
}
