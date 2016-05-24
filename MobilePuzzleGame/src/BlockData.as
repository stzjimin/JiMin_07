package
{
	public class BlockData
	{
		private var _colum:int;
		private var _row:int;
		private var _type:String;
		
		public function BlockData(colum:int, row:int, type:String)
		{
			_colum = colum;
			_row = row;
			_type = type;
		}

		public function get colum():int
		{
			return _colum;
		}

		public function get row():int
		{
			return _row;
		}

		public function get type():String
		{
			return _type;
		}


	}
}