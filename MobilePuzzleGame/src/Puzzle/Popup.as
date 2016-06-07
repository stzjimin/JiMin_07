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
		private const defaultImage:Class;
		
		public static const COVER_CLICKED:String = "coverClicked";
		
		private var _backGround:Image;
		private var _coverFace:Image;
		
		public function Popup()
		{
			super();
		}
		
		public function destroy():void
		{
			if(_coverFace)
			{
				_coverFace.removeEventListener(TouchEvent.TOUCH, onTouch);
				_coverFace.removeFromParent();
				_coverFace.dispose();
			}
			if(_backGround)
			{
				_backGround.removeFromParent();
				_backGround.dispose();
			}
			dispose();
		}
		
		protected function setCoverFace(coverWidth:Number, coverHeight:Number, coverFaceTexture:Texture = null):void
		{	
			var coverTexture:Texture;
			if(coverFaceTexture == null)
				coverTexture = Texture.fromBitmap(new defaultImage() as Bitmap);
			else
				coverTexture = coverFaceTexture;
			
			_coverFace = new Image(coverTexture);
			_coverFace.width = coverWidth;
			_coverFace.height = coverHeight;
			_coverFace.alpha = 0.5;
			_coverFace.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_coverFace);
			
			this.visible = false;
		}
		
		protected function setPopupImage(width:Number, height:Number, backGroundTexture:Texture):void
		{
			if(backGroundTexture == null)
				return;
			_backGround = new Image(backGroundTexture);
			_backGround.width = width;
			_backGround.height = height;
			_backGround.alignPivot();
			_backGround.x = _coverFace.width/2;
			_backGround.y = _coverFace.height/2;
			addChild(_backGround);
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

		public function get backGround():Image
		{
			return _backGround;
		}

		public function set backGround(value:Image):void
		{
			_backGround = value;
		}

	}
}