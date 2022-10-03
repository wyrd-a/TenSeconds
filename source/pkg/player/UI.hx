package pkg.player;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class UI extends FlxSpriteGroup
{
	var healthText:FlxText;
	var healthBar:FlxSprite;
	var samText:FlxText;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		healthBar = new FlxSprite(x, y).makeGraphic(100, 20, FlxColor.GREEN);
		add(healthBar);
		healthText = new FlxText(x, y + 6);
		add(healthText);
		healthText.text = "5 / 5";

		samText = new FlxText(20, 20);
		add(samText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function updateUI(player:Player, weapon:Weapon)
	{
		if (player.health > 0)
		{
			healthBar.setGraphicSize(Std.int(20 * player.currentHealth), 20);
			healthBar.updateHitbox();
			healthText.text = player.currentHealth + " / 5";
			samText.text = "Weapon Origin: " + weapon.origin;
		}
	}
}
