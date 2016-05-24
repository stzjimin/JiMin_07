package
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class PathChecker extends EventDispatcher
	{
		private var _prevCell:Cell;
		private var _currentCell:Cell;
		
		public function PathChecker()
		{
		}
		
		public function setPrev(cell:Cell):void
		{
			if(_prevCell != null)
			{
				_currentCell = cell;
				if(_currentCell.block.attribute.type == _prevCell.block.attribute.type)
				{
					var array:Array = new Array();
					array.push(_prevCell);
					array.push(_currentCell);
					dispatchEvent(new Event(CheckEvent.SAME, false, array));
				}
				outChecker(_prevCell);
				outChecker(_currentCell);
				_prevCell = null;
				_currentCell = null;
			}
			else
				_prevCell = cell;
		}
		
		public function outChecker(cell:Cell):void
		{
			cell.dispatchEvent(new Event(CheckEvent.PULL_PREV));
		}
	}
}