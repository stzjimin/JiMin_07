package
{
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.events.Event;
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
		
		public function Block(rand:int)
		{
			_attribute = new Attribute();
			
			if(rand == 0)
			{
				_blockTexture = Texture.fromBitmap(new testImage0() as Bitmap);
				_attribute.type = AttributeType.RED;
			}
			else if(rand == 1)
			{
				_blockTexture = Texture.fromBitmap(new testImage1() as Bitmap);
				_attribute.type = AttributeType.GREEN;
			}			
			else if(rand == 2)
			{
				_blockTexture = Texture.fromBitmap(new testImage2() as Bitmap);
				_attribute.type = AttributeType.BLUE;
			}
			super(_blockTexture);
			
			addEventListener(Event.TRIGGERED, onTriggered);
			addEventListener(Distroyer.DISTROY, onDistroy);
		}
		
		private function onDistroy(event:Event):void
		{
			Cell(parent).block = null;
			parent.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
			distroy();
		}
		
		private function distroy():void
		{
			removeFromParent(true);
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