package
{
	public class GravityManager
	{	
		private static var _sGravity:String;
		
		public function GravityManager()
		{
			
		}

		public static function get gravity():String
		{
			return _sGravity;
		}

		public static function set gravity(value:String):void
		{
			_sGravity = value;
		}

	}
}