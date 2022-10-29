package pkg.enemy;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Timer;
import pkg.config.Config;
import pkg.player.Player;
import pkg.room.RoomData;

/**The bomb isn't used in the NG build so idk why its called bomb, but this handles death and the room selection for some reason**/
class Bomb extends FlxSpriteGroup
{
	var bombTimer:Float = 0;

	var roomSelectOverlay:FlxSprite;
	var poof:Array<FlxSprite>;
	var upRoom:RoomData;
	var downRoom:RoomData;
	var rightRoom:RoomData;
	var leftRoom:RoomData;

	var roomBarriers:FlxSprite;

	var unpoofed:Bool = true;

	var leftBord:FlxSprite;
	var rightBord:FlxSprite;
	var topBord:FlxSprite;
	var bottomBord:FlxSprite;

	var levelSign:Array<FlxSprite>;
	var itemSign:Array<FlxSprite>;

	var levelBarrierNames:Array<String>;
	var levelBarrierNums:Array<Int>;

	var enemyTotalHealth:Float = 0;

	public var startNewRoom:Bool = false;
	public var playerWon:Int = 0;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		roomSelectOverlay = new FlxSprite(1000, 1000);
		roomSelectOverlay.loadGraphic(AssetPaths.roomSelectOverlay__png, true, 288, 192);
		roomSelectOverlay.scale.set(3, 3);
		roomSelectOverlay.updateHitbox();
		add(roomSelectOverlay);

		levelSign = new Array<FlxSprite>();
		itemSign = new Array<FlxSprite>();

		// Create sign things
		for (i in 0...4)
		{
			levelSign[i] = new FlxSprite(-200, -200);
			levelSign[i].loadGraphic(AssetPaths.sign_levels__png, true, 10, 8);
			levelSign[i].scale.set(3, 3);
			levelSign[i].updateHitbox();
			add(levelSign[i]);
			itemSign[i] = new FlxSprite(-200, -200);
			itemSign[i].loadGraphic(AssetPaths.sign_items__png, true, 10, 8);
			itemSign[i].scale.set(3, 3);
			itemSign[i].updateHitbox();
			add(itemSign[i]);
		}

