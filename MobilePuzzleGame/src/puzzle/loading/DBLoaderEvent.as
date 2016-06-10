package puzzle.loading
{
	import starling.events.Event;

	public class DBLoaderEvent extends Event
	{
		public static const COMPLETE:String = "dbLoaderComplete";
		public static const FAILED:String = "dbLoaderFailed";
		
		public static const PLAYDATE_CHANGE:String = "playdateChange";
		
		public static const COLUMN_ID:String = "id";
		public static const COLUMN_NAME:String = "name";
		public static const COLUMN_EMAIL:String = "email";
		public static const COLUMN_PLAYDATE:String = "playdate";
		public static const COLUMN_CLEARSTAGE:String = "clearstage";
		
		private var _message:String;
		
		public function DBLoaderEvent(type:String, message:String = null)
		{
			super(type);
			_message = message;
		}

		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}

	}
}