package
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Block extends Button
	{
		[Embed(source="19.png")]
		private const testImage0:Class;
		[Embed(source="iu3.jpg")]
		private const testImage1:Class;
		[Embed(source="hulk.jpg")]
		private const testImage2:Class;
		
		private var _blockTexture:Texture;
		private var _attribute:Attribute;
		
		private var _distroyed:Boolean = false;
		
		private var _clicked:Boolean;
		
		public function Block(type:String)
		{
			_attribute = new Attribute();
			_clicked = false;
			
			if(type == AttributeType.RED)
			{
				_blockTexture = Texture.fromBitmap(new testImage0() as Bitmap);
				_attribute.type = AttributeType.RED;
				this.name = "19";
			}
			else if(type == AttributeType.GREEN)
			{
				_blockTexture = Texture.fromBitmap(new testImage1() as Bitmap);
				_attribute.type = AttributeType.GREEN;
				this.name = "iu";
			}			
			else if(type == AttributeType.BLUE)
			{
				_blockTexture = Texture.fromBitmap(new testImage2() as Bitmap);
				_attribute.type = AttributeType.BLUE;
				this.name = "hulk";
			}
			super(_blockTexture);
			
			addEventListener(Event.TRIGGERED, onTriggered);
//			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function init():void
		{
			this.pivotX = this.width/2;
			this.pivotY = this.height/2;
			this.x = this.width/2;
			this.y = this.height/2;
		}
		
		public function onTriggered():void
		{
			_clicked = !_clicked;
			if(_clicked)
			{
				this.scale = 0.9;
				parent.dispatchEvent(new Event(CheckEvent.ADD_PREV));
			}
			else
			{
				parent.dispatchEvent(new Event(CheckEvent.OUT_CHECKER));
//				this.scale = 1.0;
			}
		}
		
		public function pullPrev():void
		{
			_clicked = false;
			this.scale = 1.0;
		}
		
//		public function init():void
//		{
//			this.pivotX = this.width/2;
//			this.pivotY = this.height/2;
//		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				_clicked = true;
			}
			
//			if(touch.phase == TouchPhase.BEGAN)
//			{
//				this.x = 0;
//				this.y = 0;
//				_prevPoint = touch.getLocation(stage);
//				_clicked = true;
//			}
//			else if(touch.phase == TouchPhase.MOVED && _clicked)
//			{
//				
//			}
//			else if(touch.phase == TouchPhase.ENDED)
//			{	
//				var movementPoint:Point = _prevPoint.subtract(touch.getLocation(stage));
//				if(Math.abs(movementPoint.x) > Math.abs(movementPoint.y))
//				{
//					if(movementPoint.x < 0)
//						Cell(parent).dispatchEvent(new Event(SwapType.MOVE_MOTION, false, NeigborType.RIGHT));
//					else
//						Cell(parent).dispatchEvent(new Event(SwapType.MOVE_MOTION, false, NeigborType.LEFT));
//				}
//				else
//				{
//					if(movementPoint.y < 0)
//						Cell(parent).dispatchEvent(new Event(SwapType.MOVE_MOTION, false, NeigborType.BOTTOM));
//					else
//						Cell(parent).dispatchEvent(new Event(SwapType.MOVE_MOTION, false, NeigborType.TOP));
//				}
//				_clicked = false;
//			}
		}
		
		public function distroy():void
		{
			var parent:Cell = Cell(this.parent);
			parent.block = null;
			removeFromParent(true);
			
			dispose();
		}

		public function get distroyed():Boolean
		{
			return _distroyed;
		}

		public function set distroyed(value:Boolean):void
		{
			_distroyed = value;
		}

		public function get attribute():Attribute
		{
			return _attribute;
		}

		public function set attribute(value:Attribute):void
		{
			_attribute = value;
		}


	}
}