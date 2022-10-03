package pkg.substates;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxSort;
import pkg.enemy.Bat;
import pkg.enemy.Enemy;
import pkg.enemy.Ghost;
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
	var enemy:Bat;
	var weapon:Weapon;
	var room:Room;
	// var ui:UI;
	var healthText:FlxText;

	override public function create()
	{
		this.room = new Room();
		add(this.room);

		// Things with logic tied to them
		this.player = new Player(200, 200);
		add(this.player);
		this.enemy = new Bat(400, 400);
		add(this.enemy);
		this.weapon = new Weapon();
		add(this.weapon);
		// ui = new UI(20, FlxG.height - 22);
		// add(ui);

		this.healthText = new FlxText(40, 40);
		add(healthText);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		this.checkHitboxes();
		this.enemy.trackPlayer(this.player);
		this.weapon.move(this.player, this.enemy);
		// ui.updateUI(player);
		this.healthText.text = Std.string(this.enemy.health);
		super.update(elapsed);
		trace("Updated in battle state");
	}

	public function checkHitboxes()
	{
		this.room.checkWallHitboxes([this.player, this.enemy]);
	}
}
