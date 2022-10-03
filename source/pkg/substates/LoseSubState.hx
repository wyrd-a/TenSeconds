package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import pkg.states.StartState;

class LoseSubState extends FlxSubState
{
	var winScreen:FlxSprite;
	var returnBtn:FlxButton;

	override public function create()
	{
		super.create();
		winScreen = new FlxSprite(0, 0);
		winScreen.loadGraphic(AssetPaths.deathScreen__png);
		winScreen.scale.set(3, 3);
		winScreen.updateHitbox();
		winScreen.setPosition(0, 0);
		add(winScreen);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.pressed)
		{
			FlxG.switchState(new StartState());
		}
		super.update(elapsed);
		_parentState.update(elapsed);
	}
}
