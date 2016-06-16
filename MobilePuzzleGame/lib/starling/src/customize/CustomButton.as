package customize
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class CustomButton extends DisplayObjectContainer
	{
		private var _backGround:Image;
		private var _popCircle:CustomImage;
		private var _texture:Texture;
		
		private var _versPivotX:Number;
		private var _versPivotY:Number;
		private var _originScale:Number;
		
		public function CustomButton(backGroundTexture:Texture)
		{
			super();
			_backGround = new Image(backGroundTexture);
			addChild(_backGround);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function init(width:Number, height:Number):void
		{
			_backGround.width = width;
			_backGround.height = height;
		}
		
		public function addPopCircle(texture:Texture, x:Number, y:Number, width:Number, height:Number, alignPivotX:String = Align.LEFT, alignPivotY:String = Align.TOP):void
		{
			_popCircle = new CustomImage(texture, width, height);
//			_popCircle.width = width;
//			_popCircle.height = height;
			_popCircle.alignPivot(alignPivotX, alignPivotY);
			_popCircle.x = x;
			_popCircle.y = y;
			addChild(_popCircle);
		}
		
		public function destroy():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			if(_popCircle)
			{
				_popCircle.removeFromParent();
				_popCircle.destroy();
				_popCircle = null;
			}
			
			dispose();
		}
		
		public function getPopCircleText():String
		{
			if(!_popCircle)
				return null;
			
			return _popCircle.text;	
		}
		
		public function setPopCircleText(value:String):void
		{
			if(!_popCircle)
				return;
			
			_popCircle.text = value;
		}
		
		public function getPopCircleTextFormat():TextFormat
		{
			if(!_popCircle)
				return null;
			
			return _popCircle.textFormat;
		}
		
		public function setPopCircleTextFormat(value:TextFormat):void
		{
			if(!_popCircle)
				return;
			
			_popCircle.textFormat = value;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				_versPivotX = (this.width / 2) - this.pivotX;
				_versPivotY = (this.height / 2) - this.pivotY;
				
				_originScale = this.scale;
				
				this.pivotX += _versPivotX;
				this.pivotY += _versPivotY;
				this.x += _versPivotX;
				this.y += _versPivotY;
				this.scale *= 0.9;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.scale = _originScale;
				this.x -= _versPivotX;
				this.y -= _versPivotY;
				this.pivotX -= _versPivotX;
				this.pivotY -= _versPivotY;
				
				dispatchEvent(new Event(Event.TRIGGERED));
			}
		}

		public function get texture():Texture
		{
			return _texture;
		}

		public function set texture(value:Texture):void
		{
			_texture = value;
			_backGround.texture = _texture;
		}

	}
}