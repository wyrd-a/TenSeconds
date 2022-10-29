package pkg.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import pkg.config.Config;

/**
	Load NG stuff
**/
class InitState extends FlxState
{
	var stateSwapTimer:Int = 0;

	var button:FlxButton;

	override public function create()
	{
		FlxG.mouse.load(AssetPaths.crosshair__png);
		super.create();
		NGio.noLogin(APIcodes.APPID);

		button = new FlxButton(0, 0, "Start", onClick);
		add(button);
		button.screenCenter();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function onClick()
	{
		FlxG.switchState(new StartState());
	}
}
