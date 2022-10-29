package pkg.player;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import pkg.config.Config;
import pkg.enemy.Enemy;

class UI extends FlxSpriteGroup
{
	var healthBG:FlxSprite;
	var healthText:FlxText;
	var healthBar:FlxSprite;
	var pName:FlxText;
	var hearts:Array<FlxSprite>;

	var ehealthBar:FlxSprite;
	var ehealthText:FlxText;
	var eName:FlxText;

	var tileGrid:FlxSprite;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		/*
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
			pName = new FlxText(healthBar.x, healthBar.y - 20, 0, "Exorcist", 12);
			pName.color = FlxColor.BLACK;
			add(pName);

			// enemy health
			ehealthBar = new FlxSprite(681, 534).makeGraphic(35 * 3, 21, FlxColor.RED);
			add(ehealthBar);
			ehealthText = new FlxText(ehealthBar.x + 6, ehealthBar.y + 6);
			add(ehealthText);
			ehealthText.text = "5 / 5";
			eName = new FlxText(ehealthBar.x, ehealthBar.y - 20, 0, "Enemy", 12);
			eName.color = FlxColor.BLACK;
			add(eName); */

		// just for positioning assets and working out pathing
		/*tileGrid = new FlxSprite(0, 0);
			tileGrid.loadGraphic(AssetPaths.tileGrid__png);
			add(tileGrid);
		 */

		// Adding hearts to the game
		hearts = new Array<FlxSprite>();
		for (i in 0...15) // Just choosing 15 as a "huh, the player will NEVER have more than this right?"
		{
			hearts[i] = new FlxSprite(20 + (30 * i), 545);
			hearts[i].loadGraphic(AssetPaths.health__png, true, 9, 8);
			hearts[i].scale.set(3, 3);
			add(hearts[i]);
			hearts[i].kill();
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function updateUI(player:Player, enemy:Enemy)
	{
		for (i in 0...15)
		{
			hearts[i].animation.add("empty", [2], 1);
			hearts[i].animation.add("full", [0], 1);
			if (Config.playerMax > i)
			{
				hearts[i].revive();
			}
			else
			{
				hearts[i].kill();
			}
			if (player.health > i)
				hearts[i].animation.play("full");
			else
				hearts[i].animation.play("empty");
		}

		/*eName.text = enemy.name;
			if (player.health > 0)
			{
				healthBar.setGraphicSize(Std.int((105 / player.maxHealth * player.health)), 21);
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
		}*/
	}
}
