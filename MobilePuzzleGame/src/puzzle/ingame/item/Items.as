package puzzle.ingame.item
{
	import flash.display.Bitmap;
	
	import customize.CheckBox;
	import customize.CustomButton;
	
	import puzzle.loading.Resources;
	import puzzle.user.User;
	import puzzle.user.UserEvent;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class Items extends DisplayObjectContainer
	{
		[Embed(source="orangeCircle.png")]
		private const circleImage:Class;
		
		[Embed(source="forkSelect.png")]
		private const forkSelectImage:Class;
		
		public static const FORK_CHECK:String = "forkCheck";
		public static const FORK_EMPTY:String = "forkEmpty";
		public static const CLICKED_SEARCH:String = "searchClicked";
		public static const CLICKED_SHUFFLE:String = "shuffleClicked";
		
		private var _resources:Resources;
		
		private var _fork:CheckBox;
		private var _shuffle:CustomButton;
		private var _search:CustomButton;
		
		public function Items(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{	
			User.getInstance().addEventListener(UserEvent.CHANGE_FORK, onChangeFork);
			User.getInstance().addEventListener(UserEvent.CHANGE_SEARCH, onChangeSearch);
			User.getInstance().addEventListener(UserEvent.CHANGE_SHUFFLE, onChangeShuffle);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.size = 10;
			
			_search = new CustomButton(_resources.getSubTexture("IngameSprite2.png", "search"));
			_search.init(width / 4, height);
			_search.name = ItemType.SEARCH;
			_search.addPopCircle(Texture.fromBitmap(new circleImage() as Bitmap), _search.width, 0, _search.width * 0.4, _search.height * 0.4, Align.RIGHT, Align.TOP);
			_search.width = width / 4;
			_search.height = height;
			_search.alignPivot(Align.LEFT);
			_search.x = -(_search.width / 2);
			_search.setPopCircleText(User.getInstance().search.toString());
			_search.setPopCircleTextFormat(textFormat);
			_search.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_search);
			
			_shuffle = new CustomButton(_resources.getSubTexture("IngameSprite2.png", "shuffle"));
			_shuffle.init(width / 4, height);
			_shuffle.name = ItemType.SHUFFLE;
			_shuffle.addPopCircle(Texture.fromBitmap(new circleImage() as Bitmap), _shuffle.width, 0, _shuffle.width * 0.4, _shuffle.height * 0.4, Align.RIGHT, Align.TOP);
			_shuffle.width = width / 4;
			_shuffle.height = height;
			_shuffle.alignPivot(Align.LEFT);
			_shuffle.x = _search.x + _search.width + (width/8);
			_shuffle.setPopCircleText(User.getInstance().shuffle.toString());
			_shuffle.setPopCircleTextFormat(textFormat);
			_shuffle.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_shuffle);
			
			_fork = new CheckBox(_resources.getSubTexture("IngameSprite2.png", "fork"), Texture.fromBitmap(new forkSelectImage() as Bitmap));
			_fork.init(width / 4, height);
			_fork.name = ItemType.FORK;
			_fork.addPopCircle(Texture.fromBitmap(new circleImage() as Bitmap), _fork.width, 0, _fork.width * 0.4, _fork.height * 0.4, Align.RIGHT, Align.TOP);
			_fork.width = width / 4;
			_fork.height = height;
			_fork.alignPivot(Align.LEFT);
			_fork.x = _shuffle.x + _shuffle.width + (width/8);
			_fork.setPopCircleText(User.getInstance().fork.toString());
			_fork.setPopCircleTextFormat(textFormat);
			_fork.addEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_fork.addEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			addChild(_fork);
			
//			if(User.getInstance().fork <= 0)
//				_fork.touchable = false;
//			if(User.getInstance().search <= 0)
//				_search.touchable = false;
//			if(User.getInstance().shuffle <= 0)
//				_shuffle.touchable = false;
		}
		
		public function destroy():void
		{
			User.getInstance().removeEventListener(UserEvent.CHANGE_FORK, onChangeFork);
			User.getInstance().removeEventListener(UserEvent.CHANGE_SEARCH, onChangeSearch);
			User.getInstance().removeEventListener(UserEvent.CHANGE_SHUFFLE, onChangeShuffle);
			
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
//			if(User.getInstance().fork <= 0)
//				_fork.touchable = false;
		}
		
		private function onChangeFork(event:UserEvent):void
		{
			trace("forkChange");
			_fork.setPopCircleText(User.getInstance().fork.toString());
		}
		
		private function onChangeSearch(event:UserEvent):void
		{
			trace("searchChange");
			_search.setPopCircleText(User.getInstance().search.toString());
		}
		
		private function onChangeShuffle(event:UserEvent):void
		{
			trace("shuffleChange");
			_shuffle.setPopCircleText(User.getInstance().shuffle.toString());
		}
		
		private function onSwapCheck(event:Event):void
		{
//			if(User.getInstance().fork <= 0)
//			{
//				User.getInstance().fork += 1;
//				setEmptyFork();
//				return;
//			}
			dispatchEvent(new Event(Items.FORK_CHECK, false, _fork.name));
		}
		
		private function onSwapEmpty(event:Event):void
		{
			dispatchEvent(new Event(Items.FORK_EMPTY));
		}
		
		private function onTriggered(event:Event):void
		{
			var target:CustomButton = event.currentTarget as CustomButton;
			if(target == _search)
			{
//				if(User.getInstance().search <= 0)
//				{
//					User.getInstance().search += 1;
//					return;
//				}
				dispatchEvent(new Event(Items.CLICKED_SEARCH, false, _search.name));
			}
			else if(target == _shuffle)
			{
//				if(User.getInstance().shuffle <= 0)
//				{
//					User.getInstance().shuffle += 1;
//					return;
//				}
				dispatchEvent(new Event(Items.CLICKED_SHUFFLE, false, _shuffle.name));
			}
		}
	}
}