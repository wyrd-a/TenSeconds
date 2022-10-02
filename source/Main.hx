package;

import flixel.FlxGame;
import openfl.display.Sprite;
import pkg.states.StartState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, StartState));
	}
}
