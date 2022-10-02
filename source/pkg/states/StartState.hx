package pkg.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import pkg.config.Config;

/**
	Start screen
**/
class StartState extends FlxState
{
	private var startButton:FlxButton;
	private var sfxVolButton:FlxButton;
	private var musicVolButton:FlxButton;

	override public function create()
	{
		super.create();
		var startBg = new FlxSprite(0, 0);
		startBg.loadGraphic(AssetPaths.dumbcat1__jpg);

		add(startBg);
		add(startButton);
		this.createButtons();
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

		add(this.startButton);
		add(this.sfxVolButton);
		add(this.musicVolButton);
	}

	private function startHandler()
	{
		FlxG.switchState(new PlayState());
	}

	private function sfxVolHandler() {}

	private function musicVolHandler() {}
}
