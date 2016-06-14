package puzzle.ingame
{
	import flash.display.Bitmap;
	
	import puzzle.loading.Resources;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class ResultPopup extends DisplayObjectContainer
	{	
		public static const CLICKED_BACK:String = "clickBack";
		public static const CLICKED_NEXT:String = "clickNext";
		public static const CLICKED_RESTART:String = "clickRestar";
		
		private var _resources:Resources;
		
		private var _backGround:Image;
		private var _title:Image;
		private var _titleMessage:TextField;
		
		private var _score:ResultContent;
		private var _record:ResultContent;
		
		private var _restartButton:Button;
		private var _nextStageButton:Button;
		private var _backButton:Button;
		
		private var _defaultTextFormat:TextFormat;
		
		private var _ranking:Ranking;
		
		public function ResultPopup(resources:Resources)
		{
			_resources = resources;
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_defaultTextFormat = new TextFormat();
			_defaultTextFormat.bold = true;
			_defaultTextFormat.size = 20;
			
			_backGround = new Image(_resources.getSubTexture("ResultSpriteSheet.png", "PopupBackGround"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(_resources.getSubTexture("ResultSpriteSheet.png", "popupTitle"));
			_title.width = width * 0.9;
			_title.height = height * 0.1;
			_title.alignPivot();
			_title.x = width / 2;
			_title.y = (_title.height / 2) + 10;
			addChild(_title);
			
			_titleMessage = new TextField(width * 0.8, height * 0.1);
			_titleMessage.text = "테스트입니다";
			_titleMessage.format = _defaultTextFormat;
			_titleMessage.alignPivot();
			_titleMessage.x = _title.x;
			_titleMessage.y = _title.y;
			addChild(_titleMessage);
			
			_score = new ResultContent(_resources);
			_score.init(width * 0.9, height * 0.1, _defaultTextFormat);
			_score.setHead("Score");
			_score.alignPivot();
			_score.x = width / 2;
			_score.y = _title.y + (_title.height / 2) + (_score.height / 2) + (height * 0.03);
			addChild(_score);
			
			_record = new ResultContent(_resources);
			_record.init(width * 0.9, height * 0.1, _defaultTextFormat);
			_record.setHead("Record");
			_record.alignPivot();
			_record.x = width / 2;
			_record.y = _score.y + (_score.height / 2) + (_record.height / 2) + (height * 0.03);
			addChild(_record);
			
			_restartButton = new Button(_resources.getSubTexture("ResultSpriteSheet.png", "popupTitle"), "RESTART");
			_restartButton.textFormat = _defaultTextFormat;
			_restartButton.width = width * 0.25;
			_restartButton.height = height * 0.15;
			_restartButton.alignPivot(Align.LEFT);
			_restartButton.x = width * 0.06;
			_restartButton.y = _record.y + (_record.height / 2) + (_restartButton.height / 2) + (height * 0.03);
			_restartButton.addEventListener(Event.TRIGGERED, onClickedButton);
			addChild(_restartButton);
			
			_nextStageButton = new Button(_resources.getSubTexture("ResultSpriteSheet.png", "popupTitle"), "NEXT");
			_nextStageButton.textFormat = _defaultTextFormat;
			_nextStageButton.width = width * 0.25;
			_nextStageButton.height = height * 0.15;
			_nextStageButton.alignPivot(Align.LEFT);
			_nextStageButton.x = _restartButton.bounds.right + (width * 0.06);
			_nextStageButton.y = _record.y + (_record.height / 2) + (_nextStageButton.height / 2) + (height * 0.03);
			_nextStageButton.addEventListener(Event.TRIGGERED, onClickedButton);
			addChild(_nextStageButton);
			
			_backButton = new Button(_resources.getSubTexture("ResultSpriteSheet.png", "popupTitle"), "MAIN");
			_backButton.textFormat = _defaultTextFormat;
			_backButton.width = width * 0.25;
			_backButton.height = height * 0.15;
			_backButton.alignPivot(Align.LEFT);
			_backButton.x = _nextStageButton.bounds.right + (width * 0.06);
			_backButton.y = _record.y + (_record.height / 2) + (_backButton.height / 2) + (height * 0.03);
			_backButton.addEventListener(Event.TRIGGERED, onClickedButton);
			addChild(_backButton);
			
			_ranking = new Ranking(_resources);
			_ranking.init(width * 0.9, height * 0.4);
			_ranking.alignPivot();
			_ranking.x = width / 2;
			_ranking.y = _nextStageButton.y + (_nextStageButton.height / 2) + (_ranking.height / 2) + (height * 0.03);
			addChild(_ranking);
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
			
			_score.removeFromParent();
			_score.destroy();
			_score = null;
			
			_record.removeFromParent();
			_record.destroy();
			_record = null;
			
			_restartButton.removeEventListener(Event.TRIGGERED, onClickedButton);
			_restartButton.removeFromParent();
			_restartButton.dispose();
			_restartButton = null;
			
			_nextStageButton.removeEventListener(Event.TRIGGERED, onClickedButton);
			_nextStageButton.removeFromParent();
			_nextStageButton.dispose();
			_nextStageButton = null;
			
			_backButton.removeEventListener(Event.TRIGGERED, onClickedButton);
			_backButton.removeFromParent();
			_backButton.dispose();
			_backButton = null;
			
			_ranking.removeFromParent();
			_ranking.destroy();
			_ranking = null;
		}
		
		public function setScore(value:uint):void
		{
			if(value != 0)
				_score.setValue(value.toString());
			else
				_score.setValue("실패ㅡㅜ");
		}
		
		public function setRecord(value:String):void
		{
			if(value != "0")
				_record.setValue(value);
			else
				_record.setValue("실패ㅡㅜ");
		}
		
		public function setRanking(jsonObject:Object):void
		{
			_ranking.setRanking(jsonObject);
		}
		
		public function setTitleMessage(value:String):void
		{
			_titleMessage.text = value;
		}
		
		private function onClickedButton(event:Event):void
		{
			var button:Button = event.currentTarget as Button;
			if(button == _backButton)
				dispatchEvent(new Event(ResultPopup.CLICKED_BACK));
			else if(button == _nextStageButton)
				dispatchEvent(new Event(ResultPopup.CLICKED_NEXT));
			else if(button == _restartButton)
				dispatchEvent(new Event(ResultPopup.CLICKED_RESTART));
		}
	}
}