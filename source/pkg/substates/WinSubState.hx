package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.weapon.FlxBullet;
import flixel.input.mouse.FlxMouseButton;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.iterators.StringKeyValueIterator;
import pkg.states.StartState;

class WinSubState extends FlxSubState
{
	var winScreen:FlxSprite;
	var returnBtn:FlxButton;

	override public function create()
	{
		super.create();
		winScreen = new FlxSprite(0, 0);
		winScreen.loadGraphic(AssetPaths.winScreen__png);
		winScreen.scale.set(3, 3);
		winScreen.updateHitbox();
		winScreen.setPosition(0, 0);
		add(winScreen);
		NGio.unlockMedal(APIcodes.MEDALONEID);
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
