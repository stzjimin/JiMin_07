package puzzle.user
{
	import starlingOrigin.events.Event;

	public class UserEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "completeLoad";
		
		public static const CHANGE_HEART:String = "changeHeart";
//		public static const POP_HEART:String = "popHeart";
		public static const CHANGE_FORK:String = "changeFork";
//		public static const POP_FORK:String = "popFork";
		public static const CHANGE_SHUFFLE:String = "changeShuffle";
//		public static const POP_SHUFFLE:String = "popShuffle";
		public static const CHANGE_SEARCH:String = "changeSearch";
//		public static const POP_SEARCH:String = "popSearch";
		
		public static const PUSH:String = "push";
		public static const POP:String = "pop";
		
		private var _pushpop:String;
		
		public function UserEvent(type:String, pushpop:String = null, bubbles:Boolean=false, data:Object = null)
		{
			_pushpop = pushpop;
			super(type, bubbles, data);
		}

		public function get pushpop():String
		{
			return _pushpop;
		}

		public function set pushpop(value:String):void
		{
			_pushpop = value;
		}

	}
}