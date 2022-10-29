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
	var advancingDifficulty:Float = 0.5; // How hard it is to change rooms

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		randPower = Math.floor(4 * Math.random());
		switch (randPower)
		{
			case 0:
				powerUpName = "strong";
			case 1:
				powerUpName = "health";
			case 2:
				powerUpName = "lifeup";
			case 3:
				powerUpName = "bitter";
		}

		roomType = new FlxText(x, y);
		roomType.color = FlxColor.BLACK;
		switch (Config.roomLevel)
		{
			case 1: // if current room is level 1
				if (Math.random() < Config.difficulty)
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
				if (Math.random() < Config.difficulty)
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
					if (Math.random() < Config.difficulty)
					{
						roomLevelName = AssetPaths.boss_room__png;
						roomLevelNumber = 4;
						roomType.text = "Difficulty: BOSS";
						powerUpName = "boss";
					}
					else
					{
						roomLevelName = AssetPaths.level3__png;
						roomLevelNumber = 3;
						roomType.text = "Difficulty: Hard";
					}
				}
		}
		// add(roomType);
	}
}
