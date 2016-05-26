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
			
			if(_path != null)
				_path.splice(0, _path.length);
			
			_path = new Vector.<Cell>();
		}
		
		public function setPrev(cell:Cell):void
		{
			if(_prevCell != null && (_prevCell != cell))
			{
				_currentCell = cell;
				
				if(_currentCell.block.attribute.type == _prevCell.block.attribute.type)
				{
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
						trace("startNode = " + cells[i].name);
						trace("destNode = " + cells[j].name);
						if(findPath(cells[i], cells[j]))
						{
							cells[i].addPossibleCell(cells[j]);
							cells[j].addPossibleCell(cells[i]);
						}
					}
				}
			}
			
			function findPossible():void
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
			
			while(currentNode != destNode)
			{
				trace(currentNode.name);
				pushStates(currentNode);
				var dest:int = checkDest(currentNode, destNode);
				trace(curveCount);
				if(dest != 0)
				{
					if(curveCount >= 3)	//처음 한번 진행할 때 커브카운트가 1증가 하기때문에 커브 최대 횟수는 3이하로 계산
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
						if(curve >= 4)	//처음 한번 진행할 때 커브카운트가 1증가 하기때문에 커브 최대 횟수는 3이하로 계산
							continue;
						pushState(node.neigbor[_neigborTypes[i]], curve);
					}
				}
			}
			
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
		}
		
		public function outChecker(cell:Cell):void
		{
			cell.dispatchEvent(new Event(CheckEvent.PULL_PREV));
		}
	}
}