package puzzle.ingame
{
	import flash.display.Bitmap;
	
	import customize.ListView;
	import customize.ListViewContent;
	
	import puzzle.loading.Resources;
	import puzzle.user.User;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class RankingPopup extends DisplayObjectContainer
	{
		[Embed(source="PopupBackGround.png")]
		private const backgroundImage:Class;
		
		[Embed(source="popupTitle.png")]
		private const titleImage:Class;
		
		private var _resources:Resources;
		
		private var _backGround:Image;
		private var _title:Image;
		
		private var _listView:ListView;
		
		public function RankingPopup(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_backGround = new Image(Texture.fromBitmap(new backgroundImage() as Bitmap));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(Texture.fromBitmap(new titleImage() as Bitmap));
			_title.width = width * 0.9;
			_title.height = height * 0.1;
			_title.alignPivot();
			_title.x = width / 2;
			_title.y = (_title.height / 2) + 10;
			addChild(_title);
			
			_listView = new ListView();
			_listView.init(Texture.fromBitmap(new backgroundImage() as Bitmap), (width * 0.9), (height * 0.8), 10);
			_listView.isFill = false;
			_listView.type = ListView.TYPE_DOWN;
			_listView.contentHeight = height / 7;
			_listView.alignPivot(Align.CENTER, Align.TOP);
			_listView.x = width / 2;
			_listView.y = _title.y + (_title.height/2) + 10;
			addChild(_listView);
		}
		
		public function destroy():void
		{
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_title.removeFromParent();
			_title.dispose();
			_title = null;
			
			_listView.destroy();
			_listView = null;
			
			dispose();
		}
		
		public function setRanking(jsonObject:Object):void
		{
			_listView.deleteAllContent();
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.size = 20;
			
			var viewContent:ListViewContent;
			var profileImage:Image;
			var name:TextField;
			var score:TextField;
			for(var i:int = 0; i < jsonObject.length; i++)
			{
				if(jsonObject[i].id == User.getInstance().id || FacebookUser.getInstance().friends[jsonObject[i].id] != null)
				{
					viewContent = new ListViewContent();
					viewContent.init(Texture.fromBitmap(new titleImage() as Bitmap));
					viewContent.name = (jsonObject[i].id + " = " + jsonObject[i].score);
					if(jsonObject[i].id == User.getInstance().id)
					{
						profileImage = new Image(Texture.fromBitmap(User.getInstance().picture));
						name = new TextField(viewContent.width * 0.3, viewContent.height * 0.9, User.getInstance().name, textFormat);
						score = new TextField(viewContent.width * 0.5, viewContent.height * 0.9, jsonObject[i].score, textFormat);
					}
					else
					{
						profileImage = new Image(Texture.fromBitmap(FacebookUser.getInstance().friends[jsonObject[i].id].picture));
						name = new TextField(viewContent.width * 0.3, viewContent.height * 0.9, FacebookUser.getInstance().friends[jsonObject[i].id].name, textFormat);
						score = new TextField(viewContent.width * 0.5, viewContent.height * 0.9, jsonObject[i].score, textFormat);
					}
					profileImage.width = viewContent.width * 0.2;
					profileImage.height = viewContent.height * 0.9;
					profileImage.alignPivot(Align.LEFT, Align.CENTER);
					profileImage.y = viewContent.height / 2;
					profileImage.x = 10;
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
			viewContent = null;
		}
	}
}