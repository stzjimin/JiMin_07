package customize
{
	import flash.display.Bitmap;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class PopupFrame extends DisplayObjectContainer
	{
		[Embed(source="alpha.png")]
		private const defaultImage:Class;
		
		public static const COVER_CLICKED:String = "coverClicked";
		
		private var _popUp:DisplayObjectContainer;
		private var _coverFace:Image;
		
		public function PopupFrame(coverWidth:Number, coverHeight:Number, coverFaceTexture:Texture = null)
		{
			super();
			setCoverFace(coverWidth, coverHeight, coverFaceTexture);
			this.visible = false;
		}
		
		public function destroy():void
		{
			if(_coverFace)
			{
				_coverFace.removeEventListener(TouchEvent.TOUCH, onTouch);
				_coverFace.removeFromParent();
				_coverFace.dispose();
				_coverFace = null;
			}
			dispose();
		}
		
		public function setCoverFace(coverWidth:Number, coverHeight:Number, coverFaceTexture:Texture = null):void
		{	
			var coverTexture:Texture;
			if(coverFaceTexture == null)
				coverTexture = Texture.fromBitmap(new defaultImage() as Bitmap);
			else
				coverTexture = coverFaceTexture;
			
			if(_coverFace != null)
			{
				_coverFace.removeEventListener(TouchEvent.TOUCH, onTouch);
				_coverFace.removeFromParent();
				_coverFace.dispose();
			}
			
			_coverFace = new Image(coverTexture);
			_coverFace.width = coverWidth;
			_coverFace.height = coverHeight;
			_coverFace.alpha = 0.5;
			_coverFace.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_coverFace);
		}
		
		public function setPopup(popUp:DisplayObjectContainer, width:Number = 0, height:Number = 0):void
		{
			_popUp = popUp;
			if(width != 0)
				_popUp.width = width;
			if(height != 0)
				_popUp.height = height;
			_popUp.alignPivot();
			_popUp.x = _coverFace.width/2;
			_popUp.y = _coverFace.height/2;
			addChild(_popUp);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_coverFace);
			
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				dispatchEvent(new Event(PopupFrame.COVER_CLICKED));
			}
		}
	}
}