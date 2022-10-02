package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Timer;

/**
	This is the Ghost. It uses an AOE attack when it gets close.
**/
class Bat extends Enemy
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Ghost specific stuff
		tooCloseDist = 0;
		attackCD = 1;
		chargeCD = 1;
		iframeCD = 1;
		maxSpeed = 100;
		health = 5;

		loadGraphic(AssetPaths.bat__png, true, 25, 22);
		createAnimations();
		animation.play("right");
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	override function attack(player:FlxSprite)
	{
		// add special AI here if you want, otherwise just use regular attack function
	}

	function createAnimations()
	{
		animation.add("right", [0, 1, 2, 3, 4, 5, 6], animRate, true, true, false);
		animation.add("left", [0, 1, 2, 3, 4, 5, 6], animRate, true, false, false);
	}
}
