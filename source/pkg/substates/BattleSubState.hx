package pkg.substates;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSort;
import pkg.enemy.Enemy;
import pkg.enemy.Ghost;
import pkg.player.Player;
import pkg.player.UI;
import pkg.player.Weapon;
import pkg.room.Obstacle;
import pkg.room.Room;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	var player:Player;
	var enemy:Ghost;
	var weapon:Weapon;
	var ui:UI;
	var room:Room;
	var obstacleSortGroup:FlxSpriteGroup;

	override public function create()
	{
		this.player = new Player(500, 500);
		this.room = new Room();

		// Room is added independently of obstacles
		// within the room and the player, due to sort
		// group
		add(this.room);

		this.enemy = new Enemy(400, 400);
		// add(this.weapon);
		// this.ui = new UI(20, FlxG.height - 22);
		// add(this.ui);

		this.room.createRoomObstacles([this.player, this.enemy]);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		this.checkHitboxes();
		this.enemy.trackPlayer(player);
		// this.weapon.move(player, enemy);
		// this.ui.updateUI(player);

		super.update(elapsed);
	}

	public function checkHitboxes()
	{
		this.room.checkWallHitboxes([player, enemy]);
		this.room.checkObstacles();
	}
}
