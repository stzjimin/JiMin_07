package ingame.blocks
{
	public class Attribute
	{
		private var _type:String;
		private var _skill:String = null;
		
		public function Attribute()
		{
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get skill():String
		{
			return _skill;
		}

		public function set skill(value:String):void
		{
			_skill = value;
		}


	}
}