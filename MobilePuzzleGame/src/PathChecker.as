package
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class PathChecker extends EventDispatcher
	{
		private var _prevCell:Cell;
		private var _currentCell:Cell;
		
		private var _openNodes:Vector.<Cell>;
		private var _closeNodes:Vector.<Cell>;
		
		private var _currentSearchNode:Cell;
		private var _path:Vector.<Cell>;
		
		public function PathChecker()
		{
			init();
		}
		
		public function init():void
		{
			if(_openNodes != null)
				_openNodes.slice(0, _openNodes.length);
			if(_closeNodes != null)
				_closeNodes.slice(0, _closeNodes.length);
			
			_openNodes = new Vector.<Cell>();
			_closeNodes = new Vector.<Cell>();
		}
		
		public function setPrev(cell:Cell):void
		{
			if(_prevCell != null && (_prevCell != cell))
			{
				_currentCell = cell;
				
				if(_currentCell.block.attribute.type == _prevCell.block.attribute.type)
				{
					checkPath();
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
		
		private function checkPath():void
		{
			goNode(_prevCell);
		}
		
		private function goNode(node:Cell):void
		{
			addCloseNode(node);
			addOpenNodes(node);
		}
		
		private function checkAvailable(node:Cell):Boolean
		{
			if(node.block == null)
				return true;
			else
				return false;
		}
		
		private function checkOpenNodes(node:Cell):Boolean
		{
			for(var i:int = 0; i < _openNodes.length; i++)
			{
				if(node == _openNodes[i])
					return true;
			}
			
			return false;
		}
		
		private function removeFromOpenNodes(node:Cell):void
		{
			var index:int = _openNodes.indexOf(node);
			if(index < 0)
				return;
			_openNodes.removeAt(index);
		}
		
		private function addOpenNodes(node:Cell):void
		{
			var types:Vector.<int> = NeigborType.TYPES;
			for(var i:int = 0; i < types.length; i++)
			{
				if(_prevCell.neigbor[types[i]].block == null)
				{
					trace(_prevCell.neigbor[types[i]].name);
					_openNodes.push(_prevCell.neigbor[types[i]]);
				}
				else
					addCloseNode(_prevCell.neigbor[types[i]]);
			}
			types.splice(0, types.length);
			types = null;
		}
		
		private function addCloseNode(node:Cell):void
		{
			removeFromOpenNodes(node);
			_closeNodes.push(node);
		}
	}
}