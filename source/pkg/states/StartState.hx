package pkg.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

/**
	Start screen
**/
class StartState extends FlxState
{
	override public function create()
	{
		super.create();
		var startBg = new FlxSprite(0, 0);
		startBg.loadGraphic(AssetPaths.dumbcat1__jpg);

		var startButton = new FlxButton(0, 0, "Start", clickStart);
		startButton.screenCenter();

		add(startBg);
		add(startButton);
	}

	function clickStart()
	{
		FlxG.switchState(new PlayState());
	}
}
