package Puzzle
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Items extends DisplayObjectContainer
	{
		private var _resources:Resources;
		
		private var _fork:Item;
		private var _shuffle:Item;
		private var _search:Item;
		
		public function Items(resources:Resources)
		{
			_resources = resources;
			
			_fork = new Item(_resources.getSubTexture("IngameSprite2.png", "fork"));
			_shuffle = new Item(_resources.getSubTexture("IngameSprite2.png", "shuffle"));
			_search = new Item(_resources.getSubTexture("IngameSprite2.png", "search"));
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