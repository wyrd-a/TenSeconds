package pkg.enemy;

import astar.Graph;
import astar.SearchResult;
import astar.types.Direction;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.utils.IAssetCache;
import pkg.config.Config;

/**
	Pathfinding algorithm using the astar addon
**/
class PathFind extends FlxSpriteGroup
{
	var worldWidth = 18;
	var worldHeight = 12;

	var graph:Graph;

	var world:Array<Int>;

	var startX:Int;
	var startY:Int;
	var endX:Int;
	var endY:Int;

	public function new(x:Float = 0, y:Float = 0, level:String)
	{
		super(x, y);
		graph = new Graph(worldWidth, worldHeight, FourWay);

		// This changes per room layout... but how...
		levelPick(level);

		graph.setWorld(world);

		var costs = [
			// 0 is our ground, with a cost of 1 to move lateraly.
			// also: 0 => Graph.DefaultCosts,
			0 => [N => 1.0, S => 1.0, W => 1.0, E => 1.0],
			2 => [N => 99.0, S => 99.0, W => 99.0, E => 99.0],
			3 => [N => 999.0, S => 999.0, W => 999.0, E => 999.0],
			// without any cost specified, they are impassable

		];

		graph.setCosts(costs);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**Returns start x, start y, end x, end y**/
	public function pathFinding(player:FlxSprite, enemy:FlxSprite)
	{
		startX = Math.floor((enemy.x + enemy.width / 2) / 48);
		startY = Math.floor((enemy.y + enemy.height / 2) / 48);
		endX = Math.floor(player.x / 48);
		endY = Math.floor(player.y / 48);
		var result:SearchResult = graph.solve(startX, startY, endX, endY);
		if (result.result == Solved)
		{
			// trace("Target: " + result.path[result.path.length - 1]);
			// trace("Heading to " + result.path[1].x + ", " + result.path[1].y);
			trace(" ");
			trace("Player x: " + endX + " y: " + endY);
			trace("Cost: " + result.cost);
			for (i in 0...result.path.length)
				trace("Step " + i + ": x :" + result.path[i].x + " y: " + result.path[i].y);
			return [result.path[0].x, result.path[0].y, result.path[1].x, result.path[1].y];
		}
		else
		{
			trace("No path");
			return [null, null, null, null];
		}
	}

	function levelPick(level:String)
	{
		trace("Loading AI for " + level);
		switch (level)
		{
			case "11":
				world = Config.lvl1_1;
			case "12":
				world = Config.lvl1_2;
			case "13":
				world = Config.lvl1_3;
			case "14":
				world = Config.lvl1_4;
			case "15":
				world = Config.lvl1_5;
			case "21":
				world = Config.lvl2_1;
			case "22":
				world = Config.lvl2_2;
			case "23":
				world = Config.lvl2_3;
			case "24":
				world = Config.lvl2_4;
			case "25":
				world = Config.lvl2_5;
			case "31":
				world = Config.lvl3_1;
			case "32":
				world = Config.lvl3_2;
			case "33":
				world = Config.lvl3_3;
			case "34":
				world = Config.lvl3_4;
			case "35":
				world = Config.lvl3_5;
			case "41":
				world = Config.lvl4_1;
		}
	}
}
