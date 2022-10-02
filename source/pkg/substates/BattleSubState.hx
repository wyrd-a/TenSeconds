package pkg.substates;

import AssetPaths;
import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import pkg.enemy.Enemy;
import pkg.player.Player;
import pkg.player.UI;
import pkg.player.Weapon;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	var roomBG:FlxSprite;

	var player:Player;
	var enemy:Enemy;
	var weapon:Weapon;
	var ui:UI;

	override public function create()
	{
		// These look nice
		roomBG = new FlxSprite(0, 0).loadGraphic(AssetPaths.level1__png);
		roomBG.setGraphicSize(Std.int(3 * roomBG.width), 0);
		add(roomBG);

		// Things with logic tied to them
		player = new Player(200, 200);
		add(player);
		enemy = new Enemy(400, 400);
		add(enemy);
		weapon = new Weapon();
		add(weapon);
		ui = new UI(20, FlxG.height - 22);
		add(ui);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		enemy.trackPlayer(player);
		weapon.move(player, enemy);
		ui.updateUI(player);

		super.update(elapsed);
		// trace("Updated in battle state");
	}
}
