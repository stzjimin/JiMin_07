package puzzle.stageSelect
{
	import flash.display.Bitmap;
	
	import customize.Scene;
	import customize.SceneManager;
	
	import puzzle.Popup;
	import puzzle.ingame.InGame;
	import puzzle.loader.Resources;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class StageSelectScene extends Scene
	{
		[Embed(source="settingButton.png")]
		private const settingImage:Class;
		
		[Embed(source="stageSelectBackGround2.png")]
		private const backGroundImage:Class;
		
		[Embed(source="stageButtonImage.png")]
		private const stageButtonImage:Class;
		
		[Embed(source="stageBlockButton.png")]
		private const stageBlockImage:Class;
		
		private var _backGround:Image;
		private var _stageButtons:Vector.<Button>;
		
		private var _settingButton:Button;
		private var _settingPopup:SettingPopup;
		
		public function StageSelectScene()
		{
			_backGround = new Image(Texture.fromBitmap(new backGroundImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_stageButtons = new Vector.<Button>();
			for(var i:int = 0; i < 5; i++)
			{
				_stageButtons[i] = new Button(Texture.fromBitmap(new stageButtonImage() as Bitmap));
				_stageButtons[i].width = 80;
				_stageButtons[i].height = 80;
				_stageButtons[i].alignPivot();
				_stageButtons[i].text = (i+1).toString();
				_stageButtons[i].textFormat.bold = true;
				_stageButtons[i].textFormat.size = 40;
				_stageButtons[i].name = (i+1).toString();
				_stageButtons[i].addEventListener(Event.TRIGGERED, onClickedStageButton);
				addChild(_stageButtons[i]);
			}
			
			_stageButtons[0].x = 322;
			_stageButtons[0].y = 777;
			
			_stageButtons[1].x = 106;
			_stageButtons[1].y = 637;
			
			_stageButtons[2].x = 394;
			_stageButtons[2].y = 519;
			
			_stageButtons[3].x = 192;
			_stageButtons[3].y = 369;
			
			_stageButtons[4].x = 414;
			_stageButtons[4].y = 224;
			
			_settingButton = new Button(Texture.fromBitmap(new settingImage() as Bitmap));
			_settingButton.width = 70;
			_settingButton.height = 70;
			_settingButton.x = 576 - 70;
			_settingButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_settingButton);
			
			_settingPopup = new SettingPopup();
			_settingPopup.init(400, 300);
			_settingPopup.addEventListener(Popup.COVER_CLICKED, onClickedCover);
			_settingPopup.addEventListener(SettingPopup.CLICK_CLOSE, onClickedSettingClose);
			addChild(_settingPopup);
		}
		
		public override function destroy():void
		{
			_backGround.removeEventListener(TouchEvent.TOUCH, onTouch);
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			for(var i:int = 0; i < _stageButtons.length; i++)
			{
				_stageButtons[i].removeEventListener(Event.TRIGGERED, onClickedStageButton);
				_stageButtons[i].removeFromParent();
				_stageButtons[i].dispose();
				_stageButtons[i] = null;
			}
			_stageButtons.splice(0, _stageButtons.length);
			_stageButtons = null;
			
			_settingPopup.removeEventListener(Popup.COVER_CLICKED, onClickedCover);
			_settingPopup.removeEventListener(SettingPopup.CLICK_CLOSE, onClickedSettingClose);
			_settingPopup.removeFromParent();
			_settingPopup.destroy();
			
			super.destroy();
		}
		
		protected override function onStart(event:Event):void
		{
			
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		protected override function onEnded(event:Event):void
		{
			
		}
		
		private function onClickedSettingClose(event:Event):void
		{
			_settingPopup.visible = false;
		}
		
		private function onClickedCover(event:Event):void
		{
			_settingPopup.visible = false;
		}
		
		private function onClickedSettingButton(event:Event):void
		{
			_settingPopup.visible = true;
		}
		
		private function onClickedStageButton(event:Event):void
		{
			var stageNumber:String = Button(event.currentTarget).name;
			trace(stageNumber);
			SceneManager.current.addScene(InGame, "game");
			SceneManager.current.goScene("game", stageNumber);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				trace(touch.getLocation(this));
//				SceneManager.current.goScene("game");
			}
		}
	}
}