package title
{
	import flash.display.Bitmap;
	
	import customize.Scene;
	import customize.SceneManager;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
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
		
		private var _juggler:Juggler;
		private var _ariTween:Tween;
		
		private var _backGround:Image;
		private var _ari:Image;
		
		public function TitleScene()
		{
			super();
			
			_juggler = new Juggler();
			
			_backGround = new Image(Texture.fromBitmap(new titleImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
//			_ari = new Image(Texture.fromBitmap(new ariImage() as Bitmap));
//			_ari.width = 100;
//			_ari.height = 100;
//			addChild(_ari);
//			
//			_ariTween = new Tween(_ari, 60, Transitions.EASE_OUT_BOUNCE);
//			_ariTween.moveTo(576, 1024);
//			
//			_juggler.add(_ariTween);
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