package pkg.substates;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import pkg.enemy.Bat;
import pkg.enemy.Enemy;
import pkg.enemy.Ghost;
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

	var player:Player;
	var enemy:Bat;
	var weapon:Weapon;
	// var ui:UI;
	var healthText:FlxText;

	override public function create()
	{
		// Things with logic tied to them
		player = new Player(200, 200);
		add(player);
		enemy = new Bat(400, 400);
		add(enemy);
		weapon = new Weapon();
		add(weapon);
		// ui = new UI(20, FlxG.height - 22);
		// add(ui);

		healthText = new FlxText(40, 40);
		add(healthText);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		enemy.trackPlayer(player);
		weapon.move(player, enemy);
		// ui.updateUI(player);
		healthText.text = Std.string(enemy.health);
		super.update(elapsed);
		// trace("Updated in battle state");
	}
}
