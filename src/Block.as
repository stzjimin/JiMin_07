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

	public class Block extends Image
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
		
		private var _dragFlag:int = 0;
		private var _originParentIndex:int;
		private var _clicked:Boolean;
		
		public function Block(rand:int)
		{
			_attribute = new Attribute();
			_clicked = false;
			
			if(rand == 0)
			{
				_blockTexture = Texture.fromBitmap(new testImage0() as Bitmap);
				_attribute.type = AttributeType.RED;
				this.name = "19";
			}
			else if(rand == 1)
			{
				_blockTexture = Texture.fromBitmap(new testImage1() as Bitmap);
				_attribute.type = AttributeType.GREEN;
				this.name = "iu";
			}			
			else if(rand == 2)
			{
				_blockTexture = Texture.fromBitmap(new testImage2() as Bitmap);
				_attribute.type = AttributeType.BLUE;
				this.name = "hulk";
			}
			super(_blockTexture);
			
//			addEventListener(Event.TRIGGERED, onTriggered);
			addEventListener(Distroyer.DISTROY, onDistroy);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				this.x = 0;
				this.y = 0;
				_originParentIndex = parent.parent.getChildIndex(parent);
				parent.parent.setChildIndex(parent, parent.parent.numChildren);
				_clicked = true;
			}
			else if(touch.phase == TouchPhase.MOVED && _clicked)
			{
				var moveMent:Point = touch.getMovement(stage);
				
				if(_dragFlag == 0)
				{
					this.x += moveMent.x;
					this.y += moveMent.y;
					
					if(Math.abs(this.x) >= 5)
					{
						this.y = 0;
						_dragFlag = 1;
					}
					if(Math.abs(this.y) >= 5)
					{
						this.x = 0;
						_dragFlag = -1;
					}
				}
				else if(_dragFlag == 1)
				{
					if(Math.abs(this.x) < Field.CELL_SIZE)
						this.x += moveMent.x;
				}
				else if(_dragFlag == -1)
				{
					if(Math.abs(this.y) < Field.CELL_SIZE)
						this.y += moveMent.y;
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				if(this.x >= Field.CELL_SIZE*2/3)
				{
					Cell(parent).dispatchEvent(new Event(SwapType.CONTAINS, false, NeigborType.RIGHT));
				}
				else if(-this.x >= Field.CELL_SIZE*2/3)
				{
					Cell(parent).dispatchEvent(new Event(SwapType.CONTAINS, false, NeigborType.LEFT));
				}
				else if(this.y >= Field.CELL_SIZE*2/3)
				{
					Cell(parent).dispatchEvent(new Event(SwapType.CONTAINS, false, NeigborType.BOTTOM));
				}
				else if(-this.y >= Field.CELL_SIZE*2/3)
				{
					Cell(parent).dispatchEvent(new Event(SwapType.CONTAINS, false, NeigborType.TOP));
				}
				this.x = 0;
				this.y = 0;
				_dragFlag = 0;
				parent.parent.setChildIndex(parent, _originParentIndex);
				_clicked = false;
			}
		}
		
		private function onDistroy(event:Event):void
		{
			var parent:Cell = Cell(this.parent);
			parent.block = null;
			parent.blanked = true;
			removeFromParent(true);
//			parent.dispatchEvent(new Event(SwapType.DISTORYED_BLOCK));
//			parent.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
			distroy();
		}
		
		private function distroy():void
		{
//			removeFromParent(true);
			removeEventListener(Distroyer.DISTROY, onDistroy);
			removeEventListener(Event.TRIGGERED, onTriggered);
			dispose();
		}
		
		public function onTriggered():void
		{
			if(this.parent != null)
				this.parent.dispatchEvent(new Event("blockTriggered"));
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