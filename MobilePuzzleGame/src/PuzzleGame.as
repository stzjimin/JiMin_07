package  
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import customize.SceneManager;
	
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
		
		public static var stageHeight:int;
		public static var stageWidth:int;
		
		private var _starlingCore:Starling;
		
		public function PuzzleGame()
		{
			var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), ScaleMode.SHOW_ALL); 
			
			stageWidth = stage.fullScreenWidth;
			stageHeight = stage.fullScreenHeight;
			
//			Starling.multitouchEnabled = true;
			_starlingCore = new Starling(SceneManager, stage, viewPort);
			_starlingCore.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starlingCore.showStats = true;
			
			trace(stageWidth);
			trace(stageHeight);
		}
		
		/**
		 * 씬메니저가 만들어지면 호출되는 함수입니다.
		 * @param event
		 * 
		 */		
		private function onRootCreated(event:Event):void
		{
			_starlingCore.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			SceneManager.current.addScene(TitleScene, "title");
			SceneManager.current.goScene("title");
			_starlingCore.start();
		}
	}
}