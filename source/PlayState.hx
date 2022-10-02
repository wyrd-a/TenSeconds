package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var player:Player;
	var weapon:Weapon;
	var enemy:Enemy;

	// debug text
	var weaponAngle:FlxText;
	var weaponTarget:FlxText;
	var levelBG:FlxSprite;

	var healthMeter:FlxSprite;
	var ehealthMeter:FlxSprite;

	override public function create()
	{
		levelBG = new FlxSprite(FlxG.width / 3, FlxG.height / 3).loadGraphic(AssetPaths.Level1__png);
		levelBG.setGraphicSize(864, 0);
		add(levelBG);
		player = new Player(FlxG.width / 3, FlxG.height / 3); // Create a new player
		add(player);
		enemy = new Enemy(400, 400, 80);
		add(enemy);
		weapon = new Weapon();
		add(weapon);

		healthMeter = new FlxSprite(0, 0).makeGraphic(200, 20, FlxColor.GREEN);
		add(healthMeter);
		ehealthMeter = new FlxSprite(0, FlxG.height - 20).makeGraphic(200, 20, FlxColor.RED);
		add(ehealthMeter);

		// debug text
		weaponAngle = new FlxText(FlxG.width / 3, FlxG.height / 3, 0, "Weapon Angle: ");
		// add(weaponAngle);
		weaponTarget = new FlxText(FlxG.width / 3, FlxG.height / 3 + 16, 0, "Target Angle: ");
		// add(weaponTarget);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		uiUpdate();
		enemy.trackPlayer(player);
		weapon.move(player, enemy);

		// debug text
		weaponAngle.text = "Weapon Angle: " + weapon.angle;
		weaponTarget.text = "Target Angle: " + weapon.targetAngle;
	}

	function uiUpdate()
	{
		if (player.health > 0)
		{
			healthMeter.setGraphicSize(Std.int(player.health * 20), 20);
			healthMeter.updateHitbox();
			healthMeter.x = 0;
		}
		else
		{
			healthMeter.kill();
		}
	}
}