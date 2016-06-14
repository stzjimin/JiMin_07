package puzzle.attend
{
	import flash.display.Bitmap;
	
	import puzzle.item.ItemType;
	import puzzle.loading.Resources;
	import puzzle.user.User;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class Attend extends DisplayObjectContainer
	{
		private var _backGround:Image;
		private var _title:Image;
		private var _titleMessage:TextField;
		
		private var _days:Vector.<Day>;
		private var _attendPresents:AttendPresent;
		
		private var _resources:Resources;
		
		public function Attend(resources:Resources)
		{
			_resources = resources;
			_attendPresents = new AttendPresent();
			_days = new Vector.<Day>();
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_backGround = new Image(_resources.getSubTexture("AttendSpriteSheet.png", "PopupBackGround"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(_resources.getSubTexture("AttendSpriteSheet.png", "popupTitle"));
			_title.width = width * 0.9;
			_title.height = height * 0.1;
			_title.alignPivot(Align.CENTER, Align.TOP);
			_title.x = width / 2;
			_title.y = height * 0.05;
			addChild(_title);
			
			_titleMessage = new TextField(width * 0.9, height * 0.1, "출석");
			_titleMessage.format.bold = true;
			_titleMessage.format.size = 20;
			_titleMessage.alignPivot(Align.CENTER, Align.TOP);
			_titleMessage.x = width / 2;
			_titleMessage.y = height * 0.05;
			addChild(_titleMessage);
			
			var presentJson:Object = _attendPresents.getPresents();
			var dayWidth:Number;
			var dayHeight:Number;
			
			if(presentJson.length >= 7)
			{
				dayWidth = (width * 0.9) / 7;
				dayHeight = (height * 0.75) / (presentJson.length / 7);
			}
			else
			{
				dayWidth = (width * 0.9) / presentJson.length;
				dayHeight = (height * 0.75);
			}
			
			trace("presentJson.length = " + presentJson.length);
			
			var day:Day;
			for(var i:int = 0; i < presentJson.length; i++)
			{
				day = new Day(dayWidth, dayHeight);
				day.x = (width * 0.05) + dayWidth * i;
				day.y = _title.y + _title.height + (height * 0.05) + (dayHeight * int(presentJson.length / 7));
				for(var j:int = 0; j < presentJson[i].length; j++)
				{
					day.addPresent(presentJson[i][j] as String);
				}
				if(day.getPresentLength() == 1)
				{
					switch(day.getPresent(0))
					{
						case ItemType.FORK :
							day.addItemImage(_resources.getSubTexture("UserInfoSpriteSheet.png", "fork"));
							break;
						case ItemType.SEARCH :
							day.addItemImage(_resources.getSubTexture("UserInfoSpriteSheet.png", "search"));
							break;
						case ItemType.SHUFFLE :
							day.addItemImage(_resources.getSubTexture("UserInfoSpriteSheet.png", "shuffle"));
							break;
					}
//					day.addItemImage(
				}
				else
				{
					day.addItemImage(_resources.getSubTexture("AttendSpriteSheet.png", "giftBox"));
				}
				
				if((i+1) <= User.getInstance().attendCount)
				{
					day.addMark(_resources.getSubTexture("UserInfoSpriteSheet.png", "mark"));
				}
				
				_days.push(day);
				addChild(day);
			}
		}
		
		public function destroy():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_title.removeFromParent();
			_title.dispose();
			_title = null;
			
			_titleMessage.removeFromParent();
			_titleMessage.dispose();
			_titleMessage = null;
			
			for(var i:int = 0; i < _days.length; i++)
			{
				_days[i].removeFromParent();	
				_days[i].destroy();
			}
			_days.splice(0, _days.length);
			_days = null;
			
			dispose();
		}
		
		public function attend():void
		{
			var attendDayIndex:int = User.getInstance().attendCount % 4;
			_days[attendDayIndex].showMarking(_resources.getSubTexture("UserInfoSpriteSheet.png", "mark"));
			
			for(var i:int = 0; i < _days[attendDayIndex].getPresentLength(); i++)
				User.getInstance().addItem(_days[attendDayIndex].getPresent(i), 1);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				dispatchEvent(new Event(Event.TRIGGERED));
			}
		}
	}
}