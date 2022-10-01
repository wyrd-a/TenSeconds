package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.Timer;

/**
	This is the enemy. AI and damage dealing is handled here.
**/
class Enemy extends FlxSprite
{
	var VEL:Float = 50;
	var isAttacking:Bool = false;
	var chargeTimer:Float = 0;

	var targetX:Float;
	var targetY:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.RED);
	}

	override public function update(elapsed:Float):Void
	{
		if (isAttacking)
		{
			chargeAttack();
		}
		super.update(elapsed);
	}

	public function trackPlayer(player:FlxSprite)
	{
		target(player);
		FlxG.collide(player, this, playerHurt);
		if (!isAttacking)
		{
			if (Math.abs(player.x - x) > Math.abs(player.y - y))
			{
				if (player.x > x)
					velocity.x = VEL;
				else
					velocity.x = -1 * VEL;
			}
			else
			{
				if (player.y > y)
				{
					velocity.y = VEL;
				}
				else
				{
					velocity.y = -1 * VEL;
				}
			}
		}
	}

	function target(player:FlxSprite)
	{
		if (FlxMath.distanceBetween(player, this) < 30)
		{
			isAttacking = true;
			velocity.x = 0;
			velocity.y = 0;
			color = 0x58D971;
		}
	}

	function chargeAttack()
	{
		if (chargeTimer == 0)
		{
			chargeTimer = Timer.stamp();
		}
		if (Timer.stamp() - chargeTimer > 3)
		{
			attack();
		}
	}

	function attack()
	{
		color = 0xF6FF00;
		isAttacking = false;
		chargeTimer = 0;
		setGraphicSize(32, 32);
		this.updateHitbox();
	}

	function playerHurt(objA:FlxSprite, objB:FlxSprite):Void
	{
		objA.health -= 1;
	}
}
