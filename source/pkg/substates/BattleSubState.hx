package pkg.substates;

import flixel.FlxSubState;
import pkg.room.Room;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	override public function create()
	{
		super.create();

		this.room = new Room();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		trace("Updated in battle state");
	}
}
