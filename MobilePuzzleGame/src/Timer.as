package
{
	import starling.animation.Juggler;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;

	public class Timer extends Sprite
	{
		private var _juggler:Juggler;
		
		public function Timer()
		{
			_juggler = new Juggler();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFram);
		}
		
		public override function dispose():void
		{
			_juggler.purge();
			super.dispose();
		}
		
		private function onEnterFram(event:EnterFrameEvent):void
		{
			
		}
	}
}