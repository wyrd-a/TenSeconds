package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Timer;

/**
	This is the player. Movement functions and stats are handled here.
**/
class Player extends FlxSprite
{
	var up:Bool;
	var down:Bool;
	var left:Bool;
	var right:Bool;
	var VEL:Float = 200;

	// immunity stuff
	var oldHealth:Float;
	var iframes:Bool = false;
	var iframeCounter:Float = 0;
	var flashTimer:Float = 0;

	// Track UI health
	public var currentHealth:Float;
	public var maxHealth:Float = 5;

	// animation stuff
	var animationNumber:Int;
	var animRate:Int = 8;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.player_move__png, true, 24, 24);
		offset.set(0, 6);
		setGraphicSize(72, 72);
		createAnimations();
		health = maxHealth; // sets player's health
		oldHealth = health; // for tracking i-frames
		currentHealth = health;
	}

	override public function update(elapsed:Float):Void
	{
		move();
		boundToBorder();
		super.update(elapsed);
		deathCheck();
	}

	function move()
	{
		// Grab movement keys
		up = FlxG.keys.pressed.W || FlxG.keys.pressed.UP;
		down = FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN;
		left = FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT;
		right = FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT;

		// Up/Down speed
		if ((up && down) || !up && !down)
		{
			velocity.y = 0;
		}
		else if (down)
		{
			velocity.y = VEL;
			animationNumber = 5;
		}
		else if (up)
		{
			velocity.y = -1 * VEL;
			animationNumber = 1;
		}

		// Left/Right speed
		if ((left && right) || !left && !right)
			velocity.x = 0;
		else if (right)
		{
			velocity.x = VEL;
			animationNumber = 3;
		}
		else if (left)
		{
			velocity.x = -1 * VEL;
			animationNumber = 7;
		}

		// Diagnol speed control
		if (up && right)
		{
			velocity.scale(0.707);
			animationNumber = 2;
		}
		else if (up && left)
		{
			velocity.scale(0.707);
			animationNumber = 6;
		}
		else if (down && right)
		{
			velocity.scale(0.707);
			animationNumber = 4;
		}
		else if (down && left)
		{
			velocity.scale(0.707);
			animationNumber = 8;
		}
		if ((velocity.x != 0) || (velocity.y != 0))
		{
			playAnimation(animationNumber);
		}
		else
		{
			playIdleAnimation(animationNumber);
		}
	}

	function boundToBorder() // replace with
	{
		if (x > FlxG.width)
		{
			x = -1 * width + 1;
		}
		else if (x < -1 * width)
		{
			x = FlxG.width - 1;
		}

		if (y > FlxG.height)
		{
			y = -1 * height + 1;
		}
		else if (y < -1 * height)
		{
			y = FlxG.height - 1;
		}
	}

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

	function immunity()
	{
		health = oldHealth;
		currentHealth = health;
		if (iframeCounter == 0)
		{
			iframeCounter = Timer.stamp();
			flashTimer = Timer.stamp();
		}
		if (Timer.stamp() - iframeCounter > 2)
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

	function createAnimations()
	{
		// walk animations (comments to the right are the corresponding animationNumber)
		// We use animationNumber because it makes it easier to only call one animation.play()
		animation.add("up", [for (i in(5...9)) i], animRate, false, false, false); // 1
		animation.add("upright", [for (i in(10...14)) i], animRate, false, false, false); // 2
		animation.add("right", [for (i in(15...19)) i], animRate, false, false, false); // 3
		animation.add("downright", [for (i in(20...24)) i], animRate, false, false, false); // 4
		animation.add("down", [for (i in(25...29)) i], animRate, false, false, false); // 5
		animation.add("upleft", [for (i in(10...14)) i], animRate, false, true, false); // 6
		animation.add("left", [for (i in(15...19)) i], animRate, false, true, false); // 7
		animation.add("downleft", [for (i in(20...24)) i], animRate, false, true, false); // 8

		// idle animations
		animation.add("Uidle", [4], animRate, false, false, false); // 1
		animation.add("URidle", [3], animRate, false, false, false); // 2
		animation.add("Ridle", [2], animRate, false, false, false); // 3
		animation.add("DRidle", [1], animRate, false, false, false); // 4
		animation.add("Didle", [0], animRate, false, false, false); // 5
		animation.add("ULidle", [3], animRate, false, true, false); // 6
		animation.add("Lidle", [2], animRate, false, true, false); // 7
		animation.add("DLidle", [1], animRate, false, true, false); // 8
	}

	function playAnimation(aNum:Int)
	{
		switch aNum
		{
			case 1:
				animation.play("up");
			case 2:
				animation.play("upright");
			case 3:
				animation.play("right");
			case 4:
				animation.play("downright");
			case 5:
				animation.play("down");
			case 6:
				animation.play("upleft");
			case 7:
				animation.play("left");
			case 8:
				animation.play("downleft");
		}
	}

	function playIdleAnimation(aNum:Int)
	{
		switch aNum
		{
			case 1:
				animation.play("Uidle");
			case 2:
				animation.play("URidle");
			case 3:
				animation.play("Ridle");
			case 4:
				animation.play("DRidle");
			case 5:
				animation.play("Didle");
			case 6:
				animation.play("ULidle");
			case 7:
				animation.play("Lidle");
			case 8:
				animation.play("DLidle");
		}
	}
}
