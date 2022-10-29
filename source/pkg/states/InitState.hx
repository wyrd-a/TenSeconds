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
		var ng:NGio = new NGio(APIcodes.APPID, APIcodes.ENCRYPT);

		button = new FlxButton(0, 0, "Launch Game", onClick);
		add(button);
		button.screenCenter();

		// Remember to set this to 0.8
		FlxG.sound.volume = 1;
	}

	override public function update(elapsed:Float)
	{
		screenSize();
		super.update(elapsed);
	}

	function onClick()
	{
		FlxG.switchState(new StartState());
	}

	function screenSize()
	{
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
