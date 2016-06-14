package puzzle.ingame
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import customize.ListView;
	import customize.ListViewContent;
	import customize.ThrowProps;
	
	import puzzle.loading.Resources;
	import puzzle.user.User;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class Ranking extends DisplayObjectContainer
	{
		private var _resources:Resources;
		
		private var _backGround:Image;
		private var _title:Image;
		private var _titleMessage:TextField;
		
		private var _defaultTextFormat:TextFormat;
		
		private var _listView:ListView;
		private var _leftArrow:Image;
		private var _rightArrow:Image;
		
		public function Ranking(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_defaultTextFormat = new TextFormat();
			_defaultTextFormat.bold = true;
			_defaultTextFormat.size = 20;
			
			_backGround = new Image(_resources.getSubTexture("RankingSpriteSheet.png", "PopupBackGround"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(_resources.getSubTexture("RankingSpriteSheet.png", "popupTitle"));
			_title.width = width * 0.9;
			_title.height = height * 0.15;
			_title.alignPivot();
			_title.x = width / 2;
			_title.y = (_title.height / 2) + 10;
			addChild(_title);
			
			_titleMessage = new TextField(_title.width, _title.height);
			_titleMessage.text = "랭킹";
			_titleMessage.format = _defaultTextFormat;
			_titleMessage.alignPivot();
			_titleMessage.x = _title.x;
			_titleMessage.y = _title.y;
			addChild(_titleMessage);
			
			_listView = new ListView();
			_listView.init(_resources.getSubTexture("RankingSpriteSheet.png", "PopupBackGround"), (width * 0.9), (height * 0.7), (width * 0.05));
			_listView.addEventListener(ThrowProps.LEFT_POSITION, onMoved);
			_listView.addEventListener(ThrowProps.RIGHT_POSITION, onMoved);
			_listView.addEventListener(ThrowProps.NORMAL_POSITION, onMoved);
			_listView.isFill = false;
			_listView.type = ListView.TYPE_SHIFT;
			_listView.contentWidth = width * 0.8;
			_listView.alignPivot(Align.CENTER, Align.TOP);
			_listView.x = width / 2;
			_listView.y = _title.y + (_title.height/2) + 10;
			addChild(_listView);
			
			_leftArrow = new Image(_resources.getSubTexture("RankingSpriteSheet.png", "leftArrow"));
			_leftArrow.width = width * 0.1;
			_leftArrow.height = height * 0.15;
			_leftArrow.alignPivot();
			_leftArrow.x = _listView.getBounds(this).left;
			_leftArrow.y = _listView.y + (_listView.height / 2);
			addChild(_leftArrow);
			
			_rightArrow = new Image(_resources.getSubTexture("RankingSpriteSheet.png", "rightArrow"));
			_rightArrow.width = width * 0.1;
			_rightArrow.height = height * 0.15;
			_rightArrow.alignPivot();
			_rightArrow.x = _listView.getBounds(this).right;
			_rightArrow.y = _listView.y + (_listView.height / 2);
			addChild(_rightArrow);
		}
		
		public function destroy():void
		{
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_title.removeFromParent();
			_title.dispose();
			_title = null;
			
			_titleMessage.removeFromParent();
			_titleMessage.dispose();
			_titleMessage = null;
			
			_listView.removeEventListener(ThrowProps.LEFT_POSITION, onMoved);
			_listView.removeEventListener(ThrowProps.RIGHT_POSITION, onMoved);
			_listView.removeEventListener(ThrowProps.NORMAL_POSITION, onMoved);
			_listView.destroy();
			_listView = null;
			
			_leftArrow.removeFromParent();
			_leftArrow.dispose();
			_leftArrow = null;
			
			_rightArrow.removeFromParent();
			_rightArrow.dispose();
			_rightArrow = null;
			
			dispose();
		}
		
		public function setRanking(jsonObject:Object):void
		{
			_listView.deleteAllContent();
			_listView.initViewPosition();
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.size = 20;
			
			var viewContent:ListViewContent;
			var profileImage:Image;
			var name:TextField;
			var score:TextField;
			
			var friends:Dictionary = User.getInstance().getFriends();
			
			var userIndex:int;
			for(var i:int = 0; i < jsonObject.length; i++)
			{
				if(jsonObject[i].id == User.getInstance().id || friends[jsonObject[i].id] != null)
				{
					viewContent = new ListViewContent();
					viewContent.init(_resources.getSubTexture("RankingSpriteSheet.png", "popupTitle"));
					viewContent.name = (jsonObject[i].id + " = " + jsonObject[i].score);
					if(jsonObject[i].id == User.getInstance().id)
					{
						profileImage = new Image(Texture.fromBitmap(User.getInstance().picture));
						name = new TextField(viewContent.width * 0.2, viewContent.height * 0.9, User.getInstance().name, textFormat);
						score = new TextField(viewContent.width * 0.3, viewContent.height * 0.9, jsonObject[i].score + "점", textFormat);
						userIndex = i;
					}
					else
					{
						profileImage = new Image(Texture.fromBitmap(friends[jsonObject[i].id].picture));
						name = new TextField(viewContent.width * 0.2, viewContent.height * 0.9, friends[jsonObject[i].id].name, textFormat);
						score = new TextField(viewContent.width * 0.3, viewContent.height * 0.9, jsonObject[i].score + "점", textFormat);
					}
					profileImage.width = viewContent.width * 0.3;
					profileImage.height = viewContent.height * 0.8;
					profileImage.alignPivot(Align.LEFT, Align.CENTER);
					profileImage.y = viewContent.height / 2;
					profileImage.x = viewContent.width * 0.15;
					viewContent.addChild(profileImage);
					
					name.alignPivot(Align.LEFT, Align.CENTER);
					name.y = viewContent.height / 2;
					name.x = profileImage.x + profileImage.width;
					viewContent.addChild(name);
					
					score.alignPivot(Align.LEFT, Align.CENTER);
					score.y = viewContent.height / 2;
					score.x = name.x + name.width;
					viewContent.addChild(score);
					
					_listView.addContent(viewContent);
				}
			}
			trace("userIndex = " + userIndex);
			var userRank:ListViewContent = _listView.getContent(userIndex);
//			_listView.setViewPositionX(-userRank.getBounds(_listView).left);
			_listView.moveViewToList(userRank);
			if(userIndex == 0)
			{
				_leftArrow.visible = false;
			}
			else if(userIndex == jsonObject.length-1)
			{
				_rightArrow.visible = false;
			}
			viewContent = null;
		}
		
		private function onMoved(event:Event):void
		{
			switch(event.type)
			{
				case ThrowProps.LEFT_POSITION :
					_leftArrow.visible = false;
					_rightArrow.visible = true;
					break;
				case ThrowProps.RIGHT_POSITION :
					_leftArrow.visible = true;
					_rightArrow.visible = false;
					break;
				case ThrowProps.NORMAL_POSITION :
					_leftArrow.visible = true;
					_rightArrow.visible = true;
					break;
			}
		}
	}
}