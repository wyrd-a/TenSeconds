package pkg.player;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import pkg.enemy.Enemy;

class UI extends FlxSpriteGroup
{
	var healthBG:FlxSprite;
	var healthText:FlxText;
	var healthBar:FlxSprite;

	var ehealthBar:FlxSprite;
	var ehealthText:FlxText;
	var eName:FlxText;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		healthBG = new FlxSprite(0, 0);
		healthBG.loadGraphic(AssetPaths.healthBars__png);
		healthBG.scale.set(3, 3);
		healthBG.updateHitbox();
		healthBG.setPosition(0, 0);
		add(healthBG);
		healthBar = new FlxSprite(78, 534).makeGraphic(35 * 3, 21, FlxColor.RED);
		add(healthBar);
		healthText = new FlxText(healthBar.x + 6, healthBar.y + 6);
		add(healthText);
		healthText.text = "5 / 5";

		// enemy health
		ehealthBar = new FlxSprite(681, 534).makeGraphic(35 * 3, 21, FlxColor.RED);
		add(ehealthBar);
		ehealthText = new FlxText(ehealthBar.x + 6, ehealthBar.y + 6);
		add(ehealthText);
		ehealthText.text = "5 / 5";
		eName = new FlxText(ehealthBar.x, ehealthBar.y - 20, 0, "Enemy", 12);
		eName.color = FlxColor.BLACK;
		add(eName);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function updateUI(player:Player, enemy:Enemy)
	{
		eName.text = enemy.name;
		if (player.health > 0)
		{
			healthBar.setGraphicSize(Std.int((105 / 5 * player.health)), 21);
			healthBar.updateHitbox();
			healthText.text = player.health + " / " + player.maxHealth;
		}
		if (enemy.health > 0)
		{
			ehealthBar.setGraphicSize(Std.int((105 / enemy.maxHealth * enemy.health)), 21);
			ehealthBar.updateHitbox();
			ehealthText.text = enemy.health + " / " + enemy.maxHealth;
		}
		else
		{
			ehealthBar.kill();
			ehealthText.text = "0 / " + enemy.maxHealth;
		}
	}
}
