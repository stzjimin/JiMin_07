package
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import customize.SceneManager;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate = "60", width="800", height="1024")]
	public class MapTool extends Sprite
	{	
		private var _starling:Starling;
		
		public function MapTool()
		{
			Starling.multitouchEnabled = true;
			_starling = new Starling(SceneManager, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starling.showStats = true;
//			createNativeWindow();
		}
		
		private function onRootCreated(event:starling.events.Event):void
		{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			SceneManager.current.addScene(Main, "main");
			SceneManager.current.goScene("main");
			_starling.start();
		}
		
		private function createNativeWindow():void
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.transparent = false;
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.renderMode = NativeWindowRenderMode.DIRECT;
			options.type = NativeWindowType.NORMAL;
			
			var newWindow:NewWindow = new NewWindow(options);
			
			newWindow.title = "A title";
			newWindow.width = 600;
			newWindow.height = 1024;
			
			newWindow.stage.align = StageAlign.TOP_LEFT;
			newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			newWindow.activate();
			
			newWindow.startStarling();
		}
	}
}