package puzzle
{
	import flash.display.Bitmap;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Popup extends DisplayObjectContainer
	{
		[Embed(source="alpha.png")]
		private const testImage:Class;
		
		public static const COVER_CLICKED:String = "coverClicked";
		
		private var _backGround:Image;
		private var _coverFace:Image;
		
		public function Popup(width:Number, height:Number, backGroundTexture:Texture = null)
		{
			super();
			
			_coverFace = new Image(Texture.fromBitmap(new testImage() as Bitmap));
			_coverFace.width = 576;
			_coverFace.height = 1024;
			_coverFace.alpha = 0.5;
			_coverFace.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_coverFace);
			
			if(backGroundTexture != null)
			{
				_backGround = new Image(backGroundTexture);
				_backGround.alignPivot();
				_backGround.x = _coverFace.width/2;
				_backGround.y = _coverFace.height/2;
				_backGround.width = width;
				_backGround.height = height;
				addChild(_backGround);
			}
			
			this.visible = false;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_coverFace);
			
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				dispatchEvent(new Event(Popup.COVER_CLICKED));
			}
		}
		
		public function destroy():void
		{
			_coverFace.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			dispose();
		}
	}
}