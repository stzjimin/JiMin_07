package puzzle.ingame.timer
{	
	import puzzle.loading.Resources;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Timer extends Sprite implements IAnimatable
	{	
		public static const TIME_START:String = "timeStart";
		public static const TIME_OVER:String = "timeOver";
		
		private var _resources:Resources;
		
		private var _countTime:Number;
		private var _originTime:Number;
		
		private var _time:Number;
		private var _juggler:Juggler;
		
		private var _timerTween:Tween;
		
		private var _bar:Image;
		private var _fillBar:Image;
		private var _fillFront:Image;
		private var _fillBack:Image;
		
		private var _fillBackOriginScaleX:Number;
		
		/**
		 * 제한시간을 나타내는 클래스입니다.
		 * @param resources
		 * 
		 */		
		public function Timer(resources:Resources)
		{
			_resources = resources;
		}
		
		/**
		 * 길이와 높이를 받아와서 초기화시키는 함수입니다. timer는 bar, fillFront, fillBack으로 구성되어있습니다.
		 * @param width
		 * @param height
		 * 
		 */		
		public function init(width:Number, height:Number):void
		{
			_juggler = new Juggler();
			
//			this.x = x;
//			this.y = y;
			
			_bar = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "timerFrame"));
			_bar.width = width;
			_bar.height = height;
			addChild(_bar);
			
			_fillFront = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "timerFront2"));
			_fillFront.width = width/20;
			_fillFront.height = height;
			addChild(_fillFront);
			
			_fillBack = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "timerBack2"));
			_fillBack.x = _fillFront.width;
			_fillBack.width = width - _fillFront.width;
			_fillBack.height = height;
			_fillBackOriginScaleX = _fillBack.scaleX;
			addChild(_fillBack);
		}
		
		/**
		 * timer를 제거하고 할당된 메모리를 해제해주는 함수입니다. 
		 * 
		 */		
		public function destroy():void
		{
			_juggler.purge();
			
			_bar.removeFromParent();
			_bar.dispose();
			_bar = null;
			
			_fillFront.removeFromParent();
			_fillFront.dispose();
			_fillFront = null;
			
			_fillBack.removeFromParent();
			_fillBack.dispose();
			_fillBack = null;
			
			dispose();
		}
		
		/**
		 * 제한시간의 카운트다운을 시작하는 함수입니다. 이 때 제한시간을 인자로 받아옵니다. 
		 * @param countTime
		 * 
		 */		
		public function startCount(countTime:Number):void
		{
			if(countTime < 0)
				return;
			_time = 0;
			_countTime = countTime;
			_originTime = countTime;
			
			_timerTween = new Tween(_fillBack, countTime);
			_timerTween.scaleXTo(0);
			_timerTween.addEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
			_juggler.add(_timerTween);
			
//			var tween:Tween = new Tween(_fillBack, 60);
//			tween.scaleXTo(0);
//			tween.addEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
//			_juggler.add(tween);
			
			function onCompleteTween(event:Event):void
			{
				_timerTween.removeEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
				dispatchEvent(new Event(Timer.TIME_OVER));
			}
		}
		
		/**
		 * 현재까지의 시간에서 추가적으로 제한시간을 늘려줄 때 사용하는 함수입니다. 
		 * @param addTime
		 * 
		 */		
		public function addTime(addTime:Number):void
		{
//			trace("_countTime : " + _countTime);
//			trace("_timerTween.currentTime : " + _timerTween.currentTime);
//			trace("추가 시간 : " + addTime);
			var newTime:Number = (_countTime - _timerTween.currentTime + addTime);
//			trace("시간 : " + newTime);
			var fillBackNewScaleX:Number = _fillBack.scaleX + (_fillBackOriginScaleX * (addTime / _originTime));
			
			if(newTime > _originTime)
			{
				newTime = _originTime;
				fillBackNewScaleX = _fillBackOriginScaleX;
			}
			
			_fillBack.scaleX = fillBackNewScaleX;
			_timerTween.reset(_fillBack, newTime);
			_countTime = newTime;
			_timerTween.scaleXTo(0);
		}
		
		public function advanceTime(time:Number):void
		{
			_juggler.advanceTime(time);
		}
		
		public function getRecord():Number
		{
			return (_countTime - _timerTween.currentTime);
		}
	}
}