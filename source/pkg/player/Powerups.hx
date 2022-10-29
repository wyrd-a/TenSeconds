package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import pkg.config.Config;
import pkg.enemy.Enemy;

class Powerups extends FlxSprite
{
	var grabSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.items__png, true, 9, 14);
		setGraphicSize(27, 0);
		updateHitbox();
		createAnimations();
		if ((Config.roomFlavor != "bitter") && Config.roomLevel != 4)
		{
			animation.play(Config.roomFlavor);
		}
		else
		{
			kill();
			x = -1000;
			y = -1000;
		}
		grabSound = FlxG.sound.load(AssetPaths.pickup__wav);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function createAnimations()
	{
		animation.add("strong", [0]);
		animation.add("health", [1]);
		animation.add("lifeup", [2]);
	}

	public function pickUp(objA:FlxSprite, objB:FlxSprite)
	{
		grabSound.play(true);
		switch (Config.roomFlavor)
		{
			case "strong":
				Config.playerDamage += 1;
			case "health":
				{
					Config.playerHealth += Config.playerMax;
				}
			case "lifeup":
				Config.playerMax += 1;
		}
		kill();
	}
}
