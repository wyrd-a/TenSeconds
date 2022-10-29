package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.Timer;
import haxe.display.Position;
import pkg.player.Player;

/**
	This is the projectile. Used by enemies with projectile attacks.
**/
class Projectile extends FlxSprite
{
	public var theta:Float; // Used for bat charge attack

	var animRate:Int = 6;
	var targetAngle:Float;
	var projectileSpeed:Int;
	var projectileFrames:Int;
	var speedCheck:Bool;

	public function new(x:Float = 0, y:Float = 0, projGraphic:String, projWidth, projHeight:Int, projSpeed:Int, projFrames:Int, speedKill:Bool)
	{
		super(x, y);
		loadGraphic(projGraphic, true, projWidth, projHeight);
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
		kill();
		projectileSpeed = projSpeed;
		projectileFrames = projFrames;
		speedCheck = speedKill;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (speedCheck)
		{
			velocity.set(velocity.x * 0.99, velocity.y * 0.99);
		}
	}

	/**Fire a projectile at the player when the enemy says to**/
	public function spawnProjectile(player:Player, enemy:Enemy)
	{
		if (enemy.fireProjectile && enemy.alive)
		{
			trace("firin mah lazer");
			animation.add("run", [for (i in(0...projectileFrames)) i], animRate, false, false, false);
			animation.play("run");
			this.reset(enemy.x + 10, enemy.y + 10);
			targetAngle = FlxAngle.angleBetween(this, player);
			velocity.set(projectileSpeed * Math.cos(targetAngle), projectileSpeed * Math.sin(targetAngle));
		}
		killProjectile(player);
	}

	/**Check if the projectile should despawn**/
	function killProjectile(player:Player)
	{
		if (FlxG.overlap(player, this))
		{
			player.takeDamage();
			this.kill();
		}
		if (animation.finished && projectileFrames > 1) // Make sure it actually has an animation
		{
			this.kill();
		}
	}
}
