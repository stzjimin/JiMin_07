package Puzzle.ingame.timer
{
	import Puzzle.Resources;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Timer extends Sprite implements IAnimatable
	{	
		public static const TIME_START:String = "timeStart";
		public static const TIME_OVER:String = "timeOver";
		
		private var _resources:Resources;
		
		private var _countTime:uint;
		
		private var _time:Number;
		private var _juggler:Juggler;
		
		private var _bar:Image;
		private var _fillFront:Image;
		private var _fillBack:Image;
		private var _ratio:Number;
		
		public function Timer(resources:Resources)
		{
			_resources = resources;
		}
		
		public function init(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			_juggler = new Juggler();
			_ratio = 0;
			
			this.x = x;
			this.y = y;
			
			_bar = new Image(_resources.getSubTexture("IngameSprite2.png", "timerFrame"));
			_bar.width = width;
			_bar.height = height;
			addChild(_bar);
			
			_fillFront = new Image(_resources.getSubTexture("IngameSprite2.png", "timerFront2"));
			_fillFront.width = width/20;
			_fillFront.height = height;
			addChild(_fillFront);
			
			_fillBack = new Image(_resources.getSubTexture("IngameSprite2.png", "timerBack2"));
			_fillBack.x = _fillFront.width;
			_fillBack.width = width - _fillFront.width;
			_fillBack.height = height;
			addChild(_fillBack);
		}
		
		public function update(ratio:Number):void
		{
			_fillBack.scaleX -= ratio;
//			_ratio += ratio
//			_fillBack.setTexCoords(0, _ratio, 0);
//			_fillBack.setTexCoords(2, _ratio, 1);
//			_fillBack.setTexCoords(1, 1+_ratio, 0);
//			_fillBack.setTexCoords(3, 1+_ratio, 1);
		}
		
		public function startCount(countTime:uint):void
		{
			if(countTime < 0)
				return;
			_time = 0;
			_countTime = countTime;
			_juggler.repeatCall(onSec, 1.0, countTime);
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
		
		private function onSec():void
		{
			_time++;
			update(1/_countTime);
			if(_time >= _countTime)
				dispatchEvent(new Event(TIME_OVER));
		}
	}
}