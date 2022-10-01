package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class RewardSubState extends FlxSubState
{
	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private function handleInput()
	{
		if (FlxG.keys.pressed.ESCAPE)
		{
			// switch to pause state
		}
	}
}
