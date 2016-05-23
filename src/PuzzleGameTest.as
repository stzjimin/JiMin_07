package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(frameRate = "60", width="900", height="1600")]
	public class PuzzleGameTest extends Sprite
	{
		public function PuzzleGameTest()
		{
			Starling.multitouchEnabled = true;
			var starlingCore:Starling = new Starling(Game, stage);
			starlingCore.showStats = true;
			starlingCore.start();
		}
	}
}