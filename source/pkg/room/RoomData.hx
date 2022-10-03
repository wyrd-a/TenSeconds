package pkg.room;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxText;

class RoomData extends FlxSpriteGroup
{
	var powerUp:FlxSprite;
	var roomType:FlxText;

	public var roomLevel:String;
	public var powerUpName:String;

	var randPower:Int;
	var randLevel:Int;

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
		add(powerUp);
	}

	function choosePowerUpGraphic()
	{
		powerUp.animation.add("Sweet", [1]);
		powerUp.animation.add("Savory", [2]);
		powerUp.animation.add("Spicy", [0]);
		powerUp.animation.add("Bitter", [3]);
	}
}
