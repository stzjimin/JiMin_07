package
{
	import flash.display.Bitmap;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Timer extends Sprite
	{	
		[Embed(source="bar.png")]
		private const testBarImage:Class;
		
		[Embed(source="fill.png")]
		private const testFillImage:Class;
		
		public static const TIME_START:String = "timeStart";
		public static const TIME_OVER:String = "timeOver";
		
		private var _countTime:uint;
		
		private var _time:Number;
		private var _juggler:Juggler;
		
		private var _bar:Image;
		private var _fill:Image;
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
			
			_bar = new Image(Texture.fromBitmap(new testBarImage() as Bitmap));
			_bar.width = width;
			_bar.height = height;
			addChild(_bar);
			
			_fill = new Image(Texture.fromBitmap(new testFillImage() as Bitmap));
			_fill.x = width*0.16;
			_fill.width = width*0.75;
			_fill.height = height;
			addChild(_fill);
		}
		
		public function update(ratio:Number):void
		{
			_ratio += ratio
			_fill.setTexCoords(0, _ratio, 0);
			_fill.setTexCoords(2, _ratio, 1);
			_fill.setTexCoords(1, 1+_ratio, 0);
			_fill.setTexCoords(3, 1+_ratio, 1);
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