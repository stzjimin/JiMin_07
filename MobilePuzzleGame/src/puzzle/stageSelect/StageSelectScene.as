package puzzle.stageSelect
{
	import flash.filesystem.File;
	
	import customize.PopupFrame;
	import customize.Progress;
	import customize.ProgressFrame;
	import customize.Scene;
	import customize.SceneEvent;
	import customize.SceneManager;
	import customize.Sound;
	import customize.SoundManager;
	
	import puzzle.ingame.InGameScene;
	import puzzle.loading.DBLoaderEvent;
	import puzzle.loading.Loading;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	import puzzle.loading.loader.DBLoader;
	import puzzle.user.User;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;

	public class StageSelectScene extends Scene
	{
		private var _spriteDir:File = File.applicationDirectory.resolvePath("puzzle/stageSelect/resources/stageSelectSpriteSheet");
		private var _soundDir:File = File.applicationDirectory.resolvePath("puzzle/stageSelect/resources/sound");
		private var _imageDir:File = File.applicationDirectory.resolvePath("puzzle/stageSelect/resources/image");
		private var _resources:Resources;
		
		private var _dbLoader:DBLoader;
		
		private var _progress:Progress;
		private var _progressFrame:ProgressFrame;
		
		private var _backGround:Image;
		private var _stageButtons:Vector.<Button>;
		private var _buttonIndex:uint = 0;
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _defaultTextFormat:TextFormat;
		
		private var _settingButton:Button;
		private var _settingPopup:SettingPopup;
		private var _popupFrame:PopupFrame;
		
		private var _soundManager:SoundManager;
		
		public function StageSelectScene()
		{
			super();
		}
		
		protected override function onCreate(event:SceneEvent):void
		{
			Loading.getInstance().showLoading(this);
			_soundManager = new SoundManager;
			
			_resources = new Resources(_spriteDir, _soundDir, _imageDir);
			
			_resources.addSpriteName("stageSelectSceneSprite0.png");
			_resources.addSoundName("White.mp3");
			
			_resources.addEventListener(LoadingEvent.COMPLETE, onCompleteResourceLoading);
			_resources.addEventListener(LoadingEvent.FAILED, onFailedResourcLoading);
			_resources.loadResource();
		}
		
		protected override function onStart(event:SceneEvent):void
		{
			loadUser();
			if(_soundManager)
				_soundManager.wakeAll();
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		protected override function onEnded(event:SceneEvent):void
		{
			if(_soundManager)
				_soundManager.stopAll();
		}
		
		protected override function onDestroy(event:SceneEvent):void
		{
			_backGround.removeEventListener(TouchEvent.TOUCH, onTouch);
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_defaultTextFormat = null;
			
			for(var i:int = 0; i < _stageButtons.length; i++)
			{
				_stageButtons[i].removeEventListener(Event.TRIGGERED, onClickedStageButton);
				_stageButtons[i].removeFromParent();
				_stageButtons[i].dispose();
				_stageButtons[i] = null;
			}
			_stageButtons.splice(0, _stageButtons.length);
			_stageButtons = null;
			
			_nextButton.removeEventListener(Event.TRIGGERED, onClickedNextButton);
			_nextButton.removeFromParent();
			_nextButton.dispose();
			_nextButton = null;
			
			_prevButton.removeEventListener(Event.TRIGGERED, onClickedNextButton);
			_prevButton.removeFromParent();
			_prevButton.dispose();
			_prevButton = null;
			
			_popupFrame.removeEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			_popupFrame.removeFromParent();
			_popupFrame.destroy();
			_popupFrame = null;
			
			_settingPopup.removeEventListener(SettingPopup.BGM_SWAP_CHECK, onSwapBGM);
			_settingPopup.removeEventListener(SettingPopup.BGM_SWAP_EMPTY, onSwapBGM);
			_settingPopup.removeEventListener(SettingPopup.EFFECT_SWAP_CHECK, onSwapEffect);
			_settingPopup.removeEventListener(SettingPopup.EFFECT_SWAP_EMPTY, onSwapEffect);
			_settingPopup.removeEventListener(SettingPopup.CLICK_CLOSE, onClickedSettingClose);
			_settingPopup.removeFromParent();
			_settingPopup.destroy();
			_settingPopup = null;
			
			_progress.removeFromParent();
			_progress.destroy();
			_progress = null;
			
			_progressFrame.removeFromParent();
			_progressFrame.destroy();
			_progressFrame = null;
			
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteResourceLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedResourcLoading);
			_resources.destroy();
			_resources = null;
			
			_soundManager.destroy();
			_soundManager = null;
			
			super.onDestroy(event);
		}
		
		protected override function onActivate(event:SceneEvent):void
		{
			if(_soundManager)
			{
				_soundManager.wakeAll();
			}
			super.onActivate(event);
		}
		
		protected override function onDeActivate(event:SceneEvent):void
		{
			if(_soundManager)
			{
				_soundManager.stopAll();
			}
			super.onDeActivate(event);
		}
		
		private function onCompleteResourceLoading(event:LoadingEvent):void
		{
			Loading.getInstance().completeLoading();
			
			_soundManager.addSound("White.mp3", _resources.getSoundFile("White.mp3"));
			
			_backGround = new Image(_resources.getSubTexture("stageSelectSceneSprite0.png", "stageSelectBackground2"));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_defaultTextFormat = new TextFormat();
			_defaultTextFormat.bold = true;
			_defaultTextFormat.size = 40;
			
			_stageButtons = new Vector.<Button>();
			for(var i:int = 0; i < 5; i++)
			{
				_stageButtons[i] = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "stageBlockButton"));
				_stageButtons[i].width = 80;
				_stageButtons[i].height = 80;
				_stageButtons[i].alignPivot();
				_stageButtons[i].textFormat = _defaultTextFormat;
				_stageButtons[i].addEventListener(Event.TRIGGERED, onClickedStageButton);
				
				_stageButtons[i].touchable = false;
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
			
			_nextButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingButton"));
			_nextButton.width = 80;
			_nextButton.height = 80;
			_nextButton.alignPivot();
			_nextButton.x = 502;
			_nextButton.y = 913;
			_nextButton.textFormat = _defaultTextFormat;
			_nextButton.text = "N";
			_nextButton.addEventListener(Event.TRIGGERED, onClickedNextButton);
			addChild(_nextButton);
			
			_prevButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingButton"));
			_prevButton.width = 80;
			_prevButton.height = 80;
			_prevButton.alignPivot();
			_prevButton.x = 100;
			_prevButton.y = 913;
			_prevButton.textFormat = _defaultTextFormat;
			_prevButton.text = "P";
			_prevButton.addEventListener(Event.TRIGGERED, onClickedPrevButton);
			addChild(_prevButton);
			
			_settingButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingButton"));
			_settingButton.width = 80;
			_settingButton.height = 80;
			_settingButton.x = 576 - 80;
			_settingButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_settingButton);
			
			_settingPopup = new SettingPopup(_resources);
			_settingPopup.init(400, 300);
			_settingPopup.addEventListener(SettingPopup.CLICK_CLOSE, onClickedSettingClose);
			_settingPopup.addEventListener(SettingPopup.BGM_SWAP_CHECK, onSwapBGM);
			_settingPopup.addEventListener(SettingPopup.BGM_SWAP_EMPTY, onSwapBGM);
			_settingPopup.addEventListener(SettingPopup.EFFECT_SWAP_CHECK, onSwapEffect);
			_settingPopup.addEventListener(SettingPopup.EFFECT_SWAP_EMPTY, onSwapEffect);
			
			_popupFrame = new PopupFrame(576, 1024);
			_popupFrame.setContent(_settingPopup);
			_popupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_popupFrame);
			
			_progress = new Progress();
			_progress.init(100, 100);
			
			_progressFrame = new ProgressFrame(576, 1024);
			_progressFrame.setContent(_progress);
			addChild(_progressFrame);
			
			_soundManager.play("White.mp3", Sound.INFINITE);
			
			loadUser();
		}
		
		private function loadUser():void
		{
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteDBLoading);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedDBLoading);
			_dbLoader.setUserData();
			_progressFrame.startProgress();
		}
		
		private function onFailedResourcLoading(event:LoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteResourceLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedResourcLoading);
			_resources.destroy();
		}
		
		private function onCompleteDBLoading(event:DBLoaderEvent):void
		{
			_progressFrame.stopProgress();
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteDBLoading);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedDBLoading);
			
			trace(User.getInstance().clearstage);
			
			setButtonState();
		}
		
		private function onFailedDBLoading(event:DBLoaderEvent):void
		{
			_progressFrame.stopProgress();
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteDBLoading);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedDBLoading);
			
			trace(event.message);
		}
		
		private function setButtonState():void
		{
			for(var i:int = 0; i < 5; i++)
			{
				_stageButtons[i].text = ((_buttonIndex*5)+i+1).toString();
				_stageButtons[i].name = ((_buttonIndex*5)+i+1).toString();
				
				if(int(_stageButtons[i].name) <= (User.getInstance().clearstage+1))
				{
					_stageButtons[i].upState = _resources.getSubTexture("stageSelectSceneSprite0.png", "stageButtonImage");
					_stageButtons[i].touchable = true;
				}
				else
				{
					_stageButtons[i].upState = _resources.getSubTexture("stageSelectSceneSprite0.png", "stageBlockButton");
					_stageButtons[i].touchable = false;
				}
			}
		}
		
		private function onClickedNextButton(event:Event):void
		{
			if(_buttonIndex >= 10)
				return;
			_buttonIndex++;
			setButtonState();
		}
		
		private function onClickedPrevButton(event:Event):void
		{
			if(_buttonIndex <= 0)
				return;
			_buttonIndex--;
			setButtonState();
		}
		
		private function onClickedSettingClose(event:Event):void
		{
//			_popupFrame.visible = false;
			_popupFrame.hide();
		}
		
		private function onClickedCover(event:Event):void
		{
//			_popupFrame.visible = false;
			_popupFrame.hide();
		}
		
		private function onClickedSettingButton(event:Event):void
		{
//			_popupFrame.visible = true;
			_popupFrame.show();
		}
		
		private function onClickedStageButton(event:Event):void
		{
			var stageNumber:String = Button(event.currentTarget).name;
			trace(stageNumber);
			SceneManager.current.addScene(InGameScene, "game");
			SceneManager.current.goScene("game", stageNumber);
		}
		
		private function onSwapBGM(event:Event):void
		{
			if(event.type == SettingPopup.BGM_SWAP_CHECK)
			{
				_soundManager.isBgmActive = true;
				User.getInstance().bgmActive = true;
			}
			else
			{
				_soundManager.isBgmActive = false;
				User.getInstance().bgmActive = false;
			}
		}
		
		private function onSwapEffect(event:Event):void
		{
			if(event.type == SettingPopup.EFFECT_SWAP_CHECK)
			{
				_soundManager.isEffectActive = true;
				User.getInstance().soundEffectActive = true;
			}
			else
			{
				_soundManager.isEffectActive = false;
				User.getInstance().soundEffectActive = false;
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
				trace(touch.getLocation(this));
		}
	}
}