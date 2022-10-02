package pkg.substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import pkg.config.Config;
import pkg.states.StartState;

/**
	Battle sub state. Includes logic for rooms,
	enemies 
**/
class PauseSubState extends FlxSubState
{
	public var isPersistent:Bool = true;

	private var quitButton:FlxButton;
	private var resumeButton:FlxButton;
	private var sfxVolButton:FlxButton;
	private var musicVolButton:FlxButton;
	private var buttons:Array<FlxButton>;

	override public function create()
	{
		super.create();
		this.createButtons();
	}

	private function quitHandler()
	{
		FlxG.switchState(new StartState());
	}

	private function resumeHandler()
	{
		close();
	}

	private function volUpHandler() {}

	private function volDownHandler() {}

	private function createButtons()
	{
		// Definition
		this.quitButton = new FlxButton(0, 0, "Quit", this.quitHandler);
		this.resumeButton = new FlxButton(0, 0, "Resume", this.resumeHandler);
		this.sfxVolButton = new FlxButton(0, 0, "SFX", this.volUpHandler);
		this.musicVolButton = new FlxButton(0, 0, "Music", this.volDownHandler);
		this.buttons = [this.quitButton, this.resumeButton, this.sfxVolButton, this.musicVolButton];

		// Position
		this.quitButton.setPosition(Config.CENTER_WIDTH - 300, Config.CENTER_HEIGHT);
		this.resumeButton.setPosition(Config.CENTER_WIDTH - 150, Config.CENTER_HEIGHT);
		this.sfxVolButton.setPosition(Config.CENTER_WIDTH + 150 - this.sfxVolButton.width, Config.CENTER_HEIGHT);
		this.musicVolButton.setPosition(Config.CENTER_WIDTH + 300 - this.sfxVolButton.width, Config.CENTER_HEIGHT);

		// Callbacks
		this.buttons.map(button ->
		{
			add(button);
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
