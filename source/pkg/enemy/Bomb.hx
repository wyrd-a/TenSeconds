package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Timer;
import pkg.config.Config;
import pkg.room.RoomData;

/**This is the bomb that drops upon enemy death and the room selection for some reason**/
class Bomb extends FlxSpriteGroup
{
	var bombBody:FlxSprite;
	var bombTimer:Float = 0;
	var bombText:FlxText;

	var bombSFX:FlxSound;
	var bellSFX:FlxSound;

	var roomSelectOverlay:FlxSprite;
	var upRoom:RoomData;
	var downRoom:RoomData;
	var rightRoom:RoomData;
	var leftRoom:RoomData;

	public var startNewRoom:Bool = false;
	public var playerWon:Int = 0;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		bombBody = new FlxSprite(x, y);
		bombBody.loadGraphic(AssetPaths.bomb__png);
		bombBody.scale.set(3, 3);
		add(bombBody);
		bombText = new FlxText(x + 20, y + 20, 0, "10", 20);
		bombText.color = FlxColor.RED;
		add(bombText);

		roomSelectOverlay = new FlxSprite(1000, 1000).loadGraphic(AssetPaths.roomSelectOverlay__png);
		roomSelectOverlay.scale.set(3, 3);
		roomSelectOverlay.updateHitbox();
		add(roomSelectOverlay);

		upRoom = new RoomData(x, y);
		add(upRoom);
		downRoom = new RoomData(x, y);
		add(downRoom);
		rightRoom = new RoomData(x, y);
		add(rightRoom);
		leftRoom = new RoomData(x, y);
		add(leftRoom);

		bombSFX = FlxG.sound.load(AssetPaths.BombSFX__mp3, 1);
		bellSFX = FlxG.sound.load(AssetPaths.Bell__wav, 1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function countdown(player:FlxSprite, enemy:FlxSprite)
	{
		if (!player.alive)
		{
			playerWon = -1;
			startNewRoom = true;
		}
		if (!enemy.alive && (Config.roomLevel != 4)) // should be !enemy.alive
		{
			if (bombTimer == 0)
			{
				bombTimer = Timer.stamp();
				x = enemy.x + enemy.origin.x;
				y = enemy.y + enemy.origin.y;
				bombText.setPosition(FlxG.width / 2, FlxG.height / 2);
				// make room data appear here
				roomSelectOverlay.setPosition(0, 0);
				upRoom.setPosition(550, 122);
				downRoom.setPosition(325, 520);
				rightRoom.setPosition(750, 400);
				leftRoom.setPosition(22 * 3 + 50, 60 * 3 + 50);
				bombSFX.play(true);
			}

			// Room selection criteria
			if (player.x > FlxG.width)
			{
				Config.roomLevelName = rightRoom.roomLevelName;
				Config.roomLevel = rightRoom.roomLevelNumber;
				startNewRoom = true;
				trace("right");
			}
			else if (player.y > FlxG.height)
			{
				Config.roomLevelName = downRoom.roomLevelName;
				Config.roomLevel = downRoom.roomLevelNumber;
				startNewRoom = true;
				trace("down");
			}
			else if (player.x < 0)
			{
				Config.roomLevelName = leftRoom.roomLevelName;
				Config.roomLevel = leftRoom.roomLevelNumber;
				startNewRoom = true;
				trace("left");
			}
			else if (player.y < 0)
			{
				Config.roomLevelName = upRoom.roomLevelName;
				Config.roomLevel = upRoom.roomLevelNumber;
				startNewRoom = true;
				trace("up");
			}

			if (Timer.stamp() - bombTimer > 10) // What happens if the timer runs out
			{
				playerWon = -1;
				player.kill();
				bombSFX.play(false);
				bellSFX.play(true);
				startNewRoom = true;
			}
			else
			{
				bombText.text = Std.string(Math.floor(10 - Timer.stamp() + bombTimer));
			}
		}
		else if (!enemy.alive && (Config.roomLevel == 4))
		{
			playerWon = 1;
			startNewRoom = true;
		}
	}
}
