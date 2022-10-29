package pkg.enemy;

import AssetPaths;
import flixel.FlxSprite;
import haxe.Timer;

/**
	This is the Bat. It uses an AOE attack when it gets close.
**/
class Turret extends Enemy
{
	var attackSpeed:Float = 150;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Turret specific stuff
		tooCloseDist = 0;
		attackCD = 1;
		chargeCD = 1;
		iframeCD = 2;
		maxSpeed = 0;
		aggroRange = 9001;
		health = 2;
		maxHealth = 2;
		name = "Turret";

		// Projectile variables
		projGraphic = AssetPaths.gear2__png;
		projWidth = 14;
		projHeight = 14;
		projSpeed = 500;
		projFrames = 9;

		oldHealth = health; // for tracking i-frames

		loadGraphic(AssetPaths.Turret__png, true, 23, 50);
		createAnimations();
		animation.play("right");
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**Parses the player information through upper level before reaching Enemy. Allows for attack to be overwritten on an individual basis.**/
	public function aiWorkings(player:FlxSprite)
	{
		this.trackPlayer(player);
		fireProjectile = false; // Needed for projectile enemies
		if (isAttacking)
		{
			attack(player);
		}
	}

	/**The turret has a shooting attack. This overrides the basic Enemy attack.**/
	override function attack(player:FlxSprite)
	{
		immovable = false;
		chargeTimer = 0;
		if (attackTimer == 0) // Only runs once, need in overwritten functions
		{
			animation.play("open");
			attackTimer = Timer.stamp();
			// Change hitbox here
		}
		// Longterm effects happen here

		if (Timer.stamp() - attackTimer > attackCD) // Retract hitbox after a certain amount of time has passed
		{
			isAttacking = false;
			attackTimer = 0;
			// Restore sprite to initial configuration here
			velocity.set(0, 0);
			fireProjectile = true;
			animation.play("close");
		}
	}

	function createAnimations()
	{
		animation.add("right", [for (i in(0...1)) i], animRate, true, true, false);
		animation.add("left", [for (i in(0...1)) i], animRate, true, false, false);
		animation.add("open", [for (i in(1...6)) i], animRate, false, true, false);
		animation.add("close", [5, 6, 7, 0], animRate, false, true, false);
	}
}
