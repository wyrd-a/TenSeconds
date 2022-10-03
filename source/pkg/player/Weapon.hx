package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.util.FlxColor;
import haxe.Timer;

/**
	This is the weapon. Idk how it works.
**/
class Weapon extends FlxSprite
{
	var VEL:Float = 4;

	public var DIST:Float = 75;
	public var CHARGE:Float = 350;
	public var targetAngle:Float;

	public var spunUp:Bool = false;

	var spinTimer:Float = 0;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.weapon__png, true, 11, 29);
		animation.add("uncharged", [1], 60, true, false, true);
		animation.add("charged", [0], 60, true, false, true);
		setGraphicSize(Std.int(3 * this.width), 0);
		updateHitbox();
		angularDrag = 100;
		maxAngular = 1000;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	// Keep weapon relative to player
	public function move(player:FlxSprite, enemy:FlxSprite)
	{
		// control angle
		// targetAngle = angleControl(player);
		targetAngle = FlxAngle.angleBetweenMouse(player, true) - 90;

		if (!spunUp)
		{ // choose angular speed
			if (targetAngle == 69420)
			{
				angularAcceleration = 0;
			}
			else if (angle > targetAngle)
			{
				if (angle > targetAngle + 180)
				{
					angularVelocity += VEL;
				}
				else
				{
					angularVelocity += -1 * VEL;
				}
			}
			else if (angle < targetAngle)
			{
				if (angle > targetAngle - 180)
				{
					angularVelocity += VEL;
				}
				else
				{
					angularVelocity += -1 * VEL;
				}
			}
		}
		else
		{
			if (angularVelocity > 0)
			{
				angularVelocity = CHARGE + 10;
			}
			else
			{
				angularVelocity = -1 * (CHARGE + 10);
			}
			if (spinTimer == 0)
			{
				spinTimer = Timer.stamp();
			}
			if ((Timer.stamp() - spinTimer > 5) || !spunUp)
			{
				spunUp = false;
				if (angularVelocity > 0)
				{
					angularVelocity = 150;
				}
				else
				{
					angularVelocity = -150;
				}
				spinTimer = 0;
			}
		}

		// Weapon position on screen
		x = (-1 * DIST * Math.sin(angle / 180 * Math.PI)) + player.x + (player.width / 2) - (width / 2);
		y = (DIST * Math.cos(angle / 180 * Math.PI)) + player.y + (player.height / 2) - (height / 2);

		// Keep angle between -180 and 180
		if (angle < -180)
		{
			angle = 180;
		}
		if (angle > 180)
		{
			angle = -180;
		}

		// Weapon charge animation
		if (Math.abs(angularVelocity) > CHARGE)
		{
			spunUp = true;
			animation.play("charged");
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
}
