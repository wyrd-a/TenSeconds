package pkg.substates;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.macro.Type.AbstractType;
import openfl.events.SampleDataEvent;
import pkg.config.Config;
import pkg.enemy.Bat;
import pkg.enemy.Bomb;
import pkg.enemy.Boss;
import pkg.enemy.Ghost;
import pkg.enemy.Gobbin;
import pkg.enemy.Projectile;
import pkg.enemy.Pumpkin;
import pkg.enemy.Rat;
import pkg.enemy.Sax;
import pkg.enemy.Scarecrow;
import pkg.enemy.Turret;
import pkg.player.Player;
import pkg.player.Powerups;
import pkg.player.UI;
import pkg.player.Weapon;
import pkg.player.WeaponGroup;
import pkg.room.AssetCollider;
import pkg.room.Obstacle;
import pkg.room.Room;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	public var isPersistent:Bool = false;

	public var startNewRoom:Bool = false;
	public var playerWon:Int = 0;

	var player:Player;
	var weapon:WeaponGroup;
	var room:Room;
	var ui:UI;
	var bomb:Bomb;

	// I'm sorry, wyrd-a
	var ghost:Ghost;
	var bat:Bat;
	var scarecrow:Scarecrow;
	var rat:Rat;
	var boss:Boss;
	var turret:Turret;
	var pumpkin:Pumpkin;
	var gobbin:Gobbin;
	var sax:Sax;
	var enemyArray:Array<Dynamic>;
	var enemyNum:Int;
	var enemy:Array<Dynamic>;
	var obstacleSortGroup:FlxSpriteGroup;
	var noEnemy:Int = 1;

	var projectile:Array<Projectile>;

	var assetCollision:AssetCollider;
	var subAssetLayer:FlxSprite;
	var overAssetLayer:FlxSprite;

	public static var randLayer:Int;

	var subLayerName:String;
	var overLayerName:String;
	var layerCollisionName:String;

	var itemPower:Powerups;

	var fadeToBlack:FlxSprite;

	override public function create()
	{
		// this.player = new Player(500, 500);
		this.room = new Room(Config.roomLevelName);

		add(this.room);

		if (Config.roomLevel == 4)
		{
			randLayer = 1;
		}
		else
		{
			randLayer = Math.ceil(5 * Math.random());
		}
		subLayerName = "assets/images/levels/area" + Config.roomLevel + "_bottom_" + randLayer + ".png";
		subAssetLayer = new FlxSprite(0, 0).loadGraphic(subLayerName);
		subAssetLayer.scale.set(3, 3);
		subAssetLayer.updateHitbox();
		subAssetLayer.setPosition(0, 0);
		add(subAssetLayer);

		enemyCreation(); // Needs to go before projectile
		projectile = new Array<Projectile>();
		for (i in 0...noEnemy)
			this.projectile[i] = new Projectile(0, 0, enemy[i].projGraphic, enemy[i].projWidth, enemy[i].projHeight, enemy[i].projSpeed, enemy[i].projFrames,
				enemy[i].projDecay);

		// Things with logic tied to them
		this.player = new Player(75, 265);

		itemPower = new Powerups(FlxG.width / 2, FlxG.height / 2);
		add(itemPower);

		// Adds player and enemy
		// this.room.createRoomObstacles([this.player, this.enemy]);
		add(player);
		positionPlayer(player);
		for (i in 0...noEnemy)
		{
			add(enemy[i]);
		}

		overLayerName = "assets/images/levels/area" + Config.roomLevel + "_top_" + randLayer + ".png";
		overAssetLayer = new FlxSprite(0, 0).loadGraphic(overLayerName);
		overAssetLayer.scale.set(3, 3);
		overAssetLayer.updateHitbox();
		overAssetLayer.setPosition(0, 0);
		add(overAssetLayer);
		for (i in 0...noEnemy)
			add(projectile[i]);
		if (Config.roomLevel == 4)
		{
			overAssetLayer.kill();
			subAssetLayer.kill();
		}

		this.weapon = new WeaponGroup();
		add(this.weapon);

		bomb = new Bomb(-50, -50);
		add(bomb);

		layerCollisionName = Std.string(Config.roomLevel) + Std.string(randLayer);
		assetCollision = new AssetCollider(0, 0, layerCollisionName);
		add(assetCollision);

		this.ui = new UI(0, 0);
		add(this.ui);

		fadeToBlack = new FlxSprite(0, 0);
		fadeToBlack.makeGraphic(1000, 1000, FlxColor.BLACK);
		// fadeToBlack.alpha = 0;
		add(fadeToBlack);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (!bomb.startNewRoom)
		{
			// fade in
			if (fadeToBlack.alpha > 0)
			{
				fadeToBlack.alpha -= 0.05;
			}

			// other stuff
			super.update(elapsed);
			this.checkHitboxes();
			bomb.countdown(player, enemy);
			for (i in 0...noEnemy)
			{
				this.enemy[i].aiWorkings(this.player);
				this.ui.updateUI(player, enemy[i]);
				this.weapon.positioning(this.player, this.enemy[i]);
				this.projectile[i].spawnProjectile(player, enemy[i]);
			}
			swapLevel();
		}
		else
		{
			fadeToBlack.alpha += 0.05;
			if (fadeToBlack.alpha > 0.9)
			{
				startNewRoom = true;
				if (bomb.playerWon == -1)
					playerWon = -1;
				else if (bomb.playerWon == 1)
					playerWon = 1;
			}
		}
	}

	public function checkHitboxes()
	{
		for (i in 0...noEnemy)
		{
			this.room.checkWallHitboxes([this.player, this.enemy[i]]);
			FlxG.collide(enemy[i], assetCollision);
		}

		// this.room.checkObstacles();
		FlxG.collide(player, assetCollision);
		if (FlxG.overlap(player, itemPower))
		{
			itemPower.pickUp(player, itemPower);
		}
	}

	/**Initiates a bunch of enemies and then chooses one to add to the game. Probably inefficient but its 2:27 am**/
	function enemyCreation()
	{
		enemy = new Array<Dynamic>();
		for (i in 0...noEnemy)
		{
			enemyArray = new Array<Dynamic>();
			bat = new Bat(-500, -500);
			ghost = new Ghost(-500, -500);
			scarecrow = new Scarecrow(-500, -500);
			rat = new Rat(-500, -500);
			turret = new Turret(-500, -500);
			pumpkin = new Pumpkin(-500, -500);
			gobbin = new Gobbin(-500, -500);
			sax = new Sax(-500, -500);
			boss = new Boss(-500, -500);
			enemyArray[0] = bat;
			enemyArray[1] = ghost;
			enemyArray[2] = scarecrow;
			enemyArray[3] = rat;
			enemyArray[4] = turret;
			enemyArray[5] = pumpkin;
			enemyArray[6] = sax;
			enemyArray[7] = gobbin;
			enemyArray[8] = boss;
			// Choose what enemies appear on which levels
			switch Config.roomLevel
			{
				case 1:
					enemyNum = Random.fromArray([0, 2, 5]);
				case 2:
					enemyNum = Random.fromArray([0, 1, 3, 7, 6]);

				case 3:
					enemyNum = Random.fromArray([1, 3, 4, 7]);

				case 4:
					enemyNum = 8;
			}
			this.enemy[i] = this.enemyArray[enemyNum]; // Put enemyNum here for game
			this.enemy[i].x = FlxG.width / 2 - enemy[i].width / 2;
			this.enemy[i].y = FlxG.height / 2 - enemy[i].height / 2;
		}
	}

	function swapLevel()
	{
		if (bomb.startNewRoom)
		{
			trace("New Room - Battle");
		}
	}

	/**Determine which door the player came out of and put them in the respective area**/
	function positionPlayer(player:FlxSprite)
	{
		if (Config.roomDirection != null)
		{
			switch Config.roomDirection
			{
				case "right":
					player.setPosition(56, 255);
				case "left":
					player.setPosition(744, 255);
				case "up":
					player.setPosition(409, 456);
				case "down":
					player.setPosition(409, 53);
			}
		}
	}
}
