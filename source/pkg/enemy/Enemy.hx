package pkg.enemy;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import haxe.Timer;
import openfl.utils.IAssetCache;
import pkg.config.Config;
import pkg.enemy.PathFind;
import pkg.player.Player;
import pkg.substates.BattleSubState;

/**
	This is the enemy. AI and damage dealing is handled here.
**/
class Enemy extends FlxSprite
{
	public var isCharging:Bool = false;

	public var fireProjectile:Bool = false;

	var chargeTimer:Float = 0;

	public var isAttacking:Bool = false;

	public var maxHealth:Float = 5;

	public var name:String;

	var attackTimer:Float = 0;

	var targetPos:Array<Int>;
	var pathFinder:PathFind;
	var targX:Int = 0;
	var targY:Int = 0;

	var originalX:Float;
	var originalY:Float;
	var originalWidth:Float;
	var originalHeight:Float;

	// Variables meant to be changed for different enemies
	var tooCloseDist:Int;
	var attackCD:Int;
	var chargeCD:Float;
	var iframeCD:Int;
	var maxSpeed:Float;
	var aggroRange:Int;

	// Projectile variables
	public var projGraphic:String = AssetPaths.bomb__png;
	public var projWidth:Int = 32;
	public var projHeight:Int = 32;
	public var projSpeed:Int = 200;
	public var projFrames:Int = 1;
	public var projDecay:Bool = false;

	// immunity frames
	var oldHealth:Float;

	var hurtSound:FlxSound;

	public var iframes:Bool = false;

	var iframeCounter:Float = 0;
	var flashTimer:Float = 0;

	var animRate:Int = 8;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(64, 64, FlxColor.GREEN);
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();

		pathFinder = new PathFind(0, 0, Std.string(Config.roomLevel) + Std.string(BattleSubState.randLayer));
		trace("Using layout #" + BattleSubState.randLayer);

		hurtSound = FlxG.sound.load(AssetPaths.EnemyHurt2__wav);
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

	/**Function that damages the first object. Should be called through FlxG.overlap()**/
	function playerHurt(objA:Player, objB:FlxSprite):Void
	{
		objA.takeDamage();
	}

	/**Move the enemy towards the player at speed vel.**/
	function approach(player:FlxSprite, vel:Float)
	{
		animFacing(player);

		velocity.set(0, 0);
		targetPos = pathFinder.pathFinding(player, this);
		if (targetPos[0] != null) // put some grid-adherence algorithm in here
		{
			if (targetPos[0] == targetPos[2]) // if start x equals end x
			{
				targY = targetPos[3];
				targX = 0;
				if (targetPos[1] > targetPos[3])
				{
					velocity.y = -1 * vel;
				}
				else
				{
					velocity.y = vel;
				}
				if (targY * 48 + 1 == Std.int(y))
				{
					targY = 0;
				}
			}
			else
			{
				targX = targetPos[2];
				targY = 0;
				if (targetPos[0] > targetPos[2])
				{
					velocity.x = -1 * vel;
				}
				else
				{
					velocity.x = vel;
				}
				if (targX * 48 + 1 == Std.int(x))
				{
					targX = 0;
				}
			}
		}
		/*if (targetPos[0] != null)
			{
				if (Math.abs(targetPos[0] - (x)) > Math.abs(targetPos[1] - (y))) // Is the player further away in x or y
				{
					velocity.y = 0;
					if (targetPos[0] > x) // Move positive or negative x
					{
						velocity.x = vel;
					}
					else
					{
						velocity.x = -1 * vel;
					}
				}
				else
				{
					velocity.x = 0;
					if (targetPos[1] > y) // move positive or negative y
					{
						velocity.y = vel;
					}
					else
					{
						velocity.y = -1 * vel;
					}
				}
		}*/
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
		if (health <= 0)
		{
			this.kill();
		}
		if (iframes)
		{
			immunity();
		}
	}

	public function takeDamage()
	{
		if (!iframes)
		{
			hurtSound.play();
			iframes = true;
			health -= Config.playerDamage;
		}
	}

	/**More i-frame functionality. Called by deathCheck() function.**/
	function immunity()
	{
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

	function animFacing(player:FlxSprite)
	{
		if (player.x + (player.width / 2) > this.x + (this.width / 2))
			animation.play("right");
		else
			animation.play("left");
	}
}
