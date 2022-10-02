package pkg.menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.weapon.FlxBullet;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Timer;

class PauseMenu extends FlxSprite
{
	private var quitButton:FlxButton;
	private var resumeButton:FlxButton;
	private var volUpButton:FlxButton;
	private var volDownButton:FlxButton;

	public function new(x:Float = 0, y:Float = 0, ?background:String)
	{
		super(x, y);
		this.quitButton = new FlxButton("Quit");
		this.resumeButton = new FlxButton("Resume");
		this.volUpButton = new FlxButton("Volume up");
		this.volDownButton = new FlxButton("Volume down");
	}

	private function quit() {}

	override public function update(elapsed:Float):Void {}
}
