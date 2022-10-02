package pkg.player;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class UI extends FlxSprite
{
	var healthText:FlxText;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		makeGraphic(100, 20, FlxColor.GREEN);
		healthText = new FlxText(20, 6);
		healthText.text = "5 / 5";
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function updateUI(player:FlxSprite)
	{
		if (player.health > 0)
		{
			setGraphicSize(Std.int(20 * player.health), 20);
			updateHitbox();
			healthText.text = player.health + " / 5";
		}
	}
}
