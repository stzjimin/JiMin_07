package puzzle.stageSelect
{
	import puzzle.loading.Resources;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Align;

	public class ExitPopup extends DisplayObjectContainer
	{
		public static const CLICKED_OK:String = "okClicked";
		public static const CLICKED_CLOSE:String = "closeClicked";
		
		private var _backGround:Image;
		private var _title:Image;
		private var _titleMessage:TextField;
		
		private var _okButton:Button;
		private var _closeButton:Button;
		
		private var _logOut:Boolean;
		
		private var _resources:Resources;
		
		public function ExitPopup(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_backGround = new Image(_resources.getSubTexture("ExitPopupSpriteSheet.png", "PopupBackGround"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(_resources.getSubTexture("ExitPopupSpriteSheet.png", "popupTitle"));
			_title.width = width * 0.9;
			_title.height = height * 0.2;
			_title.alignPivot(Align.CENTER, Align.TOP);
			_title.x = width / 2;
			_title.y = height * 0.05;
			addChild(_title);
			
			_titleMessage = new TextField(_title.width, _title.height, "종료 하시겠습니까??");
			_titleMessage.format.bold = true;
			_titleMessage.format.size = 20;
			_titleMessage.alignPivot(Align.CENTER, Align.TOP);
			_titleMessage.x = width / 2;
			_titleMessage.y = height * 0.05;
			addChild(_titleMessage);
			
			_okButton = new Button(_resources.getSubTexture("ExitPopupSpriteSheet.png", "popupTitle"), "OK");
			_okButton.textFormat.bold = true;
			_okButton.textFormat.size = 20;
			_okButton.width = width * 0.4;
			_okButton.height = height * 0.65;
			_okButton.x = width * 0.05;
			_okButton.y = _title.y + _title.height + (height * 0.05);
			_okButton.addEventListener(Event.TRIGGERED, onClickedOkButton);
			addChild(_okButton);
			
			_closeButton = new Button(_resources.getSubTexture("ExitPopupSpriteSheet.png", "popupTitle"), "CLOSE");
			_closeButton.textFormat.bold = true;
			_closeButton.textFormat.size = 20;
			_closeButton.width = width * 0.4;
			_closeButton.height = height * 0.65;
			_closeButton.x = _okButton.x + _okButton.width + (width * 0.1);
			_closeButton.y = _okButton.y;
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
			
			_okButton.removeEventListener(Event.TRIGGERED, onClickedOkButton);
			_okButton.removeFromParent();
			_okButton.dispose();
			_okButton = null;
			
			_closeButton.removeEventListener(Event.TRIGGERED, onClickedCloseButton);
			_closeButton.removeFromParent();
			_closeButton.dispose();
			_closeButton = null;
		}
		
		public function setTitleMessage(message:String):void
		{
			_titleMessage.text = message;
		}
		
		private function onClickedOkButton(event:Event):void
		{
			dispatchEvent(new Event(ExitPopup.CLICKED_OK, false, _logOut));
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			dispatchEvent(new Event(ExitPopup.CLICKED_CLOSE));
			_logOut = false;
		}

		public function get logOut():Boolean
		{
			return _logOut;
		}

		public function set logOut(value:Boolean):void
		{
			_logOut = value;
		}

	}
}