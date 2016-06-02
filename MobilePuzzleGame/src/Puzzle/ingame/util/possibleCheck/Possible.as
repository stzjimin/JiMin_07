package Puzzle.ingame.util.possibleCheck
{
	import Puzzle.ingame.cell.Cell;

	public class Possible
	{
		private var _startCell:Cell;
		private var _destCell:Cell;
		private var _path:Vector.<Cell>;
		
		public function Possible()
		{
		}
		
		public function distroy():void
		{
			_startCell = null;
			_destCell = null;
			_path.splice(0, _path.length);
			_path = null;
		}

		public function get startCell():Cell
		{
			return _startCell;
		}

		public function set startCell(value:Cell):void
		{
			_startCell = value;
		}

		public function get destCell():Cell
		{
			return _destCell;
		}

		public function set destCell(value:Cell):void
		{
			_destCell = value;
		}

		public function get path():Vector.<Cell>
		{
			return _path;
		}

		public function set path(value:Vector.<Cell>):void
		{
			_path = value;
		}


	}
}