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
	var winText:FlxText;
	var returnBtn:FlxButton;

	override public function create()
	{
		super.create();
		winText = new FlxText(200, 200, 0, "You win!");
		add(winText);

		returnBtn = new FlxButton(300, 300, "Main Menu", onClick);
		add(returnBtn);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		_parentState.update(elapsed);
	}

	function onClick()
	{
		FlxG.switchState(new StartState());
	}
}
