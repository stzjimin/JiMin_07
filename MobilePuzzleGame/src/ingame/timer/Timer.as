package ingame.timer
{
	import flash.display.Bitmap;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Timer extends Sprite implements IAnimatable
	{	
//		[Embed(source="bar.png")]
//		private const testBarImage:Class;
//		
		[Embed(source="fill.png")]
		private const testFillImage:Class;
		
		[Embed(source="timerFrame.png")]
		private const timerFrameImage:Class;
		
		[Embed(source="timerFront2.png")]
		private const timerFrontImage:Class;
		
		[Embed(source="timerBack2.png")]
		private const timerBackImage:Class;
		
		public static const TIME_START:String = "timeStart";
		public static const TIME_OVER:String = "timeOver";
		
		private var _countTime:uint;
		
		private var _time:Number;
		private var _juggler:Juggler;
		
		private var _bar:Image;
		private var _fillFront:Image;
		private var _fillBack:Image;
		private var _ratio:Number;
		
		public function Timer()
		{
		}
		
		public function init(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			_juggler = new Juggler();
			_ratio = 0;
			
			this.x = x;
			this.y = y;
			
			_bar = new Image(Texture.fromBitmap(new timerFrameImage() as Bitmap));
			_bar.width = width;
			_bar.height = height;
			addChild(_bar);
			
			_fillFront = new Image(Texture.fromBitmap(new timerFrontImage() as Bitmap));
			_fillFront.width = width/20;
			_fillFront.height = height;
			addChild(_fillFront);
			
			_fillBack = new Image(Texture.fromBitmap(new timerBackImage() as Bitmap));
			_fillBack.x = _fillFront.width;
			_fillBack.width = width - _fillFront.width;
			_fillBack.height = height;
			addChild(_fillBack);
		}
		
		public function update(ratio:Number):void
		{
			_ratio += ratio
			_fillBack.setTexCoords(0, _ratio, 0);
			_fillBack.setTexCoords(2, _ratio, 1);
			_fillBack.setTexCoords(1, 1+_ratio, 0);
			_fillBack.setTexCoords(3, 1+_ratio, 1);
		}
		
		public function startCount(countTime:uint):void
		{
			if(countTime < 0)
				return;
			_time = 0;
			_countTime = countTime;
			_juggler.repeatCall(onSec, 1.0, countTime);
		}
		
		public function distroy():void
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