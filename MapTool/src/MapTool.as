package
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class MapTool extends Sprite
	{	
		public function MapTool()
		{
			createNativeWindow();
		}
		
		private function createNativeWindow():void
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.transparent = false;
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.renderMode = NativeWindowRenderMode.DIRECT;
			options.type = NativeWindowType.NORMAL;
			
			var newWindow:NewWindow = new NewWindow(options);
			
//			var newWindow:NativeWindow = new NativeWindow(options);
			newWindow.title = "A title";
			newWindow.width = 600;
			newWindow.height = 1024;
			
			newWindow.stage.align = StageAlign.TOP_LEFT;
			newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			newWindow.activate();
			
			newWindow.startStarling();
		}
		
		private function initialize(event:Event):void
		{
			
		}
	}
}