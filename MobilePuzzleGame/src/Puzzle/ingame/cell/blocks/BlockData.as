package Puzzle.ingame.cell.blocks
{
	public class BlockData
	{
		private var _row:uint;
		private var _colum:uint;
		
		private var _type:String;
		private var _skill:String;
		
		public function BlockData(row:uint = 0, colum:uint = 0, type:String = null, skill:String = null)
		{
			_row = row;
			_colum = colum;
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

		public function get colum():uint
		{
			return _colum;
		}

		public function set colum(value:uint):void
		{
			_colum = value;
		}


	}
}