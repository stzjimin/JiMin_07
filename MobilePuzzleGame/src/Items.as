package
{
	import flash.display.Bitmap;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Items extends DisplayObjectContainer
	{
		[Embed(source="fork.png")]
		private const forkImage:Class;
		
		[Embed(source="search.png")]
		private const searchImage:Class;
		
		[Embed(source="shuffle.png")]
		private const shuffleImage:Class;
		
		private var _fork:Item;
		private var _shuffle:Item;
		private var _search:Item;
		
		public function Items()
		{
			_fork = new Item(Texture.fromBitmap(new forkImage() as Bitmap));
			_shuffle = new Item(Texture.fromBitmap(new shuffleImage() as Bitmap));
			_search = new Item(Texture.fromBitmap(new searchImage() as Bitmap));
		}
		
		public function init(width:Number, height:Number):void
		{
			_search.init(width / 4, height);
			_search.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_search);
			
			_shuffle.init(width / 4, height);
			_shuffle.x = _fork.x + _shuffle.width + (width/8);
			_shuffle.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_shuffle);
			
			_fork.init(width / 4, height);
			_fork.x = _shuffle.x + _fork.width + (width/8);
			_fork.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_fork);
		}
		
		public function destroy():void
		{
			_search.removeEventListener(Event.TRIGGERED, onTriggered);
			_shuffle.removeEventListener(Event.TRIGGERED, onTriggered);
			_fork.removeEventListener(Event.TRIGGERED, onTriggered);
			
			removeChildren(0, numChildren);
			
			dispose();
		}
		
		private function onTriggered(event:Event):void
		{
			var target:Item = event.currentTarget as Item;
			if(target == _search)
			{
				dispatchEvent(new Event(Item.SEARCH));
			}
			else if(target == _shuffle)
			{
				dispatchEvent(new Event(Item.SHUFFLE));
			}
			else if(target == _fork)
			{
				dispatchEvent(new Event(Item.FORK));
			}
		}
	}
}