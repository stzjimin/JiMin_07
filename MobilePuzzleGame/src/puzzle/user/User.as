package puzzle.user
{
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError;

	public class User
	{
		private static var _instance:User;
		
		private var _userType:String;
		
		private var _id:String;
		private var _name:String;
		private var _picture:Bitmap;
		
		public function User()
		{
			if (!_instance)
			{
				_instance = this;
			}
			else
			{
				throw new IllegalOperationError("User가 이미 만들어져있습니다. User는 싱글톤 클래스에요!!");
			}
		}
		
		public static function getInstance():User
		{
			return _instance ? _instance : new User();
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get userType():String
		{
			return _userType;
		}

		public function set userType(value:String):void
		{
			_userType = value;
		}

		public function get picture():Bitmap
		{
			return _picture;
		}

		public function set picture(value:Bitmap):void
		{
			_picture = value;
		}
	}
}