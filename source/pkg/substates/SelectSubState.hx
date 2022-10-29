package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class SelectSubState extends FlxSubState
{
	var pauseScreen:FlxSprite;

	override public function create()
	{
		super.create();
		pauseScreen = new FlxSprite(0, 0);
		pauseScreen.loadGraphic(AssetPaths.pause__png);
		pauseScreen.scale.set(3, 3);
		pauseScreen.updateHitbox();
		pauseScreen.setPosition(0, 0);
		add(pauseScreen);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
		super.update(elapsed);
	}
}
