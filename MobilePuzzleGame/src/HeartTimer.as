package
{
	import puzzle.user.User;
	import puzzle.user.UserEvent;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class HeartTimer extends TextField implements IAnimatable
	{
		public static const PUSH_HEART:String = "pushHeart";
		
		private var _juggler:Juggler;
		private var _isFull:Boolean;
		private var _pushTime:uint;
		private var _remainTime:uint;
		
		public function HeartTimer(width:Number, height:Number, text:String = "", format:TextFormat = null)
		{
			_juggler = new Juggler();
			super(width, height, text, format);
		}
		
		public function init(pushTime:uint):void
		{
			Starling.juggler.add(this);
			_pushTime = pushTime;
			_remainTime = User.getInstance().heartTime;
			this.text = (_remainTime / 60).toString() + " : " + (_remainTime % 60).toString();
			_juggler.repeatCall(count, 1.0);
			
			User.getInstance().addEventListener(UserEvent.CHANGE_HEART, onChangeHeart);
			if(User.getInstance().heart >= 5)
			{
				_isFull = true;
				this.text = "MAX";
			}
		}
		
		public function destroy():void
		{
			User.getInstance().removeEventListener(UserEvent.CHANGE_HEART, onChangeHeart);
			
			_juggler.purge();
			Starling.juggler.remove(this);
			
			dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			if(!_isFull)
				_juggler.advanceTime(time);
		}
		
		private function count():void
		{
			_remainTime -= 1;
			this.text = int(_remainTime / 60).toString() + " : " + int(_remainTime % 60).toString();
			if(_remainTime <= 0)
			{
				_remainTime = _pushTime;
				pushHeart();
			}
			User.getInstance().heartTime = _remainTime;
		}
		
		private function pushHeart():void
		{
//			User.getInstance().pushHeart();
			User.getInstance().heart += 1;
//			trace("heart push");
		}
		
		private function onChangeHeart(event:UserEvent):void
		{
			if((User.getInstance().heart) >= 5)
			{
				_isFull = true;
				_remainTime = _pushTime;
				this.text = "MAX";
			}
			else
			{
				_isFull = false;
//				_remainTime = _pushTime;
			}
		}
	}
}