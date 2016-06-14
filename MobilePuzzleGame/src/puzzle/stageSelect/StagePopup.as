package puzzle.stageSelect
{
	import flash.display.Bitmap;
	
	import puzzle.ingame.Ranking;
	import puzzle.loading.Resources;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class StagePopup extends DisplayObjectContainer
	{	
		public static const START_CLICK:String = "clickedStart";
		public static const CLOSE_CLICK:String = "clickedClose";
		
		private var _backGround:Image;
		private var _title:Image;
		private var _titleMessage:TextField;
		
		private var _startButton:Button;
		private var _closeButton:Button;
		
		private var _ranking:Ranking;
		
		private var _resources:Resources;
		
		public function StagePopup(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.size = 20;
			
			_backGround = new Image(_resources.getSubTexture("StagePopupSpriteSheet.png", "PopupBackGround"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(_resources.getSubTexture("StagePopupSpriteSheet.png", "popupTitle"));
			_title.width = width * 0.9;
			_title.height = height * 0.1;
			_title.alignPivot(Align.CENTER, Align.TOP);
			_title.x = width / 2;
			_title.y = height * 0.05;
			addChild(_title);
			
			_titleMessage = new TextField(width * 0.9, height * 0.1);
			_titleMessage.format = textFormat;
			_titleMessage.alignPivot(Align.CENTER, Align.TOP);
			_titleMessage.x = width / 2;
			_titleMessage.y = height * 0.05;
			addChild(_titleMessage);
			
			_ranking = new Ranking(_resources);
			_ranking.init(width * 0.9, height * 0.5);
			_ranking.alignPivot(Align.CENTER, Align.TOP);
			_ranking.x = width / 2;
			_ranking.y = _title.y + _title.height + (height * 0.05);
			addChild(_ranking);
			
			_startButton = new Button(_resources.getSubTexture("StagePopupSpriteSheet.png", "popupTitle"), "START");
			_startButton.textFormat = textFormat;
			_startButton.width = width * 0.4;
			_startButton.height = height * 0.2;
			_startButton.alignPivot(Align.LEFT, Align.TOP);
			_startButton.x = width * 0.05;
			_startButton.y = _ranking.y + _ranking.height + (height * 0.05);
			_startButton.addEventListener(Event.TRIGGERED, onClickedStartButton);
			addChild(_startButton);
			
			_closeButton = new Button(_resources.getSubTexture("StagePopupSpriteSheet.png", "popupTitle"), "CLOSE");
			_closeButton.textFormat = textFormat;
			_closeButton.width = width * 0.4;
			_closeButton.height = height * 0.2;
			_closeButton.alignPivot(Align.LEFT, Align.TOP);
			_closeButton.x = _startButton.x + _startButton.width + (width * 0.1);
			_closeButton.y = _startButton.y;
			_closeButton.addEventListener(Event.TRIGGERED, onClickedCloseButton);
			addChild(_closeButton);
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
			
			_ranking.removeFromParent();
			_ranking.destroy();
			_ranking = null;
			
			_startButton.removeEventListener(Event.TRIGGERED, onClickedStartButton);
			_startButton.removeFromParent();
			_startButton.dispose();
			_startButton = null;
			
			_closeButton.removeEventListener(Event.TRIGGERED, onClickedCloseButton);
			_closeButton.removeFromParent();
			_closeButton.dispose();
			_closeButton = null;
			
			dispose();
		}
		
		public function setTitleMessage(message:String):void
		{
			_titleMessage.text = "Stage " + message;
		}
		
		public function setLanking(jsonObject:Object):void
		{
			_ranking.setRanking(jsonObject);
		}
		
		private function onClickedStartButton(event:Event):void
		{
			dispatchEvent(new Event(StagePopup.START_CLICK));
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			dispatchEvent(new Event(StagePopup.CLOSE_CLICK));	
		}
	}
}