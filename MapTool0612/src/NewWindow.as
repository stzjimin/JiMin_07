package
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	
	import customize.SceneManager;
	
	import puzzle.ingame.InGameScene;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class NewWindow extends NativeWindow
	{
		public static const WIDTH:Number = 576;
		public static const HEIGHT:Number = 576;
		
		private var _starling:Starling;
		
		public function NewWindow(options:NativeWindowInitOptions)
		{
			super(options);
//			this.title = title;
//			this.width = width;
//			this.height = height;
//			
//			this.stage.align = StageAlign.TOP_LEFT;
//			this.stage.scaleMode = StageScaleMode.NO_SCALE;
//			
//			this.active();
		}
		
		public function startStarling():void
		{
			Starling.multitouchEnabled = true;
			_starling = new Starling(SceneManager, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starling.showStats = true;
//			SceneManager.current.switchScene("game");
//			_starling.start();
		}
		
		private function onRootCreated(event:Event):void
		{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			SceneManager.current.addScene(InGameScene, "game");
			SceneManager.current.goScene("game");
			_starling.start();
		}
	}
}