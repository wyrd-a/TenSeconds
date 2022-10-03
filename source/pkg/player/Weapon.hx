package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
	This is the weapon. Idk how it works.
**/
class Weapon extends FlxSprite
{
	var VEL:Float = .15;
	var DIST:Float = 75;
	var CHARGE:Float = 200;

	public var targetAngle:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.weapon__png, true, 9, 27);
		animation.add("uncharged", [2], 60, true, false, true);
		animation.add("charged", [1], 60, true, false, true);
		setGraphicSize(Std.int(3 * this.width), 0);
		updateHitbox();

		angularDrag = 200;
		maxAngular = 400;
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

		// choose angular speed
		if (targetAngle == 69420)
		{
			angularAcceleration = 0;
		}
		else if (angle > targetAngle)
		{
			if (angle > targetAngle + 180)
			{
				angularVelocity += VEL * Math.abs(angle - 360 - targetAngle);
			}
			else
			{
				angularVelocity += -1 * VEL * Math.abs(angle - targetAngle);
			}
		}
		else if (angle < targetAngle)
		{
			if (angle > targetAngle - 180)
			{
				angularVelocity += VEL * Math.abs(angle - targetAngle);
			}
			else
			{
				angularVelocity += -1 * VEL * Math.abs(angle + 360 - targetAngle);
			}
		}

		// Weapon position on screen
		x = (-1 * DIST * Math.sin(angle / 180 * Math.PI)) + player.x + (player.width / 2) - (width / 2);
		y = (DIST * Math.cos(angle / 180 * Math.PI)) + player.y + (player.height / 2) - (height / 2);

		// Keep angle between 360 and 0
		if (angle < 0)
		{
			angle = 360;
		}
		if (angle > 360)
		{
			angle = 0;
		}

		// Weapon charge state
		if (Math.abs(angularVelocity) > CHARGE)
		{
			animation.play("charged");
			FlxG.overlap(enemy, this, hurtEnemy); // hurt the enemy!
		}
		else
		{
			animation.play("uncharged");
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
		angularVelocity = 0; // This creates the "hit" feel
	}
}
