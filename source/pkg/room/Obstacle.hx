package pkg.room;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import pkg.player.Player;

class Obstacle extends FlxSprite
{
	public var isObstacle:Bool = true;

	public var hitBoxHeightProportion:Float;
	public var hitBoxWidthProportion:Float;

	private var walkBehindable:Bool = true;

	override public function new(x:Float = 0, y:Float = 0, type:String)
	{
		super(x, y);
		loadGraphic(AssetPaths.grandaddyStatue__png);
		this.scale.set(3, 3);
		this.updateHitbox();
		this.hitBoxHeightProportion = .5;
		// var walkBehindableTypes = ["grandfatherClock"];
		// this.walkBehindable = walkBehindableTypes.contains(type);
	}
}
