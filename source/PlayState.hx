package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var player:Player;
	var weapon:Weapon;
	var enemy:Enemy;

	// debug text
	var weaponAngle:FlxText;
	var weaponTarget:FlxText;
	var levelBG:FlxSprite;

	override public function create()
	{
		levelBG = new FlxSprite(FlxG.width / 3, FlxG.height / 3).loadGraphic(AssetPaths.Level1__png); // This is for debugging of the zoom
		add(levelBG);
		FlxG.camera.zoom = 3;
		player = new Player(20, 20); // Create a new player
		add(player);
		enemy = new Enemy(400, 400);
		add(enemy);
		weapon = new Weapon();
		add(weapon);

		// debug text
		weaponAngle = new FlxText(0, 0, 0, "Weapon Angle: ");
		add(weaponAngle);
		weaponTarget = new FlxText(0, 16, 0, "Target Angle: ");
		add(weaponTarget);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		enemy.trackPlayer(player.x, player.y);
		weapon.move(player.x, player.y, player.velocity.x, player.velocity.y);
		FlxG.collide(player, enemy, enemydies);

		// debug text
		weaponAngle.text = "Weapon Angle: " + weapon.angle;
		weaponTarget.text = "Target Angle: " + weapon.targetAngle;
	}

	function enemydies(objA:FlxSprite, objB:FlxSprite):Void
	{
		objB.kill();
		var zoomState:ZoomState = new ZoomState(0x99DAD6D6);
		openSubState(zoomState);
	}
}
