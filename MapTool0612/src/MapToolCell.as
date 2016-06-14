package
{
	import puzzle.ingame.cell.Cell;
	
	import starlingOrigin.display.Image;
	import starlingOrigin.events.Event;
	import starlingOrigin.events.Touch;
	import starlingOrigin.events.TouchEvent;
	import starlingOrigin.events.TouchPhase;
	import starlingOrigin.textures.Texture;

	public class MapToolCell extends Cell
	{	
		private var _backGround:Image;
		
		private var _versPivotX:Number;
		private var _versPivotY:Number;
		private var _originScale:Number;
		
		private var _originTexture:Texture;
		
		private var _clicked:Boolean;
		
		public function MapToolCell(backGroundTexture:Texture, width:Number, height:Number)
		{
			super();
			super.width = width;
			super.height = height;
			
			_clicked = false;
			
			_originTexture = backGroundTexture;
			
			_backGround = new Image(backGroundTexture);
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
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
		
		public function setBackGroundTexture(texture:Texture):void
		{
			_backGround.texture = texture;
		}
		
		public function setOriginTexture():void
		{
			_backGround.texture = _originTexture;
		}
		
		public function get clicked():Boolean
		{
			return _clicked;
		}
		
		public function set clicked(value:Boolean):void
		{
			_clicked = value;
		}
	}
}