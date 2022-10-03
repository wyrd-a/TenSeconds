package pkg.room;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import pkg.config.Config;

class RoomData extends FlxSpriteGroup
{
	var powerUp:FlxSprite;
	var roomType:FlxText;

	public var roomLevelName:String;
	public var roomLevelNumber:Int;

	public var powerUpName:String;

	var powerUpText:FlxText;

	var randPower:Int;
	var randLevel:Int;
	var advancingDifficulty:Float = 0.7;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		randPower = Math.floor(3 * Math.random());
		switch (randPower)
		{
			case 1:
				powerUpName = "Sweet";
			case 2:
				powerUpName = "Savory";
			case 3:
				powerUpName = "Spicy";
			case 4:
				powerUpName = "Bitter";
		}
		powerUp = new FlxSprite(x, y);
		powerUp.loadGraphic(AssetPaths.items__png, true, 27, 14);
		choosePowerUpGraphic();
		powerUp.animation.play(powerUpName);
		// add(powerUp);

		powerUpText = new FlxText(x, y + 16, 0, "Flavor");
		powerUpText.color = FlxColor.BLACK;
		powerUpText.text = "Flavor: " + powerUpName;
		// add(powerUpText);

		roomType = new FlxText(x, y);
		roomType.color = FlxColor.BLACK;
		switch (Config.roomLevel)
		{
			case 1: // if current room is level 1
				if (Math.random() > advancingDifficulty)
				{
					roomLevelName = AssetPaths.level2__png;
					roomLevelNumber = 2;
					roomType.text = "Difficulty: Medium";
				}
				else
				{
					roomLevelName = AssetPaths.level1__png;
					roomLevelNumber = 1;
					roomType.text = "Difficulty: Easy";
				}
			case 2:
				if (Math.random() > advancingDifficulty)
				{
					roomLevelName = AssetPaths.level3__png;
					roomLevelNumber = 3;
					roomType.text = "Difficulty: Hard";
				}
				else
				{
					roomLevelName = AssetPaths.level2__png;
					roomLevelNumber = 2;
					roomType.text = "Difficulty: Medium";
				}
			case 3:
				{
					if (Math.random() > advancingDifficulty)
					{
						roomLevelName = AssetPaths.boss_room__png;
						roomLevelNumber = 4;
						roomType.text = "Difficulty: BOSS";
					}
					else
					{
						roomLevelName = AssetPaths.level3__png;
						roomLevelNumber = 3;
						roomType.text = "Difficulty: Hard";
					}
				}
		}
		add(roomType);
	}

	function choosePowerUpGraphic()
	{
		powerUp.animation.add("Sweet", [1]);
		powerUp.animation.add("Savory", [2]);
		powerUp.animation.add("Spicy", [0]);
		powerUp.animation.add("Bitter", [3]);
	}
}
