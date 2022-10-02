package pkg.room;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import haxe.Timer;

class Room extends FlxSprite
{
	private var roomBg:FlxBackdrop;

	public function new(x:Float = 0, y:Float = 0, ?background:String)
	{
		super(x, y);
		var graphic = loadGraphic(AssetPaths.level1__png, false);
		graphic.setGraphicSize(Math.floor(graphic.width * 3), Math.floor(graphic.height * 3));
		graphic.setPosition(288, 192);
		this.roomBg = new FlxBackdrop(AssetPaths.level1__png);
	}

	override public function update(elapsed:Float):Void {}
}
