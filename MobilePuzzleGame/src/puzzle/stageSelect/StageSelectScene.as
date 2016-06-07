package puzzle.stageSelect
{
	import flash.filesystem.File;
	
	import customize.Scene;
	import customize.SceneEvent;
	import customize.SceneManager;
	
	import puzzle.Popup;
	import puzzle.ingame.InGameScene;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class StageSelectScene extends Scene
	{
		private var _spriteDir:File = File.applicationDirectory.resolvePath("puzzle/stageSelect/stageSelectSpriteSheet");
		private var _resources:Resources;
		
		private var _backGround:Image;
		private var _stageButtons:Vector.<Button>;
		
		private var _settingButton:Button;
		private var _settingPopup:SettingPopup;
		
		public function StageSelectScene()
		{
			super();
		}
		
		protected override function onCreate(event:SceneEvent):void
		{
			_resources = new Resources(_spriteDir);
			
			_resources.addSpriteName("stageSelectSceneSprite0.png");
			
			_resources.addEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.addEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.loadResource();
		}
		
		protected override function onStart(event:SceneEvent):void
		{
			
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		protected override function onEnded(event:SceneEvent):void
		{
			
		}
		
		protected override function onDestroy(event:SceneEvent):void
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
			
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
			_resources = null;
			
			super.onDestroy(event);
		}
		
		private function onCompleteLoading(event:LoadingEvent):void
		{
			_backGround = new Image(_resources.getSubTexture("stageSelectSceneSprite0.png", "stageSelectBackground2"));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_stageButtons = new Vector.<Button>();
			for(var i:int = 0; i < 5; i++)
			{
				_stageButtons[i] = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "stageButtonImage"));
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
			
			_settingButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingButton"));
			_settingButton.width = 70;
			_settingButton.height = 70;
			_settingButton.x = 576 - 70;
			_settingButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_settingButton);
			
			_settingPopup = new SettingPopup(_resources);
			_settingPopup.init(400, 300);
			_settingPopup.addEventListener(Popup.COVER_CLICKED, onClickedCover);
			_settingPopup.addEventListener(SettingPopup.CLICK_CLOSE, onClickedSettingClose);
			addChild(_settingPopup);
		}
		
		private function onFailedLoading(event:LoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
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
			SceneManager.current.addScene(InGameScene, "game");
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