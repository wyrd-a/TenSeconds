package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import pkg.room.Room;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	private var room:Room;

	override public function create()
	{
		super.create();

		this.room = new Room();
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
