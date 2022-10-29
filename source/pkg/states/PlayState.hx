package pkg.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSubState;
import flixel.input.FlxAccelerometer;
import pkg.config.Config;
import pkg.substates.BattleSubState;
import pkg.substates.LoseSubState;
import pkg.substates.PauseSubState;
import pkg.substates.SelectSubState;
import pkg.substates.WinSubState;

/**
	Main playstate, includes logic for switching between 
	various substates for different aspects of playing the
	game.
**/
class PlayState extends FlxState
{
	private var prevSubState:FlxSubState;
	private var battleSubState:BattleSubState;
	private var pauseSubState:PauseSubState;
	private var loseSubState:LoseSubState;
	private var winSubState:WinSubState;
	private var selectSubState:SelectSubState;
	private var allSubstates:Array<FlxSubState>;

	var songTracker:Int = 0;

	override public function create()
	{
		// FlxG.sound.volume = 0;
		super.create();
		chooseMusic();
		// By default, just go to battle substate
		this.persistentDraw = true;
		this.persistentUpdate = true;
		this.destroySubStates = false;

		this.battleSubState = new BattleSubState();
		pauseSubState = new PauseSubState();
		loseSubState = new LoseSubState();
		winSubState = new WinSubState();

		openSubState(this.battleSubState);
	}

	override public function update(elapsed:Float)
	{
		// this.handleInput();
		// this.returnToDefaultState();
		swapLevel();
		screenSize();

		super.update(elapsed);
	}

	private function handleInput()
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (this.subState != this.pauseSubState)
			{
				this.prevSubState = this.subState;
				this.closeSubState();
				trace(pauseSubState.bgColor.alpha);
				openSubState(pauseSubState);
			}
			else
			{
				this.closeSubState();
				this.openSubState(this.prevSubState);
			}
		}
	}

	private function returnToDefaultState()
	{
		if (this.subState == null)
		{
			this.openSubState(this.battleSubState);
		}
	}

	function swapLevel()
	{
		if (battleSubState.startNewRoom)
		{
			FlxG.sound.destroy();
			if (battleSubState.playerWon == 1)
			{
				battleSubState.close();
				openSubState(winSubState);
			}
			else if (battleSubState.playerWon == -1)
			{
				battleSubState.close();
				openSubState(loseSubState);
			}
			else
			{
				battleSubState.close();
				openSubState(battleSubState = new BattleSubState());
				chooseMusic();
			}
		}
	}

	function chooseMusic()
	{
		trace(Config.roomLevel);
		switch (Config.roomLevel)
		{
			case 1:
				if (songTracker != 1)
				{
					FlxG.sound.playMusic(AssetPaths.Klockvinde__ogg);
					songTracker = 1;
				}
			case 2:
				if (songTracker != 2)
				{
					FlxG.sound.playMusic(AssetPaths.Wandering_Beast_FINAL__ogg, 1);
					songTracker = 2;
				}
			case 3:
				if (songTracker != 3)
				{
					FlxG.sound.playMusic(AssetPaths.Mechanical_Monstrosity_FINAL__ogg, 1);

					songTracker = 3;
				}
			case 4:
				if (songTracker != 4)
				{
					FlxG.sound.playMusic(AssetPaths.Overclocking__ogg);
					songTracker = 4;
				}
		}
	}

	function screenSize()
	{
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
