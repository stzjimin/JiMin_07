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
	
	import starlingOrigin.core.Starling;
	import starlingOrigin.events.Event;
	
	[SWF(frameRate = "60", width="800", height="1024")]
	public class MapTool extends Sprite
	{	
		private var _starling:Starling;
		
		public function MapTool()
		{
			Starling.multitouchEnabled = true;
			_starling = new Starling(Main, stage);
//			_starling.addEventListener(starlingOrigin.events.Event.ROOT_CREATED, onRootCreated);
			_starling.showStats = true;
			_starling.start();
//			createNativeWindow();
		}
		
//		private function onRootCreated(event:starlingOrigin.events.Event):void
//		{
//			_starling.removeEventListener(starlingOrigin.events.Event.ROOT_CREATED, onRootCreated);
//			SceneManager.current.addScene(Main, "main");
//			SceneManager.current.goScene("main");
//			_starling.start();
//		}
	}
}