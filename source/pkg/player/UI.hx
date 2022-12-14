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

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		healthBG = new FlxSprite(0, 0);
		healthBG.loadGraphic(AssetPaths.healthBars__png);
		healthBG.scale.set(3, 3);
		healthBG.updateHitbox();
		healthBG.setPosition(0, 0);
		add(healthBG);
		healthBar = new FlxSprite(x, y).makeGraphic(100, 20, FlxColor.RED);
		add(healthBar);
		healthText = new FlxText(x, y + 6);
		add(healthText);
		healthText.text = "5 / 5";
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function updateUI(player:Player, enemy:Enemy)
	{
		if (player.health > 0)
		{
			healthBar.setGraphicSize(Std.int(20 * player.health), 20);
			healthBar.updateHitbox();
			healthText.text = player.health + " / " + player.maxHealth;
		}
	}
}
