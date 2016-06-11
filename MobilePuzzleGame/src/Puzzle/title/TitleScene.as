package puzzle.title
{
	import com.greensock.TweenMax;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import customize.PopupFrame;
	import customize.Progress;
	import customize.ProgressFrame;
	import customize.Scene;
	import customize.SceneEvent;
	import customize.SceneManager;
	import customize.Sound;
	import customize.SoundManager;
	
	import puzzle.loading.DBLoaderEvent;
	import puzzle.loading.Loading;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	import puzzle.loading.loader.DBLoader;
	import puzzle.user.User;
	import puzzle.user.UserEvent;
	import puzzle.user.UserType;
	
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class TitleScene extends Scene
	{	
		private var _spriteDir:File = File.applicationDirectory.resolvePath("puzzle/title/resources/titleSpriteSheet");
		private var _soundDir:File = File.applicationDirectory.resolvePath("puzzle/title/resources/sound");
		private var _imageDir:File = File.applicationDirectory.resolvePath("puzzle/title/resources/image");
		private var _resources:Resources;
		
		private var _dbLoader:DBLoader;
		
		private var _progress:Progress;
		private var _progressFrame:ProgressFrame;
		
		private var _juggler:Juggler;
		private var _ariTween:Tween;
		
		private var _facebook:FBExtension;
		
		private var _popupFrame:PopupFrame;
		private var _facebookLoginButton:Button;
		
		private var _backGround:Image;
		private var _ari:Image;
		
		private var _soundManager:SoundManager;
		
		public function TitleScene()
		{
			super();
			_juggler = new Juggler();
		}
		
		protected override function onCreate(event:SceneEvent):void
		{
			_soundManager = new SoundManager;
			_resources = new Resources(_spriteDir, _soundDir, _imageDir);
			
			_resources.addSpriteName("TitleSpriteSheet.png");
			_resources.addImageName("loadingImage.png");
			_resources.addSoundName("Rose.mp3");
			
			_resources.addEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.addEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.loadResource();
		}
		
		protected override function onStart(event:SceneEvent):void
		{
			//음악 on
		}
		
		protected override function onEnded(event:SceneEvent):void
		{
			//음악 off
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			_juggler.advanceTime(event.passedTime);
		}
		
		protected override function onDestroy(event:SceneEvent):void
		{	
			TweenMax.killAll();
			
			_backGround.removeEventListener(TouchEvent.TOUCH, onTouch);
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_ari.removeFromParent();
			_ari.dispose();
			_ari = null;
			
			_progress.removeFromParent();
			_progress.destroy();
			_progress = null;
			
			_progressFrame.removeFromParent();
			_progressFrame.destroy();
			_progressFrame = null;
			
			_popupFrame.removeFromParent();
			_popupFrame.destroy();
			_popupFrame = null;
			
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
		
		private function onCompleteLoading(event:LoadingEvent):void
		{
			Loading.getInstance().init(576, 1024, _resources.getImageFile("loadingImage.png"));
			
			_soundManager.addSound("Rose.mp3", _resources.getSoundFile("Rose.mp3"));
			_soundManager.play("Rose.mp3", Sound.INFINITE, true);
			
			_backGround = new Image(_resources.getSubTexture("TitleSpriteSheet.png", "title"));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_ari = new Image(_resources.getSubTexture("TitleSpriteSheet.png", "ari"));
			_ari.width = 100;
			_ari.height = 100;
			addChild(_ari);
			
			TweenMax.to(_ari, 10, {bezier:{curviness:1.5, timeResolution:0, values:[{x:90, y:172}, {x:173, y:171}, {x:134, y:119}, {x:102, y:203}, {x:164, y:241}, {x:221, y:216}, {x:222, y:158}, {x:138, y:171}, {x:123, y:270}, {x:222, y:315}, {x:315, y:261}, {x:301, y:186}, {x:188, y:217}, {x:188, y:335}, {x:298, y:366}]}});
			//			TweenMax.to(_ari, 10, {bezier:{values:[{x:70, y:263}, {x:202, y:149}, {x:121, y:314}, {x:278, y:205}, {x:164, y:350}, {x:309, y:248}, {x:300, y:345}]}});
			TweenMax.pauseAll();
			
			_popupFrame = new PopupFrame(576, 1024);
			addChild(_popupFrame);
//			_popupFrame.visible = true;
			_popupFrame.show();
			
			_progress = new Progress();
			_progress.init(100, 100);
			
			_progressFrame = new ProgressFrame(576, 1024);
			_progressFrame.setContent(_progress);
			addChild(_progressFrame);
			
			_facebook = FBExtension.getInstance();
			//			_facebook.loadUserInfo();
//			_facebook.logout();
			var isToken:Boolean = _facebook.init();
			
			if(!isToken)
			{
				createLoginButton();
			}
			else
			{
				_facebook.addEventListener(FacebookEvent.TOKEN_SUCCESS, onSuccessToken);
				_facebook.addEventListener(FacebookEvent.TOKEN_FALSE, onFailToken);
				_facebook.loadUserInfo();
			}
		}
		
		private function onFailedLoading(event:LoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
		}
		
		private function createLoginButton():void
		{	
			_facebookLoginButton = new Button(_resources.getSubTexture("TitleSpriteSheet.png", "facebookLoginButton"));
			_facebookLoginButton.alignPivot();
			_facebookLoginButton.x = this.width / 2;
			_facebookLoginButton.y = this.height * 0.7;
			_facebookLoginButton.width = 250;
			_facebookLoginButton.height = 100;
			_facebookLoginButton.addEventListener(Event.TRIGGERED, onClickedLoginButton);
			_popupFrame.addChild(_facebookLoginButton);
		}
		
		private function onFailToken(event:FacebookEvent):void
		{
			_facebook.removeEventListener(FacebookEvent.TOKEN_SUCCESS, onSuccessToken);
			_facebook.removeEventListener(FacebookEvent.TOKEN_FALSE, onFailToken);
			
			createLoginButton();
		}
		
		private function onSuccessToken(event:FacebookEvent):void
		{
			_facebook.removeEventListener(FacebookEvent.TOKEN_SUCCESS, onSuccessToken);
			_facebook.removeEventListener(FacebookEvent.TOKEN_FALSE, onFailToken);
			
			setUser(UserType.Facebook);
			
			trace(User.getInstance().id);
			
//			_facebook.addEventListener(FacebookEvent.LOADED_FRIENDS_LIST, onLoadedFriends);
//			_facebook.loadFriends();
		}
		
		private function onClickedLoginButton(event:Event):void
		{
			_facebook.addEventListener(FacebookEvent.LOGIN_SUCCESS, onSuccessLogin);
			_facebook.login();
		}
		
		private function removePopup():void
		{
//			_popupFrame.visible = false;
			_popupFrame.hide();
			TweenMax.resumeAll();
		}
		
		private function onSuccessLogin(event:FacebookEvent):void
		{
			trace("로그인 성공");
			_facebook.removeEventListener(FacebookEvent.LOGIN_SUCCESS, onSuccessLogin);
			_facebookLoginButton.removeEventListener(Event.TRIGGERED, onClickedLoginButton);
			_facebookLoginButton.removeFromParent();
			_facebookLoginButton.dispose();
			
			setUser(UserType.Facebook);
			
			trace(User.getInstance().id);
		}
		
		private function setUser(userType:String):void
		{
			var user:User = User.getInstance();
			User.getInstance().loadUserState();
			
			_progressFrame.startProgress();
			
			switch(userType)
			{
				case UserType.Facebook :
					user.userType = UserType.Facebook;
					user.id = FacebookUser.getInstance().id;
					user.name = FacebookUser.getInstance().name;
//					user.picture = FacebookUser.getInstance().picture;
					
					user.email = FacebookUser.getInstance().email;
					break;
			}
			
			var now:Date = new Date();
			user.playdate = now.getTime();
			trace(user.playdate);
			trace(new Date(user.playdate).getTime());
			
			user.addEventListener(UserEvent.LOAD_COMPLETE, completeLoadPicture);
			user.loadPicture();
			
			function completeLoadPicture():void
			{
				user.removeEventListener(UserEvent.LOAD_COMPLETE, completeLoadPicture);
				
				switch(userType)
				{
					case UserType.Facebook :
						_facebook.addEventListener(FacebookEvent.LOADED_FRIENDS_LIST, onLoadedFriends);
						_facebook.loadFriends();
						break;
				}
			}
		}
		
		private function onLoadedFriends(event:FacebookEvent):void
		{
			_facebook.removeEventListener(FacebookEvent.LOADED_FRIENDS_LIST, onLoadedFriends);
//			var friends:Dictionary = FacebookUser.getInstance().friends;
//			
//			for(var key:String in friends)
//			{
//				trace(friends[key].name);
//			}
			loadUser();
		}
		
		private function loadUser():void
		{
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteDBLoading);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedDBLoading);
			_dbLoader.setUserData();
		}
		
		private function onCompleteDBLoading(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteDBLoading);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedDBLoading);
			
			User.getInstance().isLoaded = true;
			_progressFrame.stopProgress();
			removePopup();
			
			trace(User.getInstance().clearstage);
		}
		
		private function onFailedDBLoading(event:DBLoaderEvent):void
		{
			_progressFrame.stopProgress();
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteDBLoading);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedDBLoading);
			
			trace(event.message);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
				SceneManager.current.switchScene("stageSelect");
		}
	}
}