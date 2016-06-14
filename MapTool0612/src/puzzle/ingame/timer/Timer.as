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
		
		public function Timer(resources:Resources)
		{
			_resources = resources;
		}
		
		public function init(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			_juggler = new Juggler();
			
			this.x = x;
			this.y = y;
			
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
		
		public function destroy():void
		{
			_juggler.purge();
			
			dispose();
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