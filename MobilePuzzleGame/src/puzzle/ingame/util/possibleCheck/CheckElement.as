package puzzle.ingame.util.possibleCheck
{
	import puzzle.ingame.cell.Cell;

	public class CheckElement
	{
		private var _startCell:Cell;
		private var _destCell:Cell;
		private var _path:Vector.<Cell>;
		
		public function CheckElement(startCell:Cell, destCell:Cell, path:Vector.<Cell>)
		{
			_startCell = startCell;
			_destCell = destCell;
			_path = path;
		}
		
		public function get path():Vector.<Cell>
		{
			return _path;
		}

		public function set path(value:Vector.<Cell>):void
		{
			_path = value;
		}

		public function destroy():void
		{
			_startCell = null;
			_destCell = null;
			
			if(_path != null)
			{
				_path.splice(0, _path.length);	
			}
		}

		public function get destCell():Cell
		{
			return _destCell;
		}

		public function set destCell(value:Cell):void
		{
			_destCell = value;
		}

		public function get startCell():Cell
		{
			return _startCell;
		}

		public function set startCell(value:Cell):void
		{
			_startCell = value;
		}

	}
}