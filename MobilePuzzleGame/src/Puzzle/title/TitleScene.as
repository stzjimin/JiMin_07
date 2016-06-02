package Puzzle.title
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirFacebook.FacebookPermissionEvent;
	
	import flash.display.Bitmap;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	
	import Puzzle.Popup;
	import Puzzle.Resources;
	
	import customize.Scene;
	import customize.SceneManager;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class TitleScene extends Scene
	{
		[Embed(source="title.jpg")]
		private const titleImage:Class;
		
		[Embed(source="ari.png")]
		private const ariImage:Class;
		
		[Embed(source="facebookLoginButton.png")]
		private const loginButtonImage:Class;
		
		private var _spriteDir:File = File.applicationDirectory.resolvePath("puzzle/title");
		private var _resources:Resources;
		
		private var _juggler:Juggler;
		private var _ariTween:Tween;
		
		private var _facebook:FBExtension;
		
		private var _popUp:Popup;
		private var _facebookLoginButton:Button;
		
		private var _backGround:Image;
		private var _ari:Image;
		
		public function TitleScene()
		{
			super();
			
			_resources = new Resources(_spriteDir);
//			_resources.addSpriteName("
			
			_juggler = new Juggler();
			
			_facebook = FBExtension.getInstance();
			_facebook.logout();
			var isLogin:Boolean = _facebook.init();
			
			_backGround = new Image(Texture.fromBitmap(new titleImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			if(!isLogin)
			{
				_popUp = new Popup(0, 0, null);
				addChild(_popUp);
				_popUp.visible = true;
				
				_facebookLoginButton = new Button(Texture.fromBitmap(new loginButtonImage() as Bitmap));
				_facebookLoginButton.alignPivot();
				_facebookLoginButton.x = this.width / 2;
				_facebookLoginButton.y = this.height * 0.7;
				_facebookLoginButton.width = 250;
				_facebookLoginButton.height = 100;
				_facebookLoginButton.addEventListener(Event.TRIGGERED, onClickedLoginButton);
				_popUp.addChild(_facebookLoginButton);
			}
			
//			_ari = new Image(Texture.fromBitmap(new ariImage() as Bitmap));
//			_ari.width = 100;
//			_ari.height = 100;
//			addChild(_ari);
//			
//			_ariTween = new Tween(_ari, 60, Transitions.EASE_IN);
//			_ariTween.moveTo(576, 1024);
//			
//			_juggler.add(_ariTween);
		}
		
		private function onClickedLoginButton(event:Event):void
		{
			_facebook.addEventListener(FacebookEvent.LOGIN_SUCCESS, onSuccess);
			_facebook.login();
		}
		
		private function onSuccess(event:FacebookEvent):void
		{
			trace(event.message);
			_facebook.removeEventListener(FacebookEvent.LOGIN_SUCCESS, onSuccess);
			_facebookLoginButton.removeEventListener(Event.TRIGGERED, onClickedLoginButton);
			_facebookLoginButton.removeFromParent();
			_facebookLoginButton.dispose();
			
			_popUp.removeFromParent();
			_popUp.destroy();
			
//			_facebook.addEventListener(FacebookEvent.LOADED_FRIENDS_LIST, onLoadedFriends);
//			_facebook.loadFriends();
//			trace("aa");
//			_facebook.login([]);
		}
		
		private function onLoadedFriends(event:FacebookEvent):void
		{
			trace("친구창");
			trace(event.message);
			var jsonObject:Object = JSON.parse(event.message);
			trace(jsonObject);
			trace(jsonObject[0].id);
			trace(jsonObject[0].name);
		}
		
		public override function destroy():void
		{
			_backGround.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		protected override function onStart(event:Event):void
		{
			//음악 on
		}
		
		protected override function onEnded(event:Event):void
		{
			//음악 off
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			_juggler.advanceTime(event.passedTime);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
				SceneManager.current.switchScene("game");
		}
	}
}