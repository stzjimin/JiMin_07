package
{
	import flash.utils.Dictionary;
	
	import starlingOrigin.display.DisplayObjectContainer;
	import starlingOrigin.display.Image;
	import starlingOrigin.display.Quad;
	import starlingOrigin.events.Event;
	import starlingOrigin.events.Touch;
	import starlingOrigin.events.TouchEvent;
	import starlingOrigin.events.TouchPhase;
	import starlingOrigin.textures.Texture;

	public class MapToolCell extends DisplayObjectContainer
	{	
		public static const WIDTH_SIZE:Number = 45;
		public static const HEIGHT_SIZE:Number = 60;
		
		private var _neigbor:Dictionary;
//		private var _block:Block;
		
		private var _row:int;
		private var _column:int;
		
		private var _color:Quad;
		
		private var _backGround:Image;
		
		private var _versPivotX:Number;
		private var _versPivotY:Number;
		private var _originScale:Number;
		
		private var _originTexture:Texture;
		
		private var _clicked:Boolean;
		
		public function MapToolCell(backGroundTexture:Texture, width:Number, height:Number)
		{
			super();
			_clicked = false;
			
			_originTexture = backGroundTexture;
			
			_backGround = new Image(backGroundTexture);
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function init():void
		{
			_neigbor = new Dictionary();
			_color = new Quad(this.width, this.height, 0x0);
			_color.x = 0;
			_color.y = 0;
			_color.visible = false;
			addChild(_color);
		}
		
		public function showColor():void
		{
			_color.visible = true;
		}
		
		public function offColor():void
		{
			_color.visible = false;
		}
		
		public function get neigbor():Dictionary
		{
			return _neigbor;
		}
		
		public function set neigbor(value:Dictionary):void
		{
			_neigbor = value;
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

		public function get row():int
		{
			return _row;
		}

		public function set row(value:int):void
		{
			_row = value;
		}

		public function get column():int
		{
			return _column;
		}

		public function set column(value:int):void
		{
			_column = value;
		}


	}
}