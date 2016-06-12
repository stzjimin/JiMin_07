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
	import puzzle.title.TitleScene;
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
		
//		private var _heartTimer:HeartTimer;
		private var _userInfo:UserInfo;
		
		private var _defaultTextFormat:TextFormat;
		
//		private var _settingButton:Button;
		private var _settingPopup:SettingPopup;
		private var _popupFrame:PopupFrame;
		
		private var _stagePopup:StagePopup;
		private var _stagePopupFrame:PopupFrame;
		
		private var _soundManager:SoundManager;
		
		private var _clickedStageNumber:uint;
		
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
			setButtonState();
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
			
			_stagePopupFrame.removeEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			_stagePopupFrame.removeFromParent();
			_stagePopupFrame.destroy();
			_stagePopupFrame = null;
			
			_stagePopup.removeEventListener(StagePopup.CLOSE_CLICK, onClickedCloseButton);
			_stagePopup.removeEventListener(StagePopup.START_CLICK, onClickedStartButton);
			_stagePopup.removeFromParent();
			_stagePopup.destroy();
			_stagePopup = null;
			
			_progress.removeFromParent();
			_progress.destroy();
			_progress = null;
			
			_progressFrame.removeFromParent();
			_progressFrame.destroy();
			_progressFrame = null;
			
			_userInfo.removeEventListener(UserInfo.CLICKED_PROFILL, onClickedProfill);
			_userInfo.removeEventListener(UserInfo.CLICKED_FORK, onClickedFork);
			_userInfo.removeEventListener(UserInfo.CLICKED_SEARCH, onClickedSearch);
			_userInfo.removeEventListener(UserInfo.CLICKED_SHUFFLE, onClickedShuffle);
			_userInfo.removeEventListener(UserInfo.CLICKED_HEART, onClickedHeart);
			_userInfo.removeEventListener(UserInfo.CLICKED_LOGOUT, onClickedLogOut);
			_userInfo.removeFromParent();
			_userInfo.destroy();
			_userInfo = null;
			
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
			
			_userInfo = new UserInfo(_resources);
			_userInfo.init(576, 100);
			_userInfo.addEventListener(UserInfo.CLICKED_PROFILL, onClickedProfill);
			_userInfo.addEventListener(UserInfo.CLICKED_FORK, onClickedFork);
			_userInfo.addEventListener(UserInfo.CLICKED_SEARCH, onClickedSearch);
			_userInfo.addEventListener(UserInfo.CLICKED_SHUFFLE, onClickedShuffle);
			_userInfo.addEventListener(UserInfo.CLICKED_HEART, onClickedHeart);
			_userInfo.addEventListener(UserInfo.CLICKED_LOGOUT, onClickedLogOut);
			addChild(_userInfo);
			
//			_settingButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingButton"));
//			_settingButton.width = 80;
//			_settingButton.height = 80;
//			_settingButton.x = 576 - 80;
//			_settingButton.addEventListener(Event.TRIGGERED, onClickedProfill);
//			addChild(_settingButton);
			
			_settingPopup = new SettingPopup(_resources);
			_settingPopup.addEventListener(SettingPopup.CLICK_CLOSE, onClickedSettingClose);
			_settingPopup.addEventListener(SettingPopup.BGM_SWAP_CHECK, onSwapBGM);
			_settingPopup.addEventListener(SettingPopup.BGM_SWAP_EMPTY, onSwapBGM);
			_settingPopup.addEventListener(SettingPopup.EFFECT_SWAP_CHECK, onSwapEffect);
			_settingPopup.addEventListener(SettingPopup.EFFECT_SWAP_EMPTY, onSwapEffect);
			_settingPopup.init(400, 300);
			
			_popupFrame = new PopupFrame(576, 1024);
			_popupFrame.setContent(_settingPopup);
			_popupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_popupFrame);
			
			_stagePopup = new StagePopup(_resources);
			_stagePopup.addEventListener(StagePopup.CLOSE_CLICK, onClickedCloseButton);
			_stagePopup.addEventListener(StagePopup.START_CLICK, onClickedStartButton);
			_stagePopup.init(400, 500);
			
			_stagePopupFrame = new PopupFrame(576, 1024);
			_stagePopupFrame.setContent(_stagePopup);
			_stagePopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_stagePopupFrame);
			
			_progress = new Progress();
			_progress.init(100, 100);
			
			_progressFrame = new ProgressFrame(576, 1024);
			_progressFrame.setContent(_progress);
			addChild(_progressFrame);
			
			_soundManager.play("White.mp3", Sound.INFINITE);
			
			setButtonState();
		}
		
		private function onFailedResourcLoading(event:LoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteResourceLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedResourcLoading);
			_resources.destroy();
		}
		
		private function setButtonState():void
		{
			_progressFrame.startProgress();
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
			
//			trace("last = " + _soundManager.isBgmActive);
			_progressFrame.stopProgress();
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
			if(event.currentTarget == _stagePopupFrame)
				_stagePopupFrame.hide();
			else
				_popupFrame.hide();
		}
		
		private function onClickedProfill(event:Event):void
		{
//			_popupFrame.visible = true;
			_popupFrame.show();
		}
		
		private function onClickedLogOut(event:Event):void
		{
			FBExtension.getInstance().logout();
			SceneManager.current.addScene(TitleScene, "title");
			SceneManager.current.switchScene("title");
		}
		
		private function onClickedFork(event:Event):void
		{
			trace("fork");
//			User.getInstance().pushFork();
			User.getInstance().fork += 1;
		}
		
		private function onClickedSearch(event:Event):void
		{
			trace("search");
//			User.getInstance().pushSearch();
			User.getInstance().search += 1;
		}
		
		private function onClickedShuffle(event:Event):void
		{
			trace("shuffle");
//			User.getInstance().pushShuffle();
			User.getInstance().shuffle += 1;
		}
		
		private function onClickedHeart(event:Event):void
		{
			trace("heart");
//			User.getInstance().pushHeart();
			User.getInstance().heart += 1;
		}
		
		private function onClickedStageButton(event:Event):void
		{
			var stageNumber:String = Button(event.currentTarget).name;
			
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			
			_dbLoader.selectScoreData(uint(stageNumber));
			_clickedStageNumber = uint(stageNumber);
		}
		
		private function onCompleteLoadingScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			_dbLoader.destroy();
			
			var result:String = event.message;
			var jsonObject:Object = JSON.parse(result);
			
			_stagePopup.setTitleMessage(_clickedStageNumber.toString());
			_stagePopup.setLanking(jsonObject);
			_stagePopupFrame.show();
		}
		
		private function onFailedLoadingScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			_dbLoader.destroy();
			
			trace(event.message);
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			_stagePopupFrame.hide();
		}
		
		private function onClickedStartButton(event:Event):void
		{
			_stagePopupFrame.hide();
			User.getInstance().heart -= 1;
			SceneManager.current.addScene(InGameScene, "game");
			SceneManager.current.goScene("game", _clickedStageNumber);
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