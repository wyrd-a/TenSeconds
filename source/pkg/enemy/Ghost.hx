package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Timer;

/**
	This is the Ghost. It uses an AOE attack when it gets close.
**/
class Ghost extends Enemy
{
	public function new(x:Float = 0, y:Float = 0)
	{
		// Ghost specific stuff
		attackCD = 1;
		chargeCD = 1;
		health = 20;

		super(x, y);
		loadGraphic(AssetPaths.Ghost__png, true, 18, 39);
		createAnimations();
		animation.play("right");
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	override function attack(player:FlxSprite)
	{
		chargeTimer = 0;
		if (attackTimer == 0)
		{
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

		if (Timer.stamp() - attackTimer > attackCD) // keep hitbox active for 2 seconds
		{
			isAttacking = false;
			attackTimer = 0;
			setGraphicSize(18 * 3, 20 * 3);
			x += originalX;
			y += originalY;
			updateHitbox();
		}
	}

	function createAnimations()
	{
		animation.add("right", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], animRate, true, false, false);
		animation.add("left", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], animRate, true, true, false);
	}
}
