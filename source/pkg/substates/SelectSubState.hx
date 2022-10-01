package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class SelectSubState extends FlxSubState
{
	override public function create() {}

	override public function update(elapsed:Float) {}

	private function handleInput()
	{
		if (FlxG.keys.pressed.ESCAPE)
		{
			// switch to pause state
		}
	}
}
