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

/**The bomb isn't used in the NG build so idk why its called bomb, but this handles death and the room selection for some reason**/
class Bomb extends FlxSpriteGroup
{
	var bombBody:FlxSprite;
	var bombTimer:Float = 0;
	var bombText:FlxText;

	var roomSelectOverlay:FlxSprite;
	var upRoom:RoomData;
	var downRoom:RoomData;
	var rightRoom:RoomData;
	var leftRoom:RoomData;

	var roomBarriers:FlxSprite;

	var leftBord:FlxSprite;
	var rightBord:FlxSprite;
	var topBord:FlxSprite;
	var bottomBord:FlxSprite;

	var levelBarrierNames:Array<String>;
	var levelBarrierNums:Array<Int>;

	public var startNewRoom:Bool = false;
	public var playerWon:Int = 0;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		bombBody = new FlxSprite(x, y);
		bombBody.loadGraphic(AssetPaths.bomb__png);
		bombBody.scale.set(3, 3);
		// add(bombBody);
		bombText = new FlxText(x + 20, y + 20, 0, "10", 20);
		bombText.color = FlxColor.RED;
		// add(bombText);

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

		levelBarrierNames = [
			AssetPaths.level1_border__png,
			AssetPaths.level2_border__png,
			AssetPaths.level3_border__png,
			AssetPaths.level3_border__png
		];
		levelBarrierNums = [11, 6, 11, 2];

		roomBarriers = new FlxSprite(0, 0);
		roomBarriers.loadGraphic(levelBarrierNames[Config.roomLevel - 1], true, 288, 192);
		roomBarriers.animation.add("1", [for (i in(0...levelBarrierNums[Config.roomLevel - 1])) i], 14, false);
		roomBarriers.animation.play("1");
		add(roomBarriers);
		roomBarriers.scale.set(3, 3);
		roomBarriers.updateHitbox();
		roomBarriers.setPosition(0, 0);

		leftBord = new FlxSprite(0, 0);
		leftBord.makeGraphic(1000, 1000);
		leftBord.setPosition(-910, 0);
		leftBord.alpha = 0.0;
		add(leftBord);
		leftBord.immovable = true;

		rightBord = new FlxSprite(0, 0);
		rightBord.makeGraphic(1000, 1000);
		rightBord.setPosition(860, 0);
		rightBord.alpha = 0.0;
		add(rightBord);
		rightBord.immovable = true;

		topBord = new FlxSprite(0, 0);
		topBord.makeGraphic(1000, 1000);
		topBord.setPosition(0, -900);
		topBord.alpha = 0;
		add(topBord);
		topBord.immovable = true;

		bottomBord = new FlxSprite(0, 0);
		bottomBord.makeGraphic(1000, 1000);
		bottomBord.setPosition(0, 570);
		bottomBord.alpha = 0;
		add(bottomBord);
		bottomBord.immovable = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function countdown(player:FlxSprite, enemy:FlxSprite)
	{
		collideWithBorder(player);
		if (!player.alive)
		{
			playerWon = -1;
			startNewRoom = true;
		}
		if (!enemy.alive && (Config.roomLevel != 4)) // should be !enemy.alive
		{
			if (bombTimer == 0) // Keep this code
			{
				bombTimer = Timer.stamp();
				// x = enemy.x + enemy.origin.x;
				// y = enemy.y + enemy.origin.y;
				bombText.setPosition(FlxG.width / 2, FlxG.height / 2);
				// make room data appear here
				roomSelectOverlay.setPosition(0, 0);
				upRoom.setPosition(550, 122);
				downRoom.setPosition(325, 520);
				rightRoom.setPosition(750, 400);
				leftRoom.setPosition(22 * 3 + 50, 60 * 3 + 50);

				roomBarriers.animation.add("2", [
					for (i in(0...levelBarrierNums[Config.roomLevel - 1]))
						levelBarrierNums[Config.roomLevel - 1] - 1 - i
				], 14, false);
				roomBarriers.animation.play("2");
			}
			boundaryKill();

			// Room selection criteria
			if (player.x > FlxG.width)
			{
				Config.roomLevelName = rightRoom.roomLevelName;
				Config.roomLevel = rightRoom.roomLevelNumber;
				startNewRoom = true;
				trace("right");
				Config.playerHealth = player.health;
			}
			else if (player.y > FlxG.height)
			{
				Config.roomLevelName = downRoom.roomLevelName;
				Config.roomLevel = downRoom.roomLevelNumber;
				startNewRoom = true;
				trace("down");
				Config.playerHealth = player.health;
			}
			else if (player.x < 0)
			{
				Config.roomLevelName = leftRoom.roomLevelName;
				Config.roomLevel = leftRoom.roomLevelNumber;
				startNewRoom = true;
				trace("left");
				Config.playerHealth = player.health;
			}
			else if (player.y < 0)
			{
				Config.roomLevelName = upRoom.roomLevelName;
				Config.roomLevel = upRoom.roomLevelNumber;
				startNewRoom = true;
				trace("up");
				Config.playerHealth = player.health;
			}

			if (Timer.stamp() - bombTimer > 9999) // What happens if the timer runs out
			{
				playerWon = -1;
				player.kill();
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

	function collideWithBorder(player:FlxSprite)
	{
		FlxG.collide(player, leftBord);
		FlxG.collide(player, rightBord);
		FlxG.collide(player, topBord);
		FlxG.collide(player, bottomBord);
	}

	function boundaryKill()
	{
		if (roomBarriers.animation.finished && roomBarriers.alive)
		{
			roomBarriers.kill();
			leftBord.kill();
			rightBord.kill();
			topBord.kill();
			bottomBord.kill();
			trace("killed barriers");
		}
	}
}
