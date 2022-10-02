package pkg.enemy;

import AssetPaths;
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
	var MAXSPEED:Float = 80;
	var isCharging:Bool = false;
	var chargeTimer:Float = 0;
	var isAttacking:Bool = false;
	var attackTimer:Float = 0;

	var targetX:Float;
	var targetY:Float;

	var originalX:Int;
	var originalY:Int;

	var CLOSEDISTANCE:Int;

	public function new(x:Float = 0, y:Float = 0, CLOSEDISTANCE:Int = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.Enemy1__png);
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
		health = 5;
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
		FlxG.collide(player, this);

		if (isAttacking) // check to see if enemy is attacking
		{
			attack(player);
		}
		else if (isCharging) // check to see if target started an attack
		{
			chargeAttack();
		}
		else if (tooClose(player)) // move towards player
		{
			approach(player, -1 * MAXSPEED);
		}
		else
		{
			approach(player, MAXSPEED);
		}
	}

	function target(player:FlxSprite)
	{
		if (FlxMath.distanceBetween(player, this) < 80)
		{
			isCharging = true;
			velocity.x = 0;
			velocity.y = 0;
		}
	}

	function chargeAttack()
	{
		immovable = true;
		if (chargeTimer == 0)
		{
			chargeTimer = Timer.stamp();
			loadGraphic(AssetPaths.Enemy2__png);
		}
		if (Timer.stamp() - chargeTimer > 3)
		{
			isAttacking = true;
			isCharging = false;
		}
	}

	function attack(player:FlxSprite)
	{
		chargeTimer = 0;
		if (attackTimer == 0)
		{
			loadGraphic(AssetPaths.Enemy1__png);
			attackTimer = Timer.stamp();
			if (Math.abs(player.x - x) > Math.abs(player.y - y)) // Calculate where player is relative to enemy (attack in 4 cardinal directions)
			{
				originalY = 0;
				if (player.x > x)
				{
					setGraphicSize(108, 20 * 3); // Extend hitbox to the right
					originalX = 0;
				}
				else
				{
					setGraphicSize(108, 20 * 3); // Extend hitbox to the left
					x -= 54;
					originalX = 54;
				}
			}
			else
			{
				originalX = 0;
				if (player.y > y)
				{
					setGraphicSize(18 * 3, 120); // Extend hitbox upward
					originalY = 0;
				}
				else
				{
					setGraphicSize(18 * 3, 120); // Extend hitbox downward
					y -= 60;
					originalY = 60;
				}
			}
			updateHitbox();
		}

		if (Timer.stamp() - attackTimer > 2) // keep hitbox active for 2 seconds
		{
			isAttacking = false;
			attackTimer = 0;
			setGraphicSize(18 * 3, 20 * 3);
			x += originalX;
			y += originalY;
			updateHitbox();
		}
	}

	function playerHurt(objA:FlxSprite, objB:FlxSprite):Void
	{
		objA.health -= 1;
	}

	/**Move the enemy. Positive vel moves towards player, negative vel moves away.**/
	function approach(player:FlxSprite, vel:Float)
	{
		if (Math.abs(player.x - x) > Math.abs(player.y - y)) // Is the player further away in x or y
		{
			velocity.y = 0;
			if (player.x > x) // Move positive or negative x
				velocity.x = vel;
			else
				velocity.x = -1 * vel;
		}
		else
		{
			velocity.x = 0;
			if (player.y > y) // move positive or negative y
			{
				velocity.y = vel;
			}
			else
			{
				velocity.y = -1 * vel;
			}
		}
	}

	function tooClose(player:FlxSprite)
	{
		if (FlxMath.distanceBetween(player, this) < CLOSEDISTANCE)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	function deathCheck()
	{
		if (health < 0)
		{
			kill();
		}
	}
}
