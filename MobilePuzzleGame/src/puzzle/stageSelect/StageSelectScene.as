package puzzle.stageSelect
{
	import com.lpesign.ToastExtension;
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import customize.PopupFrame;
	import customize.Progress;
	import customize.ProgressFrame;
	import customize.Scene;
	import customize.SceneEvent;
	import customize.SceneManager;
	import customize.Sound;
	import customize.SoundManager;
	
	import puzzle.attend.Attend;
	import puzzle.ingame.InGameScene;
	import puzzle.loading.DBLoaderEvent;
	import puzzle.loading.Loading;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	import puzzle.loading.loader.DBLoader;
	import puzzle.shop.Shop;
	import puzzle.title.TitleScene;
	import puzzle.user.User;
	import puzzle.user.UserInfo;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextFormat;

	public class StageSelectScene extends Scene
	{	
		private var _resources:Resources;
		private var _dbLoader:DBLoader;
		
		private var _progress:Progress;
		private var _progressFrame:ProgressFrame;
		
		private var _backGround:Image;
		private var _stageButtons:Vector.<Button>;
		private var _buttonIndex:uint = 0;
		private var _nextButton:Button;
		private var _prevButton:Button;
		
		private var _userInfo:UserInfo;
		
		private var _defaultTextFormat:TextFormat;
		
		private var _attendPopup:Attend;
		private var _attendPopupFrame:PopupFrame;
		
		private var _settingPopup:SettingPopup;
		private var _popupFrame:PopupFrame;
		
		private var _stagePopup:StagePopup;
		private var _stagePopupFrame:PopupFrame;
		
		private var _shopPopup:Shop;
		private var _shopPopupFrame:PopupFrame;
		
		private var _exitPopup:ExitPopup;
		private var _exitPopupFrame:PopupFrame;
		
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
			
			_resources = new Resources(Resources.SpriteDir, Resources.SoundDir, Resources.ImageDir);
			
			_resources.addSpriteName("StageSelectSceneSpriteSheet.png");
			_resources.addSpriteName("UserInfoSpriteSheet.png");
			_resources.addSpriteName("SettingPopupSpriteSheet.png");
			_resources.addSpriteName("RankingSpriteSheet.png");
			_resources.addSpriteName("ShopSpriteSheet.png");
			_resources.addSpriteName("StagePopupSpriteSheet.png");
			_resources.addSpriteName("AttendSpriteSheet.png");
			_resources.addSpriteName("ExitPopupSpriteSheet.png");
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
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected override function onDestroy(event:SceneEvent):void
		{
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
			
			_attendPopup.removeEventListener(Event.TRIGGERED, onClickedAttenPopup);
			_attendPopup.removeFromParent();
			_attendPopup.destroy();
			_attendPopup = null;
			
			_attendPopupFrame.removeEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			_attendPopupFrame.removeFromParent();
			_attendPopupFrame.destroy();
			_attendPopupFrame = null;
			
			_shopPopup.removeEventListener(Shop.CLICKED_BUY, onClickedShopBuy);
			_shopPopup.removeEventListener(Shop.CLICKED_CLOSE, onClickedShopClose);
			_shopPopup.removeFromParent();
			_shopPopup.destroy();
			_shopPopup = null;
			
			_shopPopupFrame.removeEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			_shopPopupFrame.removeFromParent();
			_shopPopupFrame.destroy();
			_shopPopupFrame = null;
			
			_exitPopup.removeEventListener(ExitPopup.CLICKED_OK, onClickedExitOk);
			_exitPopup.removeEventListener(ExitPopup.CLICKED_CLOSE, onClickedExitClose);
			_exitPopup.removeFromParent();
			_exitPopup.destroy();
			_exitPopup = null;
			
			_exitPopupFrame.removeEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			_exitPopupFrame.removeFromParent();
			_exitPopupFrame.destroy();
			_exitPopupFrame = null;
			
			_userInfo.removeEventListener(UserInfo.CLICKED_PROFILL, onClickedProfill);
			_userInfo.removeEventListener(UserInfo.CLICKED_FORK, onClickedFork);
			_userInfo.removeEventListener(UserInfo.CLICKED_SEARCH, onClickedSearch);
			_userInfo.removeEventListener(UserInfo.CLICKED_SHUFFLE, onClickedShuffle);
			_userInfo.removeEventListener(UserInfo.CLICKED_HEART, onClickedHeart);
			_userInfo.removeEventListener(UserInfo.CLICKED_LOGOUT, onClickedLogOut);
			_userInfo.removeEventListener(UserInfo.CLICKED_ATTEND, onClickedAttend);
			_userInfo.removeFromParent();
			_userInfo.destroy();
			_userInfo = null;
			
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteResourceLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedResourcLoading);
			_resources.destroy();
			_resources = null;
			
			_soundManager.stopAll();
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
			
			_backGround = new Image(_resources.getSubTexture("StageSelectSceneSpriteSheet.png", "stageSelectBackground2"));
			_backGround.width = 576;
			_backGround.height = 1024;
			addChild(_backGround);
			
			_defaultTextFormat = new TextFormat();
			_defaultTextFormat.bold = true;
			_defaultTextFormat.size = 40;
			
			_stageButtons = new Vector.<Button>();
			for(var i:int = 0; i < 5; i++)
			{
				_stageButtons[i] = new Button(_resources.getSubTexture("StageSelectSceneSpriteSheet.png", "stageBlockButton"));
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
			
			_nextButton = new Button(_resources.getSubTexture("StageSelectSceneSpriteSheet.png", "upArrow"));
			_nextButton.width = 80;
			_nextButton.height = 80;
			_nextButton.alignPivot();
			_nextButton.x = 502;
			_nextButton.y = 913;
			_nextButton.textFormat = _defaultTextFormat;
			_nextButton.addEventListener(Event.TRIGGERED, onClickedNextButton);
			addChild(_nextButton);
			
			_prevButton = new Button(_resources.getSubTexture("StageSelectSceneSpriteSheet.png", "downArrow"));
			_prevButton.width = 80;
			_prevButton.height = 80;
			_prevButton.alignPivot();
			_prevButton.x = 100;
			_prevButton.y = 913;
			_prevButton.textFormat = _defaultTextFormat;
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
			_userInfo.addEventListener(UserInfo.CLICKED_ATTEND, onClickedAttend);
			addChild(_userInfo);
			
//			_settingButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingButton"));
//			_settingButton.width = 80;
//			_settingButton.height = 80;
//			_settingButton.x = 576 - 80;
//			_settingButton.addEventListener(Event.TRIGGERED, onClickedProfill);
//			addChild(_settingButton);
			
			_shopPopup = new Shop(_resources);
			_shopPopup.init(400, 600);
			_shopPopup.addEventListener(Shop.CLICKED_BUY, onClickedShopBuy);
			_shopPopup.addEventListener(Shop.CLICKED_CLOSE, onClickedShopClose);
			
			_shopPopupFrame = new PopupFrame(576, 1024);
			_shopPopupFrame.setContent(_shopPopup);
			_shopPopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_shopPopupFrame)
			
			_attendPopup = new Attend(_resources);
			_attendPopup.addEventListener(Event.TRIGGERED, onClickedAttenPopup);
			_attendPopup.init(400, 300);
			
			_attendPopupFrame = new PopupFrame(576, 1024);
			_attendPopupFrame.setContent(_attendPopup);
			_attendPopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_attendPopupFrame);
			
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
			
			_exitPopup = new ExitPopup(_resources);
			_exitPopup.addEventListener(ExitPopup.CLICKED_OK, onClickedExitOk);
			_exitPopup.addEventListener(ExitPopup.CLICKED_CLOSE, onClickedExitClose);
			_exitPopup.init(400, 200);
			
			_exitPopupFrame = new PopupFrame(576, 1024);
			_exitPopupFrame.setContent(_exitPopup);
			_exitPopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_exitPopupFrame);
			
			_progress = new Progress();
			_progress.init(100, 100);
			
			_progressFrame = new ProgressFrame(576, 1024);
			_progressFrame.setContent(_progress);
			addChild(_progressFrame);
			
			_soundManager.play("White.mp3", Sound.INFINITE);
			
			setButtonState();
			
			this.scaleX *= (PuzzleGame.stageWidth / 576);
			this.scaleY *= (PuzzleGame.stageHeight / 1024);
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
					_stageButtons[i].upState = _resources.getSubTexture("StageSelectSceneSpriteSheet.png", "stageButtonImage");
					_stageButtons[i].touchable = true;
				}
				else
				{
					_stageButtons[i].upState = _resources.getSubTexture("StageSelectSceneSpriteSheet.png", "stageBlockButton");
					_stageButtons[i].touchable = false;
				}
			}
			
