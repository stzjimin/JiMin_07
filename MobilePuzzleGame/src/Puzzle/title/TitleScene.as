package puzzle.title
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import customize.Scene;
	import customize.SceneManager;
	
	import puzzle.Popup;
	import puzzle.loader.Resources;
	
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
		
//		private var _facebook:FBExtension;
		
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
			
			_backGround = new Image(Texture.fromBitmap(new titleImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_ari = new Image(Texture.fromBitmap(new ariImage() as Bitmap));
			_ari.width = 100;
			_ari.height = 100;
			addChild(_ari);
			
			
			TweenMax.to(_ari, 10, {bezier:{curviness:1.5, timeResolution:0, values:[{x:90, y:172}, {x:173, y:171}, {x:134, y:119}, {x:102, y:203}, {x:164, y:241}, {x:221, y:216}, {x:222, y:158}, {x:138, y:171}, {x:123, y:270}, {x:222, y:315}, {x:315, y:261}, {x:301, y:186}, {x:188, y:217}, {x:188, y:335}, {x:298, y:366}]}});
//			TweenMax.to(_ari, 10, {bezier:{values:[{x:70, y:263}, {x:202, y:149}, {x:121, y:314}, {x:278, y:205}, {x:164, y:350}, {x:309, y:248}, {x:300, y:345}]}});
			
//			_facebook = FBExtension.getInstance();
//			_facebook.logout();
//			var isLogin:Boolean = _facebook.init();
//			
//			if(!isLogin)
//			{
//				TweenMax.pauseAll();
//				_popUp = new Popup(0, 0, null);
//				addChild(_popUp);
//				_popUp.visible = true;
//				
//				_facebookLoginButton = new Button(Texture.fromBitmap(new loginButtonImage() as Bitmap));
//				_facebookLoginButton.alignPivot();
//				_facebookLoginButton.x = this.width / 2;
//				_facebookLoginButton.y = this.height * 0.7;
//				_facebookLoginButton.width = 250;
//				_facebookLoginButton.height = 100;
//				_facebookLoginButton.addEventListener(Event.TRIGGERED, onClickedLoginButton);
//				_popUp.addChild(_facebookLoginButton);
//			}
			
//			_ariTween = new Tween(_ari, 60, Transitions.EASE_IN);
//			_ariTween.moveTo(576, 1024);
//			
//			_juggler.add(_ariTween);
		}
		
		public override function destroy():void
		{
			TweenMax.killAll();
			
			_backGround.removeEventListener(TouchEvent.TOUCH, onTouch);
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_ari.removeFromParent();
			_ari.dispose();
			_ari = null;
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
		
//		private function onClickedLoginButton(event:Event):void
//		{
//			_facebook.addEventListener(FacebookEvent.LOGIN_SUCCESS, onSuccess);
//			_facebook.login();
//		}
//		
//		private function onSuccess(event:FacebookEvent):void
//		{
//			trace("로그인 성공");
//			TweenMax.resumeAll();
//			_facebook.removeEventListener(FacebookEvent.LOGIN_SUCCESS, onSuccess);
//			_facebookLoginButton.removeEventListener(Event.TRIGGERED, onClickedLoginButton);
//			_facebookLoginButton.removeFromParent();
//			_facebookLoginButton.dispose();
//			
//			_popUp.removeFromParent();
//			_popUp.destroy();
//			
//			trace(FacebookUser.getInstance().id);
//			
//			_facebook.addEventListener(FacebookEvent.LOADED_FRIENDS_LIST, onLoadedFriends);
//			_facebook.loadFriends();
//		}
//		
//		private function onLoadedFriends(event:FacebookEvent):void
//		{
//			var friends:Dictionary = FacebookUser.getInstance().friends;
//			
//			for(var key:String in friends)
//			{
//				trace(friends[key].name);
//			}
//			
//			_facebook.score();
////			trace("친구창");
////			trace(event.message);
////			var jsonObject:Object = JSON.parse(event.message);
////			trace(jsonObject);
////			trace(jsonObject[0].id);
////			trace(jsonObject[0].name);
//		}
		
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