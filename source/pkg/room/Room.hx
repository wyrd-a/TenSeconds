package pkg.room;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.Timer;
import haxe.macro.Context;
import haxe.macro.Expr;
import pkg.config.Config;
import pkg.enemy.Enemy;
import pkg.player.Player;
import pkg.room.Obstacle;

class Room extends FlxSpriteGroup
{
	public var zLevel:Int = 0;

	private var player:Player;
	private var roomLevel:Int;
	private var roomBg:FlxSprite;

	public var obstacles:Array<Obstacle>;
	public var nonObstacles:Array<FlxSprite>;
	public var wallBounds:Array<FlxSprite>;
	public var obstacleSortGroup:FlxSpriteGroup;

	public function new(?background:String, ?powerUp:String)
	{
		super();
		this.setBackground(background);
		this.createWalls();
	}

	private function setBackground(?assetPath:String)
	{
		// Default room is level 1
		var trueAssetPath:String;
		if (assetPath == null)
		{
			trueAssetPath = assetPath;
		}
		else
		{
			trueAssetPath = AssetPaths.level1__png;
		}

		this.roomBg = new FlxSprite(AssetPaths.level1__png);
		this.roomBg.setGraphicSize(Math.round(this.roomBg.width * 3), Math.round(this.roomBg.height * 3));
		this.roomBg.setPosition(288, 192); // default width, height of level
		add(this.roomBg);
	}

	private function createWalls()
	{
		var BOUND_HORIZONTAL_LENGTH = 128 * 3;
		var BOUND_VERTICAL_LENGTH = 80 * 3;
		var BOUND_THICKNESS = 16 * 3;

		var topWallLeftBound = new FlxSprite(0, 0);
		var topWallRightBound = new FlxSprite(Config.WINDOW_WIDTH - BOUND_HORIZONTAL_LENGTH, 0);
		var bottomWallLeftBound = new FlxSprite(0, Config.WINDOW_HEIGHT - BOUND_THICKNESS);
		var bottomWallRightBound = new FlxSprite(Config.WINDOW_WIDTH - BOUND_HORIZONTAL_LENGTH, Config.WINDOW_HEIGHT - BOUND_THICKNESS);

		var leftWallTopBound = new FlxSprite(0, 0);
		var leftWallBottomBound = new FlxSprite(0, Config.WINDOW_HEIGHT - BOUND_VERTICAL_LENGTH);
		var rightWallTopBound = new FlxSprite(Config.WINDOW_WIDTH - BOUND_THICKNESS, 0);
		var rightWallBottomBound = new FlxSprite(Config.WINDOW_WIDTH - BOUND_THICKNESS, Config.WINDOW_HEIGHT - BOUND_VERTICAL_LENGTH);

		var horizontalBounds = [topWallLeftBound, topWallRightBound, bottomWallLeftBound, bottomWallRightBound];
		var verticalBounds = [leftWallTopBound, leftWallBottomBound, rightWallTopBound, rightWallBottomBound];
		this.wallBounds = horizontalBounds.concat(verticalBounds);

		for (index => bound in horizontalBounds)
		{
			bound.makeGraphic(BOUND_HORIZONTAL_LENGTH, BOUND_THICKNESS, FlxColor.GREEN);
			bound.setSize(BOUND_HORIZONTAL_LENGTH, BOUND_THICKNESS);
		}

		for (index => bound in verticalBounds)
		{
			bound.makeGraphic(BOUND_THICKNESS, BOUND_VERTICAL_LENGTH, FlxColor.GREEN);
			bound.setSize(BOUND_THICKNESS, BOUND_VERTICAL_LENGTH);
		}

		for (index => bound in this.wallBounds)
		{
			bound.alpha = 0;
			bound.immovable = true;
			add(bound);
		}
	}

	public function createRoomObstacles(spritesToSortWithObstacles:Array<FlxSprite>)
	{
		this.obstacleSortGroup = new FlxSpriteGroup();
		this.obstacles = [
			new Obstacle(200, 200, "whatever"),
			new Obstacle(300, 300, "whatever"),
			new Obstacle(400, 400, "whatever")
		];
		this.nonObstacles = spritesToSortWithObstacles;

		for (index => obstacle in this.obstacles)
		{
			obstacle.immovable = true;
			this.obstacleSortGroup.add(obstacle);
		}

		for (index => sprite in spritesToSortWithObstacles)
		{
			this.obstacleSortGroup.add(sprite);
		}

		add(this.obstacleSortGroup);
	}

	public function checkObstacles()
	{
		this.obstacleSortGroup.sort(FlxSort.byY);

		for (index => nonObstacle in this.nonObstacles)
		{
			for (index => obstacle in this.obstacles)
			{
				obstacle.height = obstacle.graphic.height * obstacle.hitBoxHeightProportion;
				obstacle.offset.set(-obstacle.graphic.width, obstacle.graphic.height / 2);
				FlxG.collide(obstacle, nonObstacle);
			}
		}
	}

	public function checkWallHitboxes(sprites:Array<FlxSprite>)
	{
		for (index => bound in this.wallBounds)
		{
			for (index => collidingSprite in sprites)
			{
				bound.updateHitbox();
				FlxG.collide(bound, collidingSprite);
			}
		}
	}
}
