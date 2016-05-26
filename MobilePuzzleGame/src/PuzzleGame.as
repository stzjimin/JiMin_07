package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(frameRate = "60", width="576", height="1024", backgroundColor="#FFFFF0")]
	public class PuzzleGame extends Sprite
	{
		public function PuzzleGame()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled = true;
			var starlingCore:Starling = new Starling(Game, stage);
			starlingCore.showStats = true;
			starlingCore.start();
		}
	}
}