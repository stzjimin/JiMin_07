package ingame.util.possibleCheck
{
	import ingame.cell.Cell;

	public class State
	{
		private var _node:Cell;
		private var _prevNode:Cell;
		private var _curveCount:int;
		private var _path:Vector.<Cell>;
		private var _priority:int;
		
		public function State()
		{
		}
		
		public function distroy():void
		{
			_node = null;
			_prevNode = null;
			_path.splice(0, _path.length);
			_path = null;
		}

		public function get node():Cell
		{
			return _node;
		}

		public function set node(value:Cell):void
		{
			_node = value;
		}

		public function get curveCount():int
		{
			return _curveCount;
		}

		public function set curveCount(value:int):void
		{
			_curveCount = value;
		}

		public function get prevNode():Cell
		{
			return _prevNode;
		}

		public function set prevNode(value:Cell):void
		{
			_prevNode = value;
		}

		public function get path():Vector.<Cell>
		{
			return _path;
		}

		public function set path(value:Vector.<Cell>):void
		{
			_path = value;
		}

		public function get priority():int
		{
			return _priority;
		}

		public function set priority(value:int):void
		{
			_priority = value;
		}


	}
}