package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import haxe.Timer;

/**
	This is not a saxaphone. What is this?
**/
class Sax extends Enemy
{
	public var theta:Float; // Used for bat charge attack

	var attackSpeed:Float = 250;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		// Bat specific stuff
		tooCloseDist = 0;
		attackCD = 2;
		chargeCD = 2;
		iframeCD = 2;
		maxSpeed = 0;
		aggroRange = 9001;
		health = 2;
		maxHealth = 2;
		name = "Sax?";

		// Projectile variables
		projGraphic = AssetPaths.musicnote__png;
		projWidth = 27;
		projHeight = 30;
		projSpeed = 300;
		projFrames = 1;

		health = maxHealth; // for tracking i-frames

		loadGraphic(AssetPaths.Gramophone__png, true, 32, 43); // Its a gramophone?
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
		fireProjectile = false;

		if (isAttacking)
		{
			attack(player);
		}
	}

	/**The sax(?) has a shooting attack. This overrides the basic Enemy attack.**/
	override function attack(player:FlxSprite)
	{
		immovable = false;
		chargeTimer = 0;
		if (attackTimer == 0) // Only runs once, need in overwritten functions
		{
			animFacing(player);
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
		}
	}

	function createAnimations()
	{
		animation.add("right", [for (i in(0...6)) i], animRate, true, true, false);
		animation.add("left", [for (i in(0...6)) i], animRate, true, false, false);
	}
}