		// Create poofs (goes after signs and sign things)
		poof = new Array<FlxSprite>();
		for (i in 0...8)
		{
			poof[i] = new FlxSprite(-100, -100);
			poof[i].loadGraphic(AssetPaths.poof__png, true, 21, 17);
			poof[i].scale.set(3, 3);
			poof[i].updateHitbox();
			add(poof[i]);
		}

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
			AssetPaths.boss_barrier__png
		];
		levelBarrierNums = [11, 6, 11, 23];

		roomBarriers = new FlxSprite(0, 0);
		roomBarriers.loadGraphic(levelBarrierNames[Config.roomLevel - 1], true, 288, 192);
		roomBarriers.animation.add("doors", [for (i in(0...levelBarrierNums[Config.roomLevel - 1])) i], 14, false);
		roomBarriers.animation.play("doors");
		add(roomBarriers);
		roomBarriers.scale.set(3, 3);
		roomBarriers.updateHitbox();
		roomBarriers.setPosition(0, 0);

		leftBord = new FlxSprite(0, 0);
		leftBord.makeGraphic(1000, 1000);
		leftBord.setPosition(-904, 0);
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

	public function countdown(player:FlxSprite, enemy:Array<Dynamic>)
	{
		enemyTotalHealth = 0;
		for (i in 0...enemy.length)
		{
			if (enemy[i].health > 0) // I think this fixes a bug with damage overflow
			{
				enemyTotalHealth += enemy[i].health;
			}
			collideWithBorder(player, enemy[i]);
		}

		if (!player.alive)
		{
			playerWon = -1;
			startNewRoom = true;
			resetPlayer();
		}
		if ((enemyTotalHealth <= 0) && (Config.roomLevel != 4)) // should be !enemy.alive
		{
			if (bombTimer == 0) // Keep this code
			{
				bombTimer = Timer.stamp();

				roomSelectOverlay.setPosition(0, 0);
				roomSelectOverlay.animation.add("sproing", [for (i in 0...8) i], 6, false);
				roomSelectOverlay.animation.play("sproing");
				upRoom.setPosition(550, 122);
				downRoom.setPosition(325, 520);
				rightRoom.setPosition(750, 400);
				leftRoom.setPosition(22 * 3 + 50, 60 * 3 + 50);

				roomBarriers.animation.add("unlock", [
					for (i in(0...levelBarrierNums[Config.roomLevel - 1]))
						levelBarrierNums[Config.roomLevel - 1] - 1 - i
				], 14, false);
				roomBarriers.animation.play("unlock");
			}
			if (roomSelectOverlay.animation.finished && unpoofed)
			{
				unpoofed = false;
				for (i in 0...8)
				{
					poof[i].animation.add("smoke", [0, 1, 2, 3, 4, 5, 6], 12, false);
					poof[i].animation.play("smoke");
				}
				setSign(upRoom, 0);
				levelSign[0].setPosition(320, 30);
				itemSign[0].setPosition(514, 30);

				setSign(downRoom, 1);
				levelSign[1].setPosition(320, 519);
				itemSign[1].setPosition(514, 519);

				setSign(leftRoom, 2);
				levelSign[2].setPosition(44, 183);
				itemSign[2].setPosition(44, 353);

				setSign(rightRoom, 3);
				levelSign[3].setPosition(787, 183);
				itemSign[3].setPosition(787, 353);

				poof[0].setPosition(306, 20);
				poof[1].setPosition(500, 20);
				poof[2].setPosition(30, 170);
				poof[3].setPosition(30, 340);
				poof[4].setPosition(306, 500);
				poof[5].setPosition(500, 500);
				poof[6].setPosition(770, 170);
				poof[7].setPosition(770, 340);
			}

			boundaryKill();

			// Room selection criteria
			if (player.x > FlxG.width)
			{
				updateConfig(rightRoom, player);
				trace("right");
				Config.roomDirection = "right";
			}
			else if (player.y > FlxG.height)
			{
				updateConfig(downRoom, player);
				trace("down");
				Config.roomDirection = "down";
			}
			else if (player.x < 0)
			{
				updateConfig(leftRoom, player);
				trace("left");
				Config.roomDirection = "left";
			}
			else if (player.y < 0)
			{
				updateConfig(upRoom, player);
				trace("up");
				Config.roomDirection = "up";
			}

			if (Timer.stamp() - bombTimer > 9999) // What happens if the timer runs out
			{
				playerWon = -1;
				player.kill();
				startNewRoom = true;
			}
		}
		else if ((enemyTotalHealth <= 0) && (Config.roomLevel == 4))
		{
			playerWon = 1;
			startNewRoom = true;
			resetPlayer();
		}
	}

	function collideWithBorder(player:FlxSprite, enemy:FlxSprite)
	{
		FlxG.collide(player, leftBord);
		FlxG.collide(player, rightBord);
		FlxG.collide(player, topBord);
		FlxG.collide(player, bottomBord);
		FlxG.collide(enemy, leftBord);
		FlxG.collide(enemy, rightBord);
		FlxG.collide(enemy, topBord);
		FlxG.collide(enemy, bottomBord);
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

	function scaleRoom(levelNum)
	{
		// this should handle room difficulty/ease of finding next level
		if (Config.roomLevel == levelNum)
		{
			Config.difficulty += 0.2;
		}
		else
		{
			Config.difficulty = 0.4;
		}
	}

	function updateConfig(room:RoomData, player:FlxSprite)
	{
		scaleRoom(room.roomLevelNumber);
		Config.roomLevelName = room.roomLevelName;
		Config.roomLevel = room.roomLevelNumber;
		startNewRoom = true;
		Config.playerHealth = player.health;
		Config.roomFlavor = room.powerUpName;
	}

	function resetPlayer()
	{
		Config.playerDamage = 1;
		Config.playerHealth = 5;
		Config.playerMax = 5;
	}

	function setSign(room:RoomData, i:Int)
	{
		levelSign[i].animation.add("1", [0], 1, false);
		levelSign[i].animation.add("2", [1], 1, false);
		levelSign[i].animation.add("3", [2], 1, false);
		levelSign[i].animation.add("4", [3], 1, false);

		itemSign[i].animation.add("strong", [0], 1, false);
		itemSign[i].animation.add("health", [1], 1, false);
		itemSign[i].animation.add("lifeup", [2], 1, false);
		itemSign[i].animation.add("bitter", [3], 1, false);
		itemSign[i].animation.add("boss", [4], 1, false);

		levelSign[i].animation.play(Std.string(room.roomLevelNumber));
		itemSign[i].animation.play(room.powerUpName);
	}
}
