package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PauseSubState extends FlxSubState
{
	override public function create()
	{
		super.create();
		var startBg = new FlxSprite(0, 0);
		startBg.loadGraphic(AssetPaths.dumbcat2__jpg);
		add(startBg);
	}

	override public function update(elapsed:Float) {}

	private function handleInput()
	{
		if (FlxG.keys.pressed.ESCAPE)
		{
			// switch to pause state
		}
	}
}
