package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.weapon.FlxBullet;
import flixel.input.mouse.FlxMouseButton;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Timer;
import haxe.iterators.StringKeyValueIterator;
import pkg.states.StartState;

class WinSubState extends FlxSubState
{
	var winScreen:FlxSprite;
	var returnBtn:FlxButton;
	var screenTimer:Float;
	var screenFade:FlxSprite;
	var newImage:Bool = false;
	var creditCounter:Int = 0;
	var fuckYouGame:Float;

	override public function create()
	{
		super.create();
		winScreen = new FlxSprite(0, 0);
		winScreen.loadGraphic(AssetPaths.winScreen__png, true, 288, 192);
		winScreen.scale.set(3, 3);
		winScreen.updateHitbox();
		winScreen.setPosition(0, 0);
		add(winScreen);

		NGio.unlockMedal(71324);

		screenFade = new FlxSprite(0, 0);
		screenFade.makeGraphic(1000, 1000, FlxColor.BLACK);
		screenFade.alpha = 0;
		add(screenFade);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		/*if (FlxG.mouse.pressed)
			{
				FlxG.switchState(new StartState());
		}*/

		if (screenTimer == 0)
		{
			screenTimer = Timer.stamp();
		}
		else if (!newImage)
		{
			// play fade animation here
			screenFade.alpha += 0.005;
			if (screenFade.alpha >= 1)
			{
				newImage = true;
				creditCounter += 1;
				winScreen.animation.add(Std.string(creditCounter), [creditCounter]);
				winScreen.animation.play(Std.string(creditCounter));
			}
		}
		if (newImage)
		{
			screenFade.alpha -= 0.005;
			if (screenFade.alpha <= 0)
			{
				newImage = false;
				screenTimer = 0;
			}
		}
		if (creditCounter == 11)
		{
			FlxG.switchState(new StartState());
		}
	}
}
