package pkg.enemy;

import AssetPaths;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import haxe.Timer;

/**This is the bomb that drops upon enemy death**/
class Bomb extends FlxSpriteGroup
{
	var bombBody:FlxSprite;
	var bombTimer:Float = 0;
	var bombText:FlxText;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		bombBody = new FlxSprite(x, y);
		bombBody.loadGraphic(AssetPaths.Player__png);
		add(bombBody);
		bombText = new FlxText(x + 20, y + 20);
		add(bombText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function countdown(player:FlxSprite, enemy:FlxSprite)
	{
		if (!enemy.alive)
		{
			if (bombTimer == 0)
			{
				bombTimer = Timer.stamp();
				x = enemy.x;
				y = enemy.y;
			}

			if (Timer.stamp() - bombTimer > 10)
			{
				player.kill();
			}
			else
			{
				bombText.text = Std.string(Math.floor(10 - Timer.stamp() + bombTimer));
			}
		}
	}
}
