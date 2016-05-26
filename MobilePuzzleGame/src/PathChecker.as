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
		
		private var _neigborTypes:Vector.<int> = NeigborType.TYPES;
		private var _cells:Vector.<Cell>;
		
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
			
			_path = new Vector.<Cell>();
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
//					trace(_currentCell.name);
//					trace(_prevCell.name);
//					init();
//					findPath(_prevCell, _currentCell);
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
			var direction:int;
			var distRow:int;
			var distColum:int;
			var k:int;
			var isBlocked:Boolean;
			_cells = cells;
			
			for(var i:int = 0; i < cells.length-1; i++)
			{
				if(cells[i].block == null)
					continue;	//블록이 없는 경우는 검사할 필요가 없으니 제외
				
				for(var j:int = i+1; j < cells.length; j++)
				{
					if(cells[j].block == null)
						continue;	//블록이 없는 경우는 검사할 필요가 없으니 제외
					
					if(cells[i].block.attribute.type == cells[j].block.attribute.type)
					{
//						if(cells[i].name == "2/2")
//						{
////							trace("aa");
//						}
						trace("startNode = " + cells[i].name);
						trace("destNode = " + cells[j].name);
						if(findPath(cells[i], cells[j]))
						{
//							trace(cells[i].name);
							cells[i].addPossibleCell(cells[j]);
							cells[j].addPossibleCell(cells[i]);
						}
//						distRow = (i % Field.ROW_NUM) - (j % Field.ROW_NUM);
//						
//						if(distRow < 0)
//						{
//							
//						}
//						else if(distRow > 0)
//						{
//							
//						}
//						else
//						{
//							
//						}
					}
				}
			}
			
			function findPossible():void
			{
				
			}
		}
		
		public function checkPossibleCell2(cells:Array):void
		{
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			
			for(i = 0; i < cells.length; i++)
			{
				
			}
		}
		
		private function findPath(startNode:Cell, destNode:Cell):Boolean
		{
			var result:Boolean = false;
			var count:int = 0;
			var currentNode:Cell = startNode;
			var prevNode:Cell = startNode;
			
			var prevDirection:int = 0;
			var currentDirection:int = 0;
			
			var curveCount:uint = 0;
			
			var states:Vector.<State> = new Vector.<State>();
			
//			pushState();
			_openNodes.push(currentNode);
//			addOpenNodes(currentNode);
			while(currentNode != destNode)
			{
				trace(currentNode.name);
				pushStates(currentNode);
				var dest:int = checkDest(currentNode, destNode);
				trace(curveCount);
				if(dest != 0)
				{
					if(curveCount >= 3)
					{
						if(prevNode.neigbor[dest] == currentNode)
						{
							currentNode = currentNode.neigbor[dest];
							result = true;
							break;
						}
					}
					else
					{
						currentNode = currentNode.neigbor[dest];
						result = true;
						break;
					}
				}
				if(states.length == 0)
				{
					result = false;
					break;
				}
				popState();
			}
			states.splice(0, states.length);
			return result;
			
			
			function pushStates(node:Cell):void
			{
				var curve:uint;
				for(var i:int = 0; i < _neigborTypes.length; i++)
				{
					if(node.neigbor[_neigborTypes[i]] == null || node.neigbor[_neigborTypes[i]].block != null)
						continue;
					
					if(node.neigbor[_neigborTypes[i]] != prevNode)
					{
						if(prevNode.neigbor[_neigborTypes[i]] != node)
							curve = curveCount+1;
						else
							curve = curveCount;
						if(curve >= 4)
							continue;
						pushState(node.neigbor[_neigborTypes[i]], curve);
					}
				}
			}
			
//			function initCellsCheck():void
//			{
//				for(var i:int = 0; i < _cells.length; i++)
//					_cells[i].check = false;
//			}
			
			function isInOpenNodes(node):int
			{
				return _openNodes.indexOf(node);
			}
			
//			function calculNeigborFGH(node:Cell):void
//			{
//				var neigbor:Cell;
//				for(var i:int = 0; i < _neigborTypes.length; i++)
//				{
//					neigbor = node.neigbor[_neigborTypes[i]];
//					
//					if(neigbor != null)
//					{
//						if(isInOpenNodes(neigbor) < 0)
//							neigbor.initFGH();
//						else
//						{
//							if(neigbor.g < node.g + 10)
//							{
//								
//							}
//						}
//						neigbor.g = node.g + 10;
//						if(neigbor.row == destNode.row)
//						{
//							if(Math.abs(neigbor.colum - destNode.colum) > Math.abs(node.colum - destNode.colum))
//								neigbor.h = 50;
//							else 
//								neigbor.h = 30;
//						}
//						else if(neigbor.colum == destNode.colum)
//						{
//							if(Math.abs(neigbor.row - destNode.row) > Math.abs(node.row - destNode.row))
//								neigbor.h = 50;
//							else 
//								neigbor.h = 30;
//						}
//						else
//							neigbor.h = 40;
//						
//						neigbor.f = neigbor.g + neigbor.h;
//					}
//				}
//			}
			
			function getNextDirection(node:Cell):int
			{
				for(var i:int = 0; i < _neigborTypes.length; i++)
				{
					if(node.neigbor[_neigborTypes[i]] != null && node.neigbor[_neigborTypes[i]].block == null)
					{
						if(!node.neigbor[_neigborTypes[i]].check)
							return _neigborTypes[i];
					}
				}
				return 0;
			}
			
//			function sortOpenNodes():void
//			{
//				_openNodes.sort(orderByF);
//			}
			
//			function orderByF(node1:Cell, node2:Cell):int
//			{
//				if(node1.f > node2.f)
//					return 1;
//				else if(node1.f < node2.f)
//					return -1;
//				else
//					return 0;
//			}
			
			function pushState(node:Cell, curve:uint):void
			{
				var state:State = new State();
				state.node = node;
				state.prevNode = currentNode;
				state.curveCount = curve;
				state.prevDirection = prevDirection;
				state.currentDirection = currentDirection;
				states.push(state);
			}
			
			function popState():void
			{
				var state:State = states.pop();
				currentNode = state.node;
				prevNode = state.prevNode;
				curveCount = state.curveCount;
				currentDirection = state.currentDirection;
				prevDirection = state.prevDirection;
			}
			
			function checkDest(node:Cell, destNode:Cell):int
			{
				for(var i:int = 0; i < _neigborTypes.length; i++)
				{
					if(node.neigbor[_neigborTypes[i]] == destNode)
						return _neigborTypes[i];
				}
				return 0;
			}
			
			function goNode(node:Cell):void
			{
				addCloseNode(node);
				addOpenNodes(node);
				_path.push(node);
			}
			
			function checkAvailable(node:Cell):Boolean
			{
				if(node.block == null)
					return true;
				else
					return false;
			}
			
			function checkOpenNodes(node:Cell):Boolean
			{
				for(var i:int = 0; i < _openNodes.length; i++)
				{
					if(node == _openNodes[i])
						return true;
				}
				
				return false;
			}
			
			function removeFromOpenNodes(node:Cell):void
			{
				var index:int = _openNodes.indexOf(node);
				if(index < 0)
					return;
				_openNodes.removeAt(index);
			}
			
			function addCloseNode(node:Cell):void
			{
				removeFromOpenNodes(node);
				_closeNodes.push(node);
			}
			
			function addOpenNodes(node:Cell):void
			{
				for(var i:int = 0; i < _neigborTypes.length; i++)
				{
					if(node.neigbor[_neigborTypes[i]] != null && checkAvailable(node.neigbor[_neigborTypes[i]]))
					{
						if(checkCloseNode(node.neigbor[_neigborTypes[i]]))
							continue;
						if(node.neigbor[_neigborTypes[i]].check)
							continue;
						//					trace(node.neigbor[_neigborTypes[i]].name);
						_openNodes.push(node.neigbor[_neigborTypes[i]]);
						node.neigbor[_neigborTypes[i]].pathParent = node;
					}
					else
						addCloseNode(node.neigbor[_neigborTypes[i]]);
				}
			}
			
			function checkCloseNode(node:Cell):Boolean
			{
				for(var i:int = 0; i < _closeNodes.length; i++)
				{
					if(node == _closeNodes[i])
						return true;
				}
				
				return false;
			}
		}
		
		public function outChecker(cell:Cell):void
		{
			cell.dispatchEvent(new Event(CheckEvent.PULL_PREV));
		}
		
//		private function checkPath(node:Cell):void
//		{
//			goNode(node);
//		}
	}
}