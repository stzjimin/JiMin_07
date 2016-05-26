package
{
	public class State
	{
		private var _node:Cell;
		private var _prevNode:Cell;
		private var _curveCount:int;
		private var _prevDirection:int;
		private var _currentDirection:int;
		
		public function State()
		{
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

		public function get prevDirection():int
		{
			return _prevDirection;
		}

		public function set prevDirection(value:int):void
		{
			_prevDirection = value;
		}

		public function get currentDirection():int
		{
			return _currentDirection;
		}

		public function set currentDirection(value:int):void
		{
			_currentDirection = value;
		}

		public function get prevNode():Cell
		{
			return _prevNode;
		}

		public function set prevNode(value:Cell):void
		{
			_prevNode = value;
		}


	}
}