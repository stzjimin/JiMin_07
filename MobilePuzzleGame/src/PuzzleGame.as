package  
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import customize.SceneManager;
	
	import puzzle.stageSelect.StageSelectScene;
	import puzzle.title.TitleScene;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(frameRate = "60", backgroundColor="#FFFFF0")]
	public class PuzzleGame extends Sprite
	{
		public static const WIDTH:int = 576;  
		public static const HEIGHT:int = 1024;  
		
		private var _starlingCore:Starling;
		
		public function PuzzleGame()
		{
			var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, WIDTH, HEIGHT), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), ScaleMode.SHOW_ALL); 
			
			// support autoOrients
//			stage.align = StageAlign.TOP;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			Starling.multitouchEnabled = true;
			_starlingCore = new Starling(SceneManager, stage, viewPort);
			_starlingCore.stage.stageWidth  = WIDTH; 
			_starlingCore.stage.stageHeight = HEIGHT;
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