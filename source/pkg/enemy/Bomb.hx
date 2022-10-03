package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.text.FlxText;
import haxe.Timer;
import pkg.room.RoomData;

/**This is the bomb that drops upon enemy death and the room selection for some reason**/
class Bomb extends FlxSpriteGroup
{
	var bombBody:FlxSprite;
	var bombTimer:Float = 0;
	var bombText:FlxText;

	var upRoom:RoomData;
	var downRoom:RoomData;
	var rightRoom:RoomData;
	var leftRoom:RoomData;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		bombBody = new FlxSprite(x, y);
		bombBody.loadGraphic(AssetPaths.Player__png);
		add(bombBody);
		bombText = new FlxText(x + 20, y + 20);
		add(bombText);

		upRoom = new RoomData(-50, -50);
		add(upRoom);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function countdown(player:FlxSprite, enemy:FlxSprite)
	{
		if (!enemy.alive)
		{
			if (bombTimer == 0)
			{
				bombTimer = Timer.stamp();
				x = enemy.x;
				y = enemy.y;
				// make room data appear here
				upRoom.setPosition(FlxG.width / 2, 10);
			}

			// Room selection criteria
			if (player.x > FlxG.width) {}
			else if (player.y > FlxG.height) {}
			else if (player.x < 0) {}
			else if (player.y < 0) {}

			if (Timer.stamp() - bombTimer > 10)
			{
				player.kill();
			}
			else
			{
				bombText.text = Std.string(Math.floor(10 - Timer.stamp() + bombTimer));
			}
		}
	}
}
