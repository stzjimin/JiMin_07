package puzzle.ingame.util.possibleCheck
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.NeigborType;
	import puzzle.ingame.cell.blocks.BlockType;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class PossibleChecker extends EventDispatcher
	{
		private const FINDPATH_LIMIT:int = 20;
		
		private var _prevCell:Cell;
		private var _currentCell:Cell;
		
		private var _possibles:Dictionary;
		
		private var _neigborTypes:Vector.<int> = NeigborType.TYPES;
		private var _possibleCount:uint;
		private var _blockCount:uint;
		
		public function PossibleChecker()
		{
			init();
		}
		
		public function init():void
		{
//			trace("PossibleChecker init");
			if(_possibles != null)
			{
				for(var key:Cell in _possibles)
				{
//					trace(key.name);
					for(var i:int = 0; i < _possibles[key].length; i++)
						_possibles[key][i].destroy();
					_possibles[key].splice(0, _possibles[key].length);
					delete _possibles[key];
				}
			}
			_possibles = new Dictionary();
		}
		
		public function destroy():void
		{
			if(_possibles != null)
			{
				for(var key:Cell in _possibles)
				{
//					trace(key.name);
					for(var i:int = 0; i < _possibles[key].length; i++)
						_possibles[key][i].destroy();
					_possibles[key].splice(0, _possibles[key].length);
					delete _possibles[key];
				}
			}
			
			if(_neigborTypes != null)
				_neigborTypes.splice(0, _neigborTypes.length);
			
			_prevCell = null;
			_currentCell = null;
		}
		
		public function setPrev(cell:Cell):void
		{
			if(_prevCell != null)
			{
				if(_prevCell != cell)
				{
					_currentCell = cell;
					
					if(_currentCell.block.type == _prevCell.block.type)
					{
						var vector:Vector.<Possible> = _possibles[_prevCell];
						if(vector != null)
						{
							var result:Boolean = false;
							var path:Vector.<Cell>;
							for(var i:int = 0; i < vector.length; i++)
							{
								if(vector[i].destCell == _currentCell)
								{
									path = cloneVector(vector[i].path);
//									removeFromPossibles(_prevCell);
//									removeFromPossibles(_currentCell);
									result = true;
									break;
								}
							}
							if(result)
							{
								var possible:Possible = new Possible();
								possible.startCell = _prevCell;
								possible.destCell = _currentCell;
								possible.path = path;
								dispatchEvent(new Event(PossibleCheckerEventType.SAME, false, possible));
							}
						}
					}
					outChecker(_prevCell);
					_prevCell = null;
					outChecker(_currentCell);
					_currentCell = null;
				}
			}
			else
				_prevCell = cell;
		}
		
		public function checkPossibleCell(cells:Vector.<Cell>):void
		{
			_possibleCount = 0;
			_blockCount = 0;
//			var count:int = 0;
//			var newCount:int = 0;
			for(var i:int = 0; i < cells.length-1; i++)
			{
				if(cells[i].block == null || cells[i].block.type == BlockType.WALL)
					continue;	//블록이 없는 경우는 검사할 필요가 없으니 제외
				_blockCount++;
//				if(_possibles[cells[i]] != null)
//					continue;
				for(var j:int = i+1; j < cells.length; j++)
				{
					if(cells[j].block == null || cells[i].block.type == BlockType.WALL)
						continue;	//블록이 없는 경우는 검사할 필요가 없으니 제외
					
					if(cells[i].block.type == cells[j].block.type)
					{
//						trace("startNode = " + cells[i].name);
//						trace("destNode = " + cells[j].name);
						var isPossibled:Boolean = false;
						if(_possibles[cells[i]] != null)
						{
							var possibleVector:Vector.<Possible> = _possibles[cells[i]];
							for(var k:int = 0; k < possibleVector.length; k++)
							{
								if(possibleVector[k].destCell == cells[j])
								{
									isPossibled = true;
									break;
								}
							}
						}
						
						if(isPossibled)
						{
//							count++;
							_possibleCount++;
						}
						else if(!isPossibled)
						{
							if(findPath(cells[i], cells[j]))
							{
//								newCount++;
								_possibleCount++;
							}
						}
					}
				}
			}
//			trace("count = " + count);
//			trace("newCount = " + newCount);
			if(cells[i].block != null)
				_blockCount++;
		}
		
		public function outChecker(cell:Cell):void
		{
			if(cell != null)
			{
				cell.dispatchEvent(new Event(PossibleCheckerEventType.PULL_PREV));
				if(cell == _prevCell)
					_prevCell = null;
				if(cell == _currentCell)
					_currentCell = null;
			}
			else
			{
				_prevCell = null;
				_currentCell = null;
			}
		}
		
		public function outPrevCell():void
		{
			if(_prevCell == null)
				return;
			
			outChecker(_prevCell);
		}
		
		public function pickPossible():Possible
		{
			for(var key:Cell in _possibles)
			{
				var possibles:Vector.<Possible> = Vector.<Possible>(_possibles[key]);
				if(possibles.length == 0)
					continue;
				return possibles[0]
			}
			return null;
		}
		
		/**
		 *길찾기 알고리즘(스택을 이용한 방법에서 우선순위를 적용)
		 * @param startNode
		 * @param destNode
		 * @return 
		 * 
		 */		
		private function findPath(startNode:Cell, destNode:Cell):Boolean
		{
			var result:Boolean = false;
			var currentNode:Cell = startNode;
			var prevNode:Cell = startNode;
			var originPath:Vector.<Cell> = new Vector.<Cell>();
			
			var curveCount:uint = 0;
			
			var states:Vector.<State> = new Vector.<State>();
			
			var blocked:Boolean = true;
			for(var i:int = 0; i < _neigborTypes.length; i++)
			{
				if(destNode.neigbor[_neigborTypes[i]] != null && destNode.neigbor[_neigborTypes[i]].block == null)
				{
					blocked = false;
				}
				else
				{
					if(destNode.neigbor[_neigborTypes[i]] == startNode)
						blocked = false;
				}
			}
			if(blocked)
				return false;
			
			var time:Number = getTimer() / 1000;
			
			while(currentNode != destNode)
			{
				var current:Number = getTimer() / 1000;
				if((current - time) > 0.016)
				{
					time = current;
					Starling.current.nextFrame(); 
				}
				
//				trace(currentNode.name);
//				trace(curveCount);
				var dest:int = checkDest(currentNode, destNode);
				if(dest != 0)
				{
					if(prevNode.neigbor[dest] == currentNode)
					{
						currentNode = currentNode.neigbor[dest];
						result = true;
						break;
					}
					else
					{
						if(curveCount < 3)	//처음 한번 진행할 때 커브카운트가 1증가 하기때문에 커브 최대 횟수는 3이하로 계산
						{
							if(currentNode != startNode)
								originPath.push(currentNode);
							currentNode = currentNode.neigbor[dest];
							result = true;
							break;
						}
					}
				}
				
				pushStates(currentNode);
				
				if(states.length == 0)
				{
					result = false;
					break;
				}
				popState();
			}
			freeStates();
			
			if(result)
				setBothPossible(startNode, destNode, originPath);
			
			originPath.splice(0, originPath.length);
			return result;
			
			function freeStates():void
			{
				while(states.length != 0)
					states.pop().distroy();
			}
			
			function calculPriority(node:Cell, direction:int):int
			{
				var rowDist:int = destNode.row - node.row;
				var columDist:int = destNode.column - node.column;
				
				if(rowDist == 0)
				{
					if(columDist > 0)
					{
						if(direction == NeigborType.RIGHT)
							return 2;
					}
					else
					{
						if(direction == NeigborType.LEFT)
							return 2;
					}
				}
				
				if(columDist == 0)
				{
					if(rowDist > 0)
					{
						if(direction == NeigborType.BOTTOM)
							return 2;
					}
					else
					{
						if(direction == NeigborType.TOP)
							return 2;
					}
				}
				
				if(direction == NeigborType.RIGHT)
				{
					return columDist >= 0 ? 0 : -1;
				}
				else if(direction == NeigborType.LEFT)
				{
					return columDist <= 0 ? 0 : -1;
				}
				else if(direction == NeigborType.TOP)
				{
					return rowDist <= 0 ? 0 : -1;
				}
				else if(direction == NeigborType.BOTTOM)
				{
					return rowDist >= 0 ? 0 : -1;
				}
			}
			
			function pushStates(node:Cell):void
			{
				var curve:uint;
				var priority:int;
				var path:Vector.<Cell>;
				
				for(var i:int = 0; i < _neigborTypes.length; i++)
				{
					if(node.neigbor[_neigborTypes[i]] == null || node.neigbor[_neigborTypes[i]].block != null)
						continue;
					
					if(node.neigbor[_neigborTypes[i]] != prevNode)
					{
						priority = calculPriority(node, _neigborTypes[i]);
						
						path = cloneVector(originPath);
						if(prevNode.neigbor[_neigborTypes[i]] != node)
						{
							curve = curveCount+1;
							if(curve != 1)
								path.push(node);
						}
						else
						{
							curve = curveCount;
						}
						
						if(curve >= 4)	//처음 한번 진행할 때 커브카운트가 1증가 하기때문에 커브 최대 횟수는 3이하로 계산
							continue;
						
						pushState(node.neigbor[_neigborTypes[i]], path, curve, priority);
					}
				}
			}
			
			function pushState(node:Cell, path:Vector.<Cell>, curve:uint, priority:int):void
			{
				var state:State = new State();
				state.node = node;
				state.prevNode = currentNode;
				state.curveCount = curve;
				state.path = path;
				state.priority = priority;
				states.push(state);
//				if(priority >= 0)
//					states.push(state);
//				else
//					states.insertAt(0, state);
			}
			
			function popState():void
			{
				states.sort(sortPriority);
				var state:State = states.pop();
				currentNode = state.node;
				prevNode = state.prevNode;
				curveCount = state.curveCount;
				originPath = cloneVector(state.path);
				state.distroy();
			}
			
			function sortPriority(state1:State, state2:State):int
			{
				if(state1.priority > state2.priority)
					return 1;
				else if(state1.priority < state2.priority)
					return -1;
				else
				{
//					if(state1.curveCount < state2.curveCount)
//						return 1;
//					else if(state1.curveCount > state2.curveCount)
//						return -1;
//					else
						return 0;
				}
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
		
		private function removeFromPossibles(cell:Cell):void
		{
			var vector:Vector.<Possible> = _possibles[cell];
			for(var i:int = 0; i < vector.length; i++)
				vector[i].destroy();
			vector.splice(0, vector.length);
			
			for(var key:Cell in _possibles)
			{
				vector = _possibles[key];
				for(i = 0; i < vector.length; i++)
				{
					if(vector[i].destCell == cell)
					{
						vector[i].destroy();
						vector.removeAt(i);
					}
				}
			}
//			for(var i:int = 0; i < vector.length; i++)
//			{
//				if(vector[i].destCell == target)
//				{
//					vector.removeAt(i);
//					return true;
//				}
//			}
//			return true;
		}
		
		private function setBothPossible(cell1:Cell, cell2:Cell, path:Vector.<Cell>):void
		{
			var possible:Possible = new Possible();
			possible.startCell = cell1;
			possible.destCell = cell2;
			possible.path = cloneVector(path);
			if(_possibles[cell1] == null)
				_possibles[cell1] = new Vector.<Possible>();
			_possibles[cell1].push(possible);
			
			possible = new Possible();
			possible.startCell = cell2;
			possible.destCell = cell1;
			possible.path = cloneVector(path.reverse());
			if(_possibles[cell2] == null)
				_possibles[cell2] = new Vector.<Possible>();
			_possibles[cell2].push(possible);
			
//			function searchIsIn(cell:Cell, array:Array):void
//			{
//				
//			}
		}
		
		private function cloneVector(vector:Vector.<Cell>):Vector.<Cell>
		{
			var vectorTemp:Vector.<Cell> = new Vector.<Cell>();
			for(var i:int = 0; i < vector.length; i++)
				vectorTemp.push(vector[i]);
			return vectorTemp;
		}

		public function get possibleCount():uint
		{
			return _possibleCount;
		}

		public function set possibleCount(value:uint):void
		{
			_possibleCount = value;
		}

		public function get blockCount():uint
		{
			return _blockCount;
		}

		public function set blockCount(value:uint):void
		{
			_blockCount = value;
		}


	}
}