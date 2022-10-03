package pkg.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import pkg.substates.BattleSubState;
import pkg.substates.PauseSubState;
import pkg.substates.RewardSubState;
import pkg.substates.SelectSubState;

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
	private var rewardSubState:RewardSubState;
	private var selectSubState:SelectSubState;
	private var allSubstates:Array<FlxSubState>;

	override public function create()
	{
		super.create();
		// By default, just go to battle substate
		this.persistentDraw = true;
		this.persistentUpdate = true;
		this.destroySubStates = false;

		this.battleSubState = new BattleSubState();
		this.pauseSubState = new PauseSubState();

		openSubState(this.battleSubState);
	}

	override public function update(elapsed:Float)
	{
		this.handleInput();
		this.returnToDefaultState();
		super.update(elapsed);
	}

	private function handleInput()
	{
		if (FlxG.keys.anyJustPressed(["SPACE"]))
		{
			if (this.subState != this.pauseSubState)
			{
				this.prevSubState = this.subState;
				this.closeSubState();
				this.openSubState(this.pauseSubState);
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
}
