package pkg.substates;

import AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxSort;
import haxe.macro.Type.AbstractType;
import pkg.enemy.Bat;
import pkg.enemy.Bomb;
import pkg.enemy.Ghost;
import pkg.enemy.Rat;
import pkg.enemy.Scarecrow;
import pkg.player.Player;
import pkg.player.UI;
import pkg.player.Weapon;
import pkg.player.WeaponGroup;
import pkg.room.Room;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class BattleSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	var player:Player;
	var weapon:WeaponGroup;
	var room:Room;
	var ui:UI;
	var healthText:FlxText;
	var bomb:Bomb;

	// I'm sorry, wyrd-a
	var ghost:Ghost;
	var bat:Bat;
	var scarecrow:Scarecrow;
	var rat:Rat;
	var enemyArray:Array<Dynamic>;
	var enemyNum:Int;
	var enemy:Dynamic;

	override public function create()
	{
		this.room = new Room();
		add(this.room);

		// Things with logic tied to them
		this.player = new Player(200, 200);
		add(this.player);

		// Once again, I apologize
		enemyCreation();

		bomb = new Bomb(-50, -50);
		add(bomb);

		this.weapon = new WeaponGroup();
		add(this.weapon);
		this.ui = new UI(20, FlxG.height - 22);
		add(this.ui);

		this.healthText = new FlxText(40, 40);
		add(healthText);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		this.checkHitboxes();
		this.enemy.aiWorkings(this.player);
		this.ui.updateUI(player);
		bomb.countdown(player, enemy);
		super.update(elapsed);
		this.weapon.positioning(this.player, this.enemy);
	}

	public function checkHitboxes()
	{
		this.room.checkWallHitboxes([this.player, this.enemy]);
	}

	/**Initiates a bunch of enemies and then chooses one to add to the game. Probably inefficient but its 2:27 am**/
	function enemyCreation()
	{
		enemyArray = new Array<Dynamic>();
		bat = new Bat(400, 400);
		ghost = new Ghost(400, 400);
		scarecrow = new Scarecrow(400, 400);
		rat = new Rat(400, 400);
		enemyArray[0] = bat;
		enemyArray[1] = ghost;
		enemyArray[2] = scarecrow;
		enemyArray[3] = rat;
		enemyNum = Math.floor(enemyArray.length * Math.random());
		this.enemy = this.enemyArray[3];
		add(this.enemy);
	}
}
