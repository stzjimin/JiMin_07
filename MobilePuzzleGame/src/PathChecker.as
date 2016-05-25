package
{
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class PathChecker extends EventDispatcher
	{
		private const FINDPATH_LIMIT:int = 20;
		
		private var _prevCell:Cell;
		private var _currentCell:Cell;
		
		private var _openNodes:Vector.<Cell>;
		private var _closeNodes:Vector.<Cell>;
		
		private var _currentSearchNode:Cell;
		private var _path:Vector.<Cell>;
		
		private var _possible:Dictionary;
		
		public function PathChecker()
		{
			init();
		}
		
		public function init():void
		{
			if(_possible != null)
			{
				for(var key:String in _possible)
					delete _possible[key];
			}
			_possible = new Dictionary();
			
			if(_openNodes != null)
				_openNodes.splice(0, _openNodes.length);
			if(_closeNodes != null)
				_closeNodes.splice(0, _closeNodes.length);
			if(_path != null)
				_path.splice(0, _path.length);
			
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
//					checkPath();
					if(_currentCell.checkPossibleCell(_prevCell))
					{
						var array:Array = new Array();
						array.push(_prevCell);
						array.push(_currentCell);
						dispatchEvent(new Event(CheckEvent.SAME, false, array));
					}
				}
				outChecker(_prevCell);
				outChecker(_currentCell);
				_prevCell = null;
				_currentCell = null;
			}
			else
				_prevCell = cell;
		}
		
		public function checkPossibleCell(cells:Vector.<Cell>):void
		{
			var dist:int;
			var k:int;
			var isBlocked:Boolean;
			
			for(var i:int = 0; i < cells.length-1; i++)
			{
				if(cells[i].block == null)
					continue;	//블록이 없는 경우는 검사할 필요가 없으니 제외
				
				for(var j:int = i+1; j < cells.length; j++)
				{
					if(cells[j].block == null)
						continue;	//블록이 없는 경우는 검사할 필요가 없으니 제외
					
					if(cells[i].row == cells[j].row)
					{
						//일직선상에 있는 경우
						if(Math.abs(cells[i].colum - cells[j].colum) == 1)
						{
							//붙어있는 경우
							cells[i].addPossibleCell(cells[j]);
							cells[j].addPossibleCell(cells[i]);
						}
						else
						{
							dist = j-i;
							isBlocked = false;
							for(k = 1; k < dist; k++)
							{
								if(cells[j-k].block != null)
								{
									isBlocked = true;
									break;
								}
							}
							if(!isBlocked)
							{
								cells[i].addPossibleCell(cells[j]);
								cells[j].addPossibleCell(cells[i]);
							}
						}
					}
					else if(cells[i].colum == cells[j].colum)
					{
						trace("i = " + i);
						trace("j = " + j);
						//일직선상에 있는 경우
						if(Math.abs(cells[i].row - cells[j].row) == 1)
						{
							//붙어있는 경우
							cells[i].addPossibleCell(cells[j]);
							cells[j].addPossibleCell(cells[i]);
						}
						else
						{
							dist = j-i;
							isBlocked = false;
							for(k = Field.ROW_NUM; k < dist; k+=Field.ROW_NUM)
							{
								if(cells[j-k].block != null)
								{
									isBlocked = true;
									break;
								}
							}
							if(!isBlocked)
							{
								cells[i].addPossibleCell(cells[j]);
								cells[j].addPossibleCell(cells[i]);
							}
						}
					}
					else
					{
						//row, colum 모두가 다를 때
					}
				}
			}
		}
		
		private function findPath(startNode:Cell, destNode:Cell):void
		{
			var count:int = 0;
			var priority:int;
			var currentNode:Cell = startNode;
			
			if(Math.abs(startNode.row - destNode.row) > Math.abs(startNode.colum - destNode.colum))
			{
				if((startNode.row - destNode.row) > 0)
					priority = NeigborType.LEFT;
				else
					priority = NeigborType.RIGHT;
			}
			else
			{
				if((startNode.colum - destNode.colum) > 0)
					priority = NeigborType.TOP;
				else
					priority = NeigborType.BOTTOM;
			}
			
			checkPath(currentNode);
			
			while(count < FINDPATH_LIMIT)
			{
				if(_openNodes.length == 0)
					return;
			}
		}
		
		public function outChecker(cell:Cell):void
		{
			cell.dispatchEvent(new Event(CheckEvent.PULL_PREV));
		}
		
		private function checkPath(node:Cell):void
		{
			goNode(node);
		}
		
		private function goNode(node:Cell):void
		{
			addCloseNode(node);
			addOpenNodes(node);
			_path.push(node);
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