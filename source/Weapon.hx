package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

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
	public function move(playerX:Float, playerY:Float, playerVX:Float, playerVY:Float)
	{
		// control angle
		targetAngle = angleControl(playerVX, playerVY);

		if (angle < targetAngle + 180)
		{
			angularVelocity = 50;
		}
		else
		{
			angularVelocity = -50;
		}

		x = (-20 * Math.sin(angle / 180 * Math.PI)) + playerX;
		y = (20 * Math.cos(angle / 180 * Math.PI)) + playerY;
		targetX = (-20 * Math.sin(targetAngle / 180 * Math.PI)) + playerX;
		targetY = (20 * Math.cos(targetAngle / 180 * Math.PI)) + playerY;

		if (angle < 0)
		{
			angle = 360;
		}
		if (angle > 360)
		{
			angle = 0;
		}
	}

	function angleControl(playerVX:Float, playerVY:Float):Float
	{
		if (playerVX > 0)
		{
			if (playerVY > 0)
			{
				return 135;
			}
			else if (playerVY < 0)
			{
				return 45;
			}
			else
			{
				return 90;
			}
		}
		else if (playerVX < 0)
		{
			if (playerVY > 0)
			{
				return 225;
			}
			else if (playerVY < 0)
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
			if (playerVY > 0)
			{
				return 180;
			}
			else if (playerVY < 0)
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
