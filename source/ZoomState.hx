package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Timer;

// Thanks for the Substate code, Zaphod
class ZoomState extends FlxSubState
{
	// just a helper flag, showing if this substate is persistent or not
	public var isPersistent:Bool = false;

	var xScale:Float = 1;
	var yScale:Float = 1;

	var rooms:Array<FlxSprite>;

	var tenSeconds:Float = 0;

	var countDown:FlxText;

	override public function create():Void
	{
		countDown = new FlxText(FlxG.width - 50, 0, 0, "10", 8);
		add(countDown);
		countDown.text = Std.string(Timer.stamp());
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.camera.zoom > 1)
		{
			FlxG.camera.zoom -= 0.01;
		}
		else // This is the part where we gotta add the countdown
		{
			if (tenSeconds == 0) // Start countdown
			{
				tenSeconds = Timer.stamp();
			}
			if (Timer.stamp() - tenSeconds > 10)
			{
				FlxG.switchState(new PlayState());
			}
			else
			{
				countDown.text = Std.string(Math.ceil(10 - (Timer.stamp() - tenSeconds)));
			}
		}

		if (FlxG.keys.pressed.ESCAPE) // Close the thing
		{
			close();
		}
	}
}