//			trace("last = " + _soundManager.isBgmActive);
			_progressFrame.stopProgress();
			if(User.getInstance().dayChanged)
			{
				_attendPopupFrame.show();
				attend();
			}
			User.getInstance().pullUserData();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function attend():void
		{
			_attendPopup.attend();
			User.getInstance().dayChanged = false;
			User.getInstance().attendCount += 1;
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
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			trace("aa");
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				if(!_exitPopupFrame.visible)
				{
					if(_stagePopupFrame.visible)
						_stagePopupFrame.hide();
					else if(_popupFrame.visible)
						_popupFrame.hide();
					else if(_attendPopupFrame.visible)
						_attendPopupFrame.hide();
					else if(_shopPopupFrame.visible)
						_shopPopupFrame.hide();
					else
					{
						_exitPopup.setTitleMessage("종료 하시겠습니까??");
						_exitPopup.logOut = false;
						_exitPopupFrame.show();
					}
				}
				else
					_exitPopupFrame.hide();
			}
		}
		
		private function onClickedExitOk(event:Event):void
		{
			if(event.data as Boolean)
			{
				User.getInstance().pullUserData(completePullUserData);
			}
			else
				NativeApplication.nativeApplication.exit();
		}
		
		private function onClickedExitClose(event:Event):void
		{
			_exitPopupFrame.hide();
		}
		
		private function onClickedCover(event:Event):void
		{
//			_popupFrame.visible = false;
			if(event.currentTarget == _stagePopupFrame)
				_stagePopupFrame.hide();
			else if(event.currentTarget == _popupFrame)
				_popupFrame.hide();
			else if(event.currentTarget == _attendPopupFrame)
				_attendPopupFrame.hide();
			else if(event.currentTarget == _shopPopupFrame)
				_shopPopupFrame.hide();
			else if(event.currentTarget == _exitPopupFrame)
				_exitPopupFrame.hide();
		}
		
		private function onClickedAttenPopup(event:Event):void
		{
			_attendPopupFrame.hide();
		}
		
		private function onClickedProfill(event:Event):void
		{
//			_popupFrame.visible = true;
			_popupFrame.show();
		}
		
		private function onClickedLogOut(event:Event):void
		{
			_exitPopup.setTitleMessage("로그아웃 하시겠습니까??");
			_exitPopup.logOut = true;
			_exitPopupFrame.show();
		}
		
		private function completePullUserData():void
		{
			User.getInstance().logout();
			NativeApplication.nativeApplication.exit();
//			SceneManager.current.addScene(TitleScene, "title");
//			SceneManager.current.switchScene("title");
		}
		
		private function onClickedFork(event:Event):void
		{
			trace("fork");
//			User.getInstance().fork += 1;
			_shopPopup.setItem(event.data as String);
			_shopPopupFrame.show();
		}
		
		private function onClickedSearch(event:Event):void
		{
			trace("search");
//			User.getInstance().search += 1;
			_shopPopup.setItem(event.data as String);
			_shopPopupFrame.show();
		}
		
		private function onClickedShuffle(event:Event):void
		{
			trace("shuffle");
//			User.getInstance().shuffle += 1;
			_shopPopup.setItem(event.data as String);
			_shopPopupFrame.show();
		}
		
		private function onClickedHeart(event:Event):void
		{
			trace("heart");
//			User.getInstance().heart += 1;
			_shopPopup.setItem(event.data as String);
			_shopPopupFrame.show();
		}
		
		private function onClickedAttend(event:Event):void
		{
			_attendPopupFrame.show();
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
			if(User.getInstance().heart <= 0)
			{
				var toastExtension:ToastExtension = new ToastExtension();
				toastExtension.toast("하트가 부족해요!!");
				return;
			}
			_stagePopupFrame.hide();
			User.getInstance().heart -= 1;
			SceneManager.current.addScene(InGameScene, "game");
			SceneManager.current.goScene("game", _clickedStageNumber);
		}
		
		private function onClickedShopBuy(event:Event):void
		{
			_shopPopupFrame.hide();
			User.getInstance().pullUserData();
		}
		
		private function onClickedShopClose(event:Event):void
		{
			_shopPopupFrame.hide();
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
	}
}