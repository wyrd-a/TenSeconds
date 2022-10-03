package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import haxe.Timer;

/**
	This is the Ghost. It uses an AOE attack when it gets close.
**/
class Ghost extends Enemy
{
	var originalCenter:FlxPoint;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Ghost specific stuff
		tooCloseDist = 0;
		attackCD = 1;
		chargeCD = 0.5;
		iframeCD = 2;
		maxSpeed = 120;
		health = 6;
		aggroRange = 75;
		maxHealth = 6;
		name = "Ghost";

		oldHealth = health; // for tracking i-frames

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

	/**Parses the player information through upper level before reaching Enemy. Allows for attack to be overwritten on an individual basis.**/
	public function aiWorkings(player:FlxSprite)
	{
		this.trackPlayer(player);
		if (isAttacking)
		{
			attack(player);
		}
	}

	/**The ghost gets bigger. This overrides the basic Enemy attack.**/
	override function attack(player:FlxSprite)
	{
		immovable = false;
		chargeTimer = 0;
		if (attackTimer == 0) // Only runs once, need in overwritten functions
		{
			attackTimer = Timer.stamp();
			// Change hitbox here
			originalCenter = this.origin;
			this.scale.set(6, 6);
			this.updateHitbox();
			this.x -= origin.x * 3;
			this.y -= origin.y * 3;
		}
		// Length of attack functions here
		velocity.set(0, 0);
		if (Timer.stamp() - attackTimer > attackCD) // Retract hitbox after a certain amount of time has passed
		{
			isAttacking = false;
			attackTimer = 0;
			this.x += origin.x * 3;
			this.y += origin.y * 3;
			this.scale.set(3, 3);
			this.updateHitbox();
		}
	}

	function createAnimations()
	{
		animation.add("right", [for (i in(0...12)) i], animRate, true, false, false);
		animation.add("left", [for (i in(0...12)) i], animRate, true, true, false);
	}
}
