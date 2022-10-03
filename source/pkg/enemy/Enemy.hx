package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.gamepad.mappings.XInputMapping;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap.GraphicAuto;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.Timer;
import haxe.macro.Type.AbstractType;
import openfl.display.Graphics;

/**
	This is the enemy. AI and damage dealing is handled here.
**/
class Enemy extends FlxSprite
{
	public var isCharging:Bool = false;

	var chargeTimer:Float = 0;

	public var isAttacking:Bool = false;

	var attackTimer:Float = 0;

	var targetX:Float;
	var targetY:Float;

	var originalX:Float;
	var originalY:Float;
	var originalWidth:Float;
	var originalHeight:Float;

	// Variables meant to be changed for different enemies
	var tooCloseDist:Int;
	var attackCD:Int;
	var chargeCD:Int;
	var iframeCD:Int;
	var maxSpeed:Float;
	var aggroRange:Int;

	// immunity frames
	var oldHealth:Float;
	var iframes:Bool = false;
	var iframeCounter:Float = 0;
	var flashTimer:Float = 0;

	var animRate:Int = 8;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(64, 64, FlxColor.GREEN);
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		deathCheck();
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

		if (isCharging || isAttacking) // check to see if target started an attack
		{
			chargeAttack();
		}
		else
		{
			approach(player, maxSpeed);
		}
	}

	/**Determine if player is close enough to enemy to attack**/
	function target(player:FlxSprite)
	{
		if (FlxMath.distanceBetween(player, this) < aggroRange)
		{
			velocity.x = 0;
			velocity.y = 0;
			if (!isAttacking) // Check to make sure an attack isn't going on
			{
				isCharging = true;
			}
		}
	}

	/**Prepare to attack player, only usable if target has located the player. Should always follow target.**/
	function chargeAttack()
	{
		immovable = true;
		if (chargeTimer == 0)
		{
			chargeTimer = Timer.stamp();
		}
		else if (Timer.stamp() - chargeTimer > chargeCD)
		{
			isAttacking = true;
			isCharging = false;
			chargeTimer = 0;
		}
	}

	/**Does the attack. Default is to expand in a direction towards the player and then contract. Overwrite to increase functionality.**/
	function attack(player:FlxSprite)
	{
		chargeTimer = 0;
		if (attackTimer == 0) // Only runs once
		{
			attackTimer = Timer.stamp();
			originalWidth = width;
			originalHeight = height;
			// Calculate where player is relative to enemy and extend hitbox
			if (Math.abs(player.x - x) > Math.abs(player.y - y))
			{
				originalY = y;
				if (player.x > x)
				{
					setGraphicSize(Std.int(this.width * 2), Std.int(this.height)); // Extend hitbox to the right
					originalX = x;
				}
				else
				{
					setGraphicSize(Std.int(this.width * 2), Std.int(this.height)); // Extend hitbox to the left
					originalX = x;
					x -= this.width / 2;
				}
			}
			else
			{
				originalX = x;
				if (player.y > y)
				{
					setGraphicSize(Std.int(this.width), Std.int(this.height * 2)); // Extend hitbox upward
					originalY = y;
				}
				else
				{
					setGraphicSize(Std.int(this.width), Std.int(this.height * 2)); // Extend hitbox downward
					originalY = y;
					y -= this.height / 2;
				}
			}
			updateHitbox();
		}

		if (Timer.stamp() - attackTimer > attackCD) // Retract hitbox after a certain amount of time has passed
		{
			isAttacking = false;
			attackTimer = 0;
			setGraphicSize(Std.int(originalWidth), Std.int(originalHeight));
			x = originalX;
			y = originalY;
			updateHitbox();
		}
	}

	/**Function that damages the first object. Should be called with FlxG.overlap()**/
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
			{
				velocity.x = vel;
				animation.play("right");
			}
			else
			{
				velocity.x = -1 * vel;
				animation.play("left");
			}
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

	/**Determine if the enemy should run away from the player. Not sure if this code works.**/
	function tooClose(player:FlxSprite)
	{
		if (FlxMath.distanceBetween(player, this) < tooCloseDist)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/**Provides i-frames and keeps the enemy alive until it dies. Called in Enemy class definition.**/
	function deathCheck()
	{
		if (health < 0)
		{
			kill();
		}
		else if ((health != oldHealth && !iframes))
		{
			iframes = true;
			oldHealth = health;
		}
		if (iframes)
		{
			immunity();
		}
	}

	/**More i-frame functionality. Called by deathCheck() function.**/
	function immunity()
	{
		health = oldHealth;
		if (iframeCounter == 0)
		{
			iframeCounter = Timer.stamp();
			flashTimer = Timer.stamp();
		}
		if (Timer.stamp() - iframeCounter > iframeCD) // This is how long they're immune
		{
			iframes = false;
			iframeCounter = 0;
			alpha = 1;
		}
		else if (Timer.stamp() - flashTimer > .1)
		{
			flashTimer = Timer.stamp();
			if (alpha == 0.5)
			{
				alpha = 1;
			}
			else
			{
				alpha = 0.5;
			}
		}
	}
}
