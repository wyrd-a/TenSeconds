package pkg.room;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import pkg.config.Config;
import pkg.player.Player;

class AssetCollider extends FlxSpriteGroup
{
	public var isObstacle:Bool = true;

	var boxes:Array<FlxSprite>;
	var boxInt:Int = 0;
	var lay:Array<Int>;

	override public function new(x:Float = 0, y:Float = 0, level:String)
	{
		super(x, y);
		boxes = new Array<FlxSprite>();
		pickLayout(level);
		for (i in 0...lay.length)
		{
			if (lay[i] == 1)
			{
				boxes[boxInt] = new FlxSprite((i % 18) * 48, 48 * Math.floor(i / 18));
				boxes[boxInt].makeGraphic(48, 48, FlxColor.WHITE);
				boxes[boxInt].immovable = true;
				boxes[boxInt].alpha = 0.00;
				add(boxes[boxInt]);
				// boxes[boxInt].x += 4;
				// boxes[boxInt].y += 4;
				boxInt += 1;
			}
		}
	}

	function pickLayout(level:String)
	{
		switch (level)
		{
			case "11":
				lay = Config.lvl1_1;
			case "12":
				lay = Config.lvl1_2;
			case "13":
				lay = Config.lvl1_3;
			case "14":
				lay = Config.lvl1_4;
			case "15":
				lay = Config.lvl1_5;
			case "21":
				lay = Config.lvl2_1;
			case "22":
				lay = Config.lvl2_2;
			case "23":
				lay = Config.lvl2_3;
			case "24":
				lay = Config.lvl2_4;
			case "25":
				lay = Config.lvl2_5;
			case "31":
				lay = Config.lvl3_1;
			case "32":
				lay = Config.lvl3_2;
			case "33":
				lay = Config.lvl3_3;
			case "34":
				lay = Config.lvl3_4;
			case "35":
				lay = Config.lvl3_5;
			case "41":
				lay = Config.lvl4_1;
		}
	}
}
