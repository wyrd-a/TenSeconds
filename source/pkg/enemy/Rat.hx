package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import haxe.Timer;

/**
	This is the Rat. It uses a charge attack when it gets close.
**/
class Rat extends Enemy
{
	public var theta:Float; // Used for rat charge attack

	var attackSpeed:Float = 300;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Rat specific stuff
		tooCloseDist = 0;
		attackCD = 2;
		chargeCD = 2;
		iframeCD = 2;
		maxSpeed = 80;
		aggroRange = 100;
		health = 5;

		oldHealth = health; // for tracking i-frames

		loadGraphic(AssetPaths.rat__png, true, 37, 28);
		createAnimations();
		animation.play("right");
		setGraphicSize(Std.int(3 * width), 0);
		updateHitbox();
		width = 90;
		height = 80;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**Parses the player information through upper level before reaching Enemy. Allows for attack to be overwritten on an individual basis.**/
	public function aiWorkings(player:FlxSprite)
	{
		this.trackPlayer(player);
		if (isAttacking)
		{
			attack(player);
		}
	}

	/**The bat has a unique charge attack. This overrides the basic Enemy attack.**/
	override function attack(player:FlxSprite)
	{
		immovable = false;
		chargeTimer = 0;
		if (attackTimer == 0) // Only runs once, need in overwritten functions
		{
			animFacing(player);
			attackTimer = Timer.stamp();
			// Change hitbox here
			theta = FlxAngle.angleBetween(this, player);
		}
		// Longterm effects happen here
		velocity.set(attackSpeed * Math.cos(theta), attackSpeed * Math.sin(theta));

		if (Timer.stamp() - attackTimer > attackCD) // Retract hitbox after a certain amount of time has passed
		{
			isAttacking = false;
			attackTimer = 0;
			// Restore sprite to initial configuration here
			velocity.set(0, 0);
		}
	}

	function createAnimations()
	{
		animation.add("right", [for (i in(0...23)) i], animRate, true, true, false);
		animation.add("left", [for (i in(0...23)) i], animRate, true, false, false);
	}
}
