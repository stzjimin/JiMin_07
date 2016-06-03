package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import customize.SceneManager;
	
	import puzzle.ingame.InGame;
	import puzzle.stageSelect.StageSelectScene;
	import puzzle.title.TitleScene;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate = "60", width="576", height="1024", backgroundColor="#FFFFF0")]
	public class PuzzleGame extends Sprite
	{
		private var _starlingCore:Starling;
		
		public function PuzzleGame()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled = true;
			_starlingCore = new Starling(SceneManager, stage);
			_starlingCore.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starlingCore.showStats = true;
		}
		
		private function onRootCreated(event:Event):void
		{
			_starlingCore.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			SceneManager.current.addScene(TitleScene, "title");
			SceneManager.current.addScene(StageSelectScene, "stageSelect");
			SceneManager.current.goScene("title");
			_starlingCore.start();
		}
	}
}