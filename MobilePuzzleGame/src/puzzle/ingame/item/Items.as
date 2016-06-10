package puzzle.ingame.item
{
	import flash.display.Bitmap;
	
	import customize.CheckBox;
	
	import puzzle.loading.Resources;
	import puzzle.user.User;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Items extends DisplayObjectContainer
	{
		[Embed(source="forkSelect.png")]
		private const forkSelectImage:Class;
		
		public static const FORK_CHECK:String = "forkCheck";
		public static const FORK_EMPTY:String = "forkEmpty";
		public static const SEARCH:String = "search";
		public static const SHUFFLE:String = "shuffle";
		
		private var _resources:Resources;
		
		private var _fork:CheckBox;
		private var _shuffle:Button;
		private var _search:Button;
		
		public function Items(resources:Resources)
		{
			_resources = resources;
			
			_fork = new CheckBox(_resources.getSubTexture("IngameSprite2.png", "fork"), Texture.fromBitmap(new forkSelectImage() as Bitmap), User.getInstance().fork.toString());
			_shuffle = new Button(_resources.getSubTexture("IngameSprite2.png", "shuffle"), User.getInstance().shuffle.toString());
			_search = new Button(_resources.getSubTexture("IngameSprite2.png", "search"), User.getInstance().search.toString());
		}
		
		public function init(width:Number, height:Number):void
		{
			_search.width = width / 4;
			_search.height = height;
			_search.alignPivot();
			_search.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_search);
			
			_shuffle.width = width / 4;
			_shuffle.height = height;
			_shuffle.alignPivot();
			_shuffle.x = _fork.x + _shuffle.width + (width/8);
			_shuffle.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_shuffle);
			
			_fork.width = width / 4;
			_fork.height = height;
			_fork.alignPivot();
			_fork.x = _shuffle.x + _fork.width + (width/8);
			_fork.addEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_fork.addEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			addChild(_fork);
		}
		
		public function destroy():void
		{
			_search.removeEventListener(Event.TRIGGERED, onTriggered);
			_shuffle.removeEventListener(Event.TRIGGERED, onTriggered);
			_fork.removeEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_fork.removeEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			
			removeChildren(0, numChildren);
			
			dispose();
		}
		
		public function setEmptyFork():void
		{
			_fork.setEmpty();
		}
		
		private function onSwapCheck(event:Event):void
		{
			dispatchEvent(new Event(Items.FORK_CHECK));
		}
		
		private function onSwapEmpty(event:Event):void
		{
			dispatchEvent(new Event(Items.FORK_EMPTY));
		}
		
		private function onTriggered(event:Event):void
		{
			var target:Button = event.currentTarget as Button;
			if(target == _search)
			{
				dispatchEvent(new Event(Items.SEARCH));
			}
			else if(target == _shuffle)
			{
				dispatchEvent(new Event(Items.SHUFFLE));
			}
		}
	}
}