package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
	This is the weapon. Idk how it works.
**/
class Weapon extends FlxSprite
{
	var up:Bool;
	var down:Bool;
	var left:Bool;
	var right:Bool;
	var VEL:Float = 100;

	var targetX:Float;
	var targetY:Float;

	var distCCW:Float;
	var distCW:Float;

	public var targetAngle:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.GRAY);
		angularDrag = 20;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	// Keep weapon relative to player
	public function move(player:FlxSprite)
	{
		// control angle
		targetAngle = angleControl(player);

		angularVelocity = 50;

		x = (-20 * Math.sin(angle / 180 * Math.PI)) + player.x;
		y = (20 * Math.cos(angle / 180 * Math.PI)) + player.y;
		targetX = (-20 * Math.sin(targetAngle / 180 * Math.PI)) + player.x;
		targetY = (20 * Math.cos(targetAngle / 180 * Math.PI)) + player.y;

		if (angle < 0)
		{
			angle = 360;
		}
		if (angle > 360)
		{
			angle = 0;
		}
	}

	function angleControl(player:FlxSprite):Float
	{
		if (player.velocity.x > 0)
		{
			if (player.velocity.y > 0)
			{
				return 135;
			}
			else if (player.velocity.y < 0)
			{
				return 45;
			}
			else
			{
				return 90;
			}
		}
		else if (player.velocity.x < 0)
		{
			if (player.velocity.y > 0)
			{
				return 225;
			}
			else if (player.velocity.y < 0)
			{
				return 315;
			}
			else
			{
				return 270;
			}
		}
		else
		{
			if (player.velocity.y > 0)
			{
				return 180;
			}
			else if (player.velocity.y < 0)
			{
				return 0;
			}
			else
			{
				return angle;
			}
		}
	}
}
