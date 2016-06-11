package puzzle.stageSelect
{
	import flash.display.Bitmap;
	
	import customize.CustomButton;
	
	import puzzle.loading.Resources;
	import puzzle.user.User;
	import puzzle.user.UserEvent;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class UserInfo extends DisplayObjectContainer
	{	
		[Embed(source="fork.png")]
		private const forkImage:Class;
		
		[Embed(source="search.png")]
		private const searchImage:Class;
		
		[Embed(source="shuffle.png")]
		private const shuffleImage:Class;
		
		[Embed(source="orangeCircle.png")]
		private const circleImage:Class;
		
		[Embed(source="popupTitle.png")]
		private const backGroundImage:Class;
		
		[Embed(source="heartImage.png")]
		private const heartImage:Class;
		
		public static const CLICKED_PROFILL:String = "profillClicked";
		public static const CLICKED_FORK:String = "forkClicked";
		public static const CLICKED_SHUFFLE:String = "shuffleClicked";
		public static const CLICKED_SEARCH:String = "searchClicked";
		public static const CLICKED_HEART:String = "heartClicked";
		
		private var _backGround:Image;
		private var _profilImage:Button;
		private var _heart:Button;
		private var _heartTimer:HeartTimer;
		private var _fork:CustomButton;
		private var _search:CustomButton;
		private var _shuffle:CustomButton;
		
		private var _resources:Resources;
		
		public function UserInfo(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			if(!User.getInstance().id)
			{
				trace("유저 정보가 없습니다. 확인부탁드립니다.");
				return;
			}
			
			User.getInstance().addEventListener(UserEvent.CHANGE_FORK, onChangeFork);
			User.getInstance().addEventListener(UserEvent.CHANGE_SEARCH, onChangeSearch);
			User.getInstance().addEventListener(UserEvent.CHANGE_SHUFFLE, onChangeShuffle);
			User.getInstance().addEventListener(UserEvent.CHANGE_HEART, onChangeHeart);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.size = 10;
			
			_backGround = new Image(Texture.fromBitmap(new backGroundImage() as Bitmap));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_profilImage = new Button(Texture.fromBitmap(User.getInstance().picture));
			_profilImage.height = height * 0.9;
			_profilImage.width = _profilImage.height;
			_profilImage.alignPivot(Align.LEFT);
			_profilImage.y = height / 2;
			_profilImage.x = (width * 0.05);
			_profilImage.addEventListener(Event.TRIGGERED, onClickedProfill);
			addChild(_profilImage);
			
			_fork = new CustomButton(Texture.fromBitmap(new forkImage() as Bitmap));
			_fork.init(height * 0.7, height * 0.7);
			_fork.addPopCircle(Texture.fromBitmap(new circleImage() as Bitmap), _fork.width, 0, _fork.width * 0.4, _fork.height * 0.4, Align.RIGHT, Align.TOP);
			_fork.height = height * 0.7;
			_fork.width = _fork.height;
			_fork.alignPivot(Align.LEFT);
			_fork.y = height / 2;
			_fork.x = (_profilImage.x + (_profilImage.width / 2)) + (width * 0.05) + (_fork.width / 2);
			_fork.setPopCircleText(User.getInstance().fork.toString());
			_fork.setPopCircleTextFormat(textFormat);
			_fork.addEventListener(Event.TRIGGERED, onClickedFork);
			addChild(_fork);
			
			_search = new CustomButton(Texture.fromBitmap(new forkImage() as Bitmap));
			_search.init(height * 0.7, height * 0.7);
			_search.addPopCircle(Texture.fromBitmap(new circleImage() as Bitmap), _search.width, 0, _search.width * 0.4, _search.height * 0.4, Align.RIGHT, Align.TOP);
			_search.height = height * 0.7;
			_search.width = _search.height;
			_search.alignPivot(Align.LEFT);
			_search.y = height / 2;
			_search.x = (_fork.x + (_fork.width / 2)) + (width * 0.05) + (_search.width / 2);
			_search.setPopCircleText(User.getInstance().search.toString());
			_search.setPopCircleTextFormat(textFormat);
			_search.addEventListener(Event.TRIGGERED, onClickedSearch);
			addChild(_search);
			
			_shuffle = new CustomButton(Texture.fromBitmap(new forkImage() as Bitmap));
			_shuffle.init(height * 0.7, height * 0.7);
			_shuffle.addPopCircle(Texture.fromBitmap(new circleImage() as Bitmap), _shuffle.width, 0, _shuffle.width * 0.4, _shuffle.height * 0.4, Align.RIGHT, Align.TOP);
			_shuffle.height = height * 0.7;
			_shuffle.width = _shuffle.height;
			_shuffle.alignPivot(Align.LEFT);
			_shuffle.y = height / 2;
			_shuffle.x = (_search.x + (_search.width / 2)) + (width * 0.05) + (_shuffle.width / 2);
			_shuffle.setPopCircleText(User.getInstance().shuffle.toString());
			_shuffle.setPopCircleTextFormat(textFormat);
			_shuffle.addEventListener(Event.TRIGGERED, onClickedShuffle);
			addChild(_shuffle);
			
			var heartTextFormat:TextFormat = new TextFormat();
			heartTextFormat.bold = true;
			heartTextFormat.size = 20;
			
			_heart = new Button(Texture.fromBitmap(new heartImage() as Bitmap), User.getInstance().heart.toString());
			_heart.textFormat = heartTextFormat;
			_heart.height = height * 0.7;
			_heart.width = _heart.height;
			_heart.alignPivot(Align.LEFT);
			_heart.y = height / 2;
			_heart.x = (_shuffle.x + (_shuffle.width / 2)) + (width * 0.05) + (_heart.width / 2);
//			_heart.x = (_profilImage.x + (_profilImage.width / 2)) + (width * 0.05) + (_heart.width / 2);
			_heart.addEventListener(Event.TRIGGERED, onClickedHeart);
			addChild(_heart);
			
			var timerTextFormat:TextFormat = new TextFormat();
			timerTextFormat.bold = true;
			timerTextFormat.size = 20;
			timerTextFormat.horizontalAlign = Align.LEFT;
			
//			_heartTimer = new HeartTimer(width * 0.1, height * 0.9, "", timerTextFormat);
			_heartTimer = User.getInstance().heartTimer;
			_heartTimer.width = width * 0.1;
			_heartTimer.height = height * 0.9;
//			_heartTimer.init(15);
			_heartTimer.alignPivot(Align.LEFT);
			_heartTimer.y = height / 2;
			_heartTimer.x = (_heart.x + (_heart.width / 2)) + (width * 0.02) + (_heartTimer.width / 2);
			addChild(_heartTimer);
		}
		
		public function destroy():void
		{
			User.getInstance().removeEventListener(UserEvent.CHANGE_FORK, onChangeFork);
			User.getInstance().removeEventListener(UserEvent.CHANGE_SEARCH, onChangeSearch);
			User.getInstance().removeEventListener(UserEvent.CHANGE_SHUFFLE, onChangeShuffle);
			User.getInstance().removeEventListener(UserEvent.CHANGE_HEART, onChangeHeart);
			
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_profilImage.removeEventListener(Event.TRIGGERED, onClickedProfill);
			_profilImage.removeFromParent();
			_profilImage.dispose();
			_profilImage = null;
			
			_fork.removeEventListener(Event.TRIGGERED, onClickedFork);
			_fork.removeFromParent();
			_fork.destroy();
			_fork = null;
			
			_search.removeEventListener(Event.TRIGGERED, onClickedSearch);
			_search.removeFromParent();
			_search.destroy();
			_search = null;
			
			_shuffle.removeEventListener(Event.TRIGGERED, onClickedShuffle);
			_shuffle.removeFromParent();
			_shuffle.destroy();
			_shuffle = null;
			
			_heart.removeEventListener(Event.TRIGGERED, onClickedHeart);
			_heart.removeFromParent();
			_heart.dispose();
			_heart = null;
			
			_heartTimer.removeFromParent();
			_heartTimer.destroy();
			_heartTimer = null;
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
		
		private function onChangeHeart(event:UserEvent):void
		{
			trace("heartChange");
			_heart.text = User.getInstance().heart.toString();
		}
		
		private function onClickedProfill(event:Event):void
		{
			dispatchEvent(new Event(UserInfo.CLICKED_PROFILL));
		}
		
		private function onClickedFork(event:Event):void
		{
			dispatchEvent(new Event(UserInfo.CLICKED_FORK));
		}
		
		private function onClickedSearch(evemt:Event):void
		{
			dispatchEvent(new Event(UserInfo.CLICKED_SEARCH));
		}
		
		private function onClickedShuffle(event:Event):void
		{
			dispatchEvent(new Event(UserInfo.CLICKED_SHUFFLE));
		}
		
		private function onClickedHeart(event:Event):void
		{
			dispatchEvent(new Event(UserInfo.CLICKED_HEART));
		}
	}
}