package puzzle.ingame.cell.blocks
{
	public class BlockData
	{
		private var _row:uint;
		private var _column:uint;
		
		private var _type:String;
		private var _skill:String;
		
		/**
		 * 블걱의 위치와 해당 블럭의 타입이 저장되어있는 데이터 클래스입니다.(블럭스킬은 미구현) 
		 * @param row
		 * @param colum
		 * @param type
		 * @param skill
		 * 
		 */		
		public function BlockData(row:uint = 0, colum:uint = 0, type:String = null, skill:String = null)
		{
			_row = row;
			_column = colum;
			_type = type;
			_skill = skill;
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

		public function get row():uint
		{
			return _row;
		}

		public function set row(value:uint):void
		{
			_row = value;
		}

		public function get column():uint
		{
			return _column;
		}

		public function set column(value:uint):void
		{
			_column = value;
		}


	}
}