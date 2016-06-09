package customize
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class ListViewContent extends DisplayObjectContainer
	{
		public static const CLICKED:String = "contentClicked";
		
		private var _backGround:Image;
		
		public function ListViewContent()
		{
			super();
		}
		
		public function init(backGroundTexture:Texture):void
		{
			if(backGroundTexture == null)
				return;
			_backGround = new Image(backGroundTexture);
			_backGround.addEventListener(TouchEvent.TOUCH, onBackGroundTouch);
			addChild(_backGround);
		}
		
		public function destroy():void
		{
			_backGround.removeEventListener(TouchEvent.TOUCH, onBackGroundTouch);
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			dispose();
		}
		
		private function onBackGroundTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
				dispatchEvent(new Event(ListViewContent.CLICKED));
		}
	}
}