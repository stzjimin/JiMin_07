package
{
	import starling.animation.Juggler;
	import starling.display.Sprite;

	public class Timer extends Sprite
	{
		private var _time:Number;
		
		private var _juggler:Juggler;
		
		public function Timer()
		{
			_juggler = new Juggler();
			_juggler.repeatCall(onSec, 1.0, 60);
			_time = 0;
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
		}
	}
}