package pkg.substates;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxSort;
import pkg.enemy.Enemy;
import pkg.player.Player;
import pkg.player.UI;
import pkg.player.Weapon;
import pkg.room.Room;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	var player:Player;
	var enemy:Enemy;
	var weapon:Weapon;
	var ui:UI;
	var room:Room;

	override public function create()
	{
		this.room = new Room();
		add(this.room);

		// Things with logic tied to them
		this.player = new Player(500, 500);
		add(this.player);

		this.enemy = new Enemy(400, 400);
		add(this.enemy);
		this.weapon = new Weapon();
		add(this.weapon);
		this.ui = new UI(20, FlxG.height - 22);
		add(this.ui);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		this.checkHitboxes();
		this.enemy.trackPlayer(player);
		this.weapon.move(player, enemy);
		this.ui.updateUI(player);

		super.update(elapsed);
		trace("Updated in battle state");
	}

	public function checkHitboxes()
	{
		this.room.checkWallHitboxes([player, enemy]);
	}
}
