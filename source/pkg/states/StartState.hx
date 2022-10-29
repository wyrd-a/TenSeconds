package pkg.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import pkg.config.Config;
import pkg.substates.WinSubState;

/**
	Start screen
**/
class StartState extends FlxState
{
	private var startButton:FlxButton;
	private var sfxVolButton:FlxButton;
	private var musicVolButton:FlxButton;
	var startMusic:FlxSound;

	override public function create():Void
	{
		super.create();
		var startBg = new FlxSprite(0, 0);
		startBg.loadGraphic(AssetPaths.splashScreen__png, true, 864, 576);
		startBg.animation.add("startloop", [0, 1, 2, 3], 10);
		startBg.animation.play("startloop");
		add(startBg);
		startBg.updateHitbox();
		startBg.setPosition(0, 0);
		// this.createButtons();

		FlxG.sound.playMusic(AssetPaths.Medly_of_Madness__ogg, 1, true);
	}

	override public function update(elapsed:Float)
	{
		screenSize();
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
		{
			Config.roomLevel = 1;
			Config.roomLevelName = AssetPaths.level1__png;
			Config.roomFlavor = "bitter";

			FlxG.switchState(new PlayState());
		}
	}

	private function createButtons()
	{
		// Construction
		this.startButton = new FlxButton(0, 0, "Start", this.startHandler);
		this.sfxVolButton = new FlxButton(0, 0, "SFX", this.sfxVolHandler);
		this.musicVolButton = new FlxButton(0, 0, "Music", this.musicVolHandler);

		// Position
		this.startButton.setPosition(Config.CENTER_WIDTH - this.startButton.width / 2, Config.CENTER_HEIGHT - 200);
		this.sfxVolButton.setPosition(Config.CENTER_WIDTH - this.sfxVolButton.width / 2, Config.CENTER_HEIGHT);
		this.musicVolButton.setPosition(Config.CENTER_WIDTH - this.musicVolButton.width / 2, Config.CENTER_HEIGHT + 200);

		add(this.startButton); // Start button is added here don't need to call it again
		add(this.sfxVolButton);
		add(this.musicVolButton);
	}

	private function startHandler()
	{
		FlxG.switchState(new PlayState());
	}

	private function sfxVolHandler() {}

	private function musicVolHandler() {}

	function screenSize()
	{
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
