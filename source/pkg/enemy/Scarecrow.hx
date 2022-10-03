package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import haxe.Timer;

/**
	This is the Scarecrow. It spins.
**/
class Scarecrow extends Enemy
{
	public var theta:Float; // Used for bat charge attack

	var attackSpeed:Float = 100;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Scarecrow specific stuff
		tooCloseDist = 0;
		attackCD = 3;
		chargeCD = 1;
		iframeCD = 1;
		maxSpeed = 80;
		health = 3;
		aggroRange = 100;
		animRate = 25;

		oldHealth = health; // for tracking i-frames

		loadGraphic(AssetPaths.Scarecrow__png, true, 38, 49);
		createAnimations();
		animation.play("right");
		setGraphicSize(Std.int(3 * width), 0);
		hitBoxBounding();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**Parses the player information through upper level before reaching Enemy. Allows for attack to be overwritten on an individual basis.**/
	public function aiWorkings(player:FlxSprite)
	{
		this.trackPlayer(player);
		if (isCharging)
		{
			animation.play("charging");
		}
		if (isAttacking)
		{
			attack(player);
		}
	}

	/**The scarecrow spins and follows the player. This overrides the basic Enemy attack.**/
	override function attack(player:FlxSprite)
	{
		chargeTimer = 0;
		if (attackTimer == 0) // Only runs once, need in overwritten functions
		{
			attackTimer = Timer.stamp();
			loadGraphic(AssetPaths.ScarecrowAttack__png, true, 36, 41);
			animation.add("attack", [0, 1]);
			// Change hitbox here
			hitBoxBounding();
		}
		// Length of attack functions here
		theta = FlxAngle.angleBetween(this, player);
		velocity.set(attackSpeed * Math.cos(theta), attackSpeed * Math.sin(theta));
		animation.play("attack");
		if (Timer.stamp() - attackTimer > attackCD) // Retract hitbox after a certain amount of time has passed
		{
			isAttacking = false;
			attackTimer = 0;
			loadGraphic(AssetPaths.Scarecrow__png, true, 38, 49);
			createAnimations();
			animation.play("right");
			hitBoxBounding();
		}
	}

	function createAnimations()
	{
		animation.add("right", [for (i in(0...18)) i], animRate, true, false, false);
		animation.add("left", [for (i in(0...18)) i], animRate, true, true, false);
		animation.add("charging", [1]);
	}

	function hitBoxBounding()
	{
		updateHitbox();
		this.height = 38;
		this.offset.set(20, -1 * this.origin.y);
	}
}
