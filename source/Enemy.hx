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
	var isCharging:Bool = false;
	var chargeTimer:Float = 0;
	var isAttacking:Bool = false;
	var attackTimer:Float = 0;

	var targetX:Float;
	var targetY:Float;

	var originalX:Int;
	var originalY:Int;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.BLUE);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**
		Very jank function, essentially just put the player in here for the enemy AI to work. Handles targetting, attacking, even damaging the player.
	**/
	public function trackPlayer(player:FlxSprite)
	{
		// find player
		target(player);

		// collide with player/deal damage
		FlxG.overlap(player, this, playerHurt);

		if (isAttacking) // check to see if enemy is attacking
		{
			attack(player);
		}
		else if (isCharging) // check to see if target started an attack
		{
			chargeAttack();
		}
		else // move towards player
		{
			if (Math.abs(player.x - x) > Math.abs(player.y - y))
			{
				velocity.y = 0;
				if (player.x > x)
					velocity.x = VEL;
				else
					velocity.x = -1 * VEL;
			}
			else
			{
				velocity.x = 0;
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
		if (FlxMath.distanceBetween(player, this) < 28)
		{
			isCharging = true;
			velocity.x = 0;
			velocity.y = 0;
			color = 0x58D971;
		}
	}

	function chargeAttack()
	{
		immovable = true;
		if (chargeTimer == 0)
		{
			chargeTimer = Timer.stamp();
		}
		if (Timer.stamp() - chargeTimer > 3)
		{
			isAttacking = true;
			isCharging = false;
		}
	}

	function attack(player:FlxSprite)
	{
		color = 0xF6FF00;
		chargeTimer = 0;
		if (attackTimer == 0)
		{
			attackTimer = Timer.stamp();
			if (Math.abs(player.x - x) > Math.abs(player.y - y)) // Calculate where player is relative to enemy (attack in 4 cardinal directions)
			{
				originalY = 0;
				if (player.x > x)
				{
					setGraphicSize(32, 16); // Extend hitbox to the right
					originalX = 0;
				}
				else
				{
					setGraphicSize(32, 16); // Extend hitbox to the left
					x -= 16;
					originalX = 16;
				}
			}
			else
			{
				originalX = 0;
				if (player.y > y)
				{
					setGraphicSize(16, 32); // Extend hitbox upward
					originalY = 0;
				}
				else
				{
					setGraphicSize(16, 32); // Extend hitbox downward
					y -= 16;
					originalY = 16;
				}
			}
			updateHitbox();
		}

		if (Timer.stamp() - attackTimer > 2) // keep hitbox active for 2 seconds
		{
			isAttacking = false;
			attackTimer = 0;
			setGraphicSize(16, 16);
			x += originalX;
			y += originalY;
			updateHitbox();
		}
	}

	function playerHurt(objA:FlxSprite, objB:FlxSprite):Void
	{
		objA.health -= 1;
	}
}
