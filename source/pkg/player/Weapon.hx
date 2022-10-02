package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
	This is the weapon. Idk how it works.
**/
class Weapon extends FlxSprite
{
	var VEL:Float = 2;
	var DIST:Float = 100;

	public var targetAngle:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.GRAY);
		angularDrag = 400;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	// Keep weapon relative to player
	public function move(player:FlxSprite, enemy:FlxSprite)
	{
		// control angle
		targetAngle = angleControl(player);

		FlxG.collide(enemy, this, hurtEnemy);

		// choose angular speed
		if (targetAngle == 69420)
		{
			angularAcceleration = 0;
		}
		else if (angle > targetAngle)
		{
			if (angle > targetAngle + 180)
			{
				angularAcceleration = VEL * Math.abs(angle - 360 - targetAngle);
			}
			else
			{
				angularAcceleration = -1 * VEL * Math.abs(angle - targetAngle);
			}
		}
		else if (angle < targetAngle)
		{
			if (angle > targetAngle - 180)
			{
				angularAcceleration = VEL * Math.abs(angle - targetAngle);
			}
			else
			{
				angularAcceleration = -1 * VEL * Math.abs(angle + 360 - targetAngle);
			}
		}

		// Weapon color change
		if (Math.abs(angularVelocity) > 200)
		{
			color = 0x8871C2;
		}
		else
		{
			color = 0x030904;
		}

		// Weapon position on screen
		x = (-1 * DIST * Math.sin(angle / 180 * Math.PI)) + player.x + (player.width / 2);
		y = (DIST * Math.cos(angle / 180 * Math.PI)) + player.y + (player.height / 2);

		// Keep angle between 360 and 0
		if (angle < 0)
		{
			angle = 360;
		}
		if (angle > 360)
		{
			angle = 0;
		}
	}

	//**Calculates where the weapon is relative to the player and the weapon's rotational speed.**/
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
				return 69420;
			}
		}
	}

	function hurtEnemy(objA:FlxSprite, objB:FlxSprite):Void
	{
		objA.health -= 1;
	}
}
