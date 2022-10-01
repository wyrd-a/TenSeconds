package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	var up:Bool;
	var down:Bool;
	var left:Bool;
	var right:Bool;
	var VEL:Float = 100;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.GREEN);
	}

	override public function update(elapsed:Float):Void
	{
		move();
		boundToBorder();
		super.update(elapsed);
	}

	function move()
	{
		// Grab movement keys
		up = FlxG.keys.pressed.W || FlxG.keys.pressed.UP;
		down = FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN;
		left = FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT;
		right = FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT;

		// Up/Down speed
		if ((up && down) || !up && !down)
		{
			velocity.y = 0;
		}
		else if (down)
		{
			velocity.y = VEL;
		}
		else if (up)
		{
			velocity.y = -1 * VEL;
		}

		// Left/Right speed
		if ((left && right) || !left && !right)
			velocity.x = 0;
		else if (right)
		{
			velocity.x = VEL;
		}
		else if (left)
		{
			velocity.x = -1 * VEL;
		}
	}

	function boundToBorder() // replace with
	{
		if (x > FlxG.width)
			x = -1 * width + 1;
		else if (x < -1 * width)
			x = FlxG.width - 1;

		if (y > FlxG.height)
			y = -1 * height + 1;
		else if (y < -1 * height)
			y = FlxG.height - 1;
	}
}
