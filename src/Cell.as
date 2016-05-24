package
{
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Cell extends DisplayObjectContainer
	{
		private var _neigbor:Dictionary;
		private var _block:Block;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _blanked:Boolean;
		
		private var _swaped:Boolean;
		private var _swapBlock:Block;
		
		private var _frameCheck:uint;
		
		public function Cell()
		{
			_neigbor = new Dictionary();
			_blanked = false;
			_swaped = false;
		}
		
		public function init():void
		{
			var rand:int = (Math.random()*10)%3;
			_block = new Block(rand);
			_block.width = this.width;
			_block.height = this.height;
			addChild(_block);
			
//			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			addEventListener(SwapType.CONTAINS, onContains);
			addEventListener("blockTriggered", onBlockTriggered);
			addEventListener(SwapType.SWAP_BLOCK, onSwapBlock);
//			addEventListener(SwapType.DISTORYED_BLOCK, onDistroyedBlock);
		}

		private function onBlockTriggered(event:Event):void
		{
//			trace(_block.name);
//			_block = null;
//			addChild(null);
//			trace(this.bounds);
			checkNeigbor();
//			if(!_block.distroyed)
//				dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
//			_block = null;
//			dispatchEvent(new Event(SwapType.SWAP_BLOCK));
		}
		
		private function onContains(event:Event):void
		{
			var target:Cell = _neigbor[event.data]
			swapBlock(target);
			checkNeigbor();
			target.checkNeigbor();
		}
		
//		private function onEnterFrame(event:Event):void
//		{
//			if(GravityManager.gravity == GravityType.DOWN)
//			{
//				if(_neigbor[NeigborType.BOTTOM] == null)
//					return;
//				
//				if(_neigbor[NeigborType.BOTTOM].block == null)
//				{
//					trace("a");
//					swapBlock(_neigbor[NeigborType.BOTTOM]);
//				}
//				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT].block == null)
//				{
//					trace("b");
//					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT]);
//				}
//				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT].block == null)
//				{
//					trace("c");
//					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT]);
//				}
//			}
//			else if(GravityManager.gravity == GravityType.UP)
//			{
//				if(_neigbor[NeigborType.TOP] == null)
//					return;
//				
//				if(_neigbor[NeigborType.TOP].block == null)
//					swapBlock(_neigbor[NeigborType.TOP]);
//				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block == null)
//					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT]);
//				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block == null)
//					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT]);
//			}
//			else if(GravityManager.gravity == GravityType.LEFT)
//			{
//				if(_neigbor[NeigborType.LEFT] == null)
//					return;
//				
//				if(_neigbor[NeigborType.LEFT].block == null)
//					swapBlock(_neigbor[NeigborType.LEFT]);
//				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM].block == null)
//					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM]);
//				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP].block == null)
//					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP]);
//			}
//			else if(GravityManager.gravity == GravityType.RIGHT)
//			{
//				if(_neigbor[NeigborType.RIGHT] == null)
//					return;
//				
//				if(_neigbor[NeigborType.RIGHT].block == null)
//					swapBlock(_neigbor[NeigborType.RIGHT]);
//				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP].block == null)
//					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP]);
//				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM].block == null)
//					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM]);
//			}
//		}
		
		public function fillBlock():String
		{
			if(GravityManager.gravity == GravityType.DOWN)
			{
				if(_neigbor[NeigborType.TOP] == null)
					return FillManager.CELL_NULL;
				
				if(_neigbor[NeigborType.TOP].block != null)
				{
					swapBlock(_neigbor[NeigborType.TOP]);
					return FillManager.SUCCES_SWAP;
				}
//				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block != null)
//					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT]);
//				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block != null)
//					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT]);
			}
			else if(GravityManager.gravity == GravityType.UP)
			{
				if(_neigbor[NeigborType.BOTTOM] == null)
					return FillManager.CELL_NULL;
				
				if(_neigbor[NeigborType.BOTTOM].block != null)
				{
					swapBlock(_neigbor[NeigborType.BOTTOM]);
					return FillManager.SUCCES_SWAP;
				}
//				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT].block != null)
//					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT]);
//				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT].block != null)
//					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT]);
			}
			else if(GravityManager.gravity == GravityType.LEFT)
			{
				if(_neigbor[NeigborType.RIGHT] == null)
				{
//					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return FillManager.CELL_NULL;
				}
				
				if(_neigbor[NeigborType.RIGHT].block != null)
				{
					swapBlock(_neigbor[NeigborType.RIGHT]);
					return FillManager.SUCCES_SWAP;
				}
//				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP].block != null)
//					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP]);
//				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM].block != null)
//					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM]);
			}
			else if(GravityManager.gravity == GravityType.RIGHT)
			{
				if(_neigbor[NeigborType.LEFT] == null)
				{
//					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return FillManager.CELL_NULL;
				}
				
				if(_neigbor[NeigborType.LEFT].block != null)
				{
					swapBlock(_neigbor[NeigborType.LEFT]);
					return FillManager.SUCCES_SWAP;
				}
//				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM].block != null)
//					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM]);
//				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP].block != null)
//					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP]);
			}
			return FillManager.BLOCK_NULL;
		}
		
		private function onSwapBlock(event:Event):void
		{
			if(GravityManager.gravity == GravityType.DOWN)
			{
				if(_neigbor[NeigborType.TOP] == null)
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
				if(_neigbor[NeigborType.TOP].block != null)
					swapBlock(_neigbor[NeigborType.TOP]);
				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block != null)
					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT]);
				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block != null)
					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT]);
			}
			else if(GravityManager.gravity == GravityType.UP)
			{
				if(_neigbor[NeigborType.BOTTOM] == null)
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
				if(_neigbor[NeigborType.BOTTOM].block != null)
					swapBlock(_neigbor[NeigborType.BOTTOM]);
				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT].block != null)
					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT]);
				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT].block != null)
					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT]);
			}
			else if(GravityManager.gravity == GravityType.LEFT)
			{
				if(_neigbor[NeigborType.RIGHT] == null)
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
				if(_neigbor[NeigborType.RIGHT].block != null)
					swapBlock(_neigbor[NeigborType.RIGHT]);
				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP].block != null)
					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP]);
				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM].block != null)
					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM]);
			}
			else if(GravityManager.gravity == GravityType.RIGHT)
			{
				if(_neigbor[NeigborType.LEFT] == null)
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
				if(_neigbor[NeigborType.LEFT].block != null)
					swapBlock(_neigbor[NeigborType.LEFT]);
				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM].block != null)
					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM]);
				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP].block != null)
					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP]);
			}
		}
		
//		private function onDistroyedBlock(event:Event):void
//		{
//			_blanked
//		}
		
		private function swapBlock(cell:Cell):void
		{
//			cell.block = _block;
//			_block.removeFromParent();
//			cell.addChild(_block);
//			_block = null;
//			var block:Block = _block;
//			block.removeFromParent();
//			var cellBlock:Block = cell.block;
//			cell.block = block;
//			cell.addChild(block);
//			_block = cellBlock;
//			if(cellBlock != null)
//			{
//				cellBlock.removeFromParent(true);
//				this.addChild(cellBlock);
//			}
			
//			swapMotion(this, cell);
			cell.block.removeFromParent();
			_block.removeFromParent();
			
			var block:Block = cell.block;
			cell.block = _block;
			_block = block;
			
			cell.addChild(cell.block);
			addChild(block);
//			_swaped = true;
//			swapMotion(this, cell);
//			cell.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
//			Field(this.parent).swapBlock(this, cell);
			
//			addEventListener(SwapType.END_ANIMATION, onEndedAnimation);
		}
		
		private function endMotion(cell:Cell):void
		{
//			checkNeigbor();
//			var block:Block = cell.block;
////			if(block != null)
//			block.removeFromParent();
//			cell.block = _block;
//			addChild(block);
//			_block = block;
//			_swaped = true;
//			cell.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
		}
		
		private function swapMotion(trigger:Cell, target:Cell):void
		{
			var thisBounds:Rectangle = trigger.bounds;
			var targetBounds:Rectangle = target.bounds;
			
			var blockXdest:Number = thisBounds.x - targetBounds.x;
			var blockYdest:Number = thisBounds.y - targetBounds.y;
			
			var blockMoveX:Number = blockXdest / 125;
			var blockMoveY:Number = blockYdest / 125;
			
//			if(blockXdest > 0)
//				blockMoveX = -blockMoveX;
//			if(blockYdest > 0)
//				blockMoveY = -blockMoveY;
			
			var block1:Block = target.block;
			var block2:Block = trigger.block;
			
//			if(block1 != null)
//			{
//				block1.x = blockXdest;
//				block1.y = blockYdest;
//			}
			
			block2.x = -blockXdest;
			block2.y = -blockYdest;
			
			block2.addEventListener(Event.ENTER_FRAME, onEnterFrameBlockMove);
			
			function onEnterFrameBlockMove():void
			{
				if(block2.x != 0)
				{
//					if(block1 != null)
//						block1.x -= blockMoveX;
					block2.x += blockMoveX;
				}
				if(block2.y != 0)
				{
//					if(block1 != null)
//						block1.y -= blockMoveY;
					block2.y += blockMoveY;
				}
				
				if((block2.x == 0) && (block2.y == 0))
				{
//					if(block1 != null)
//					{
//						block1.x = 0;
//						block1.y = 0;
//					}
//					block2.x = 0;
//					block2.y = 0;
					block2.removeEventListener(Event.ENTER_FRAME, onEnterFrameBlockMove);
					endMotion(target);
				}
			}
		}
		
		private function onEndedAnimation(event:Event):void
		{
//			var block:Block = Cell(event.data).block;
//			block.removeFromParent();
//			addChild(block);
			var cell:Cell = event.data as Cell;
			var block:Block = cell.block;
			if(block != null)
				block.removeFromParent();
			cell.block = _block;
			addChild(block);
			_block = block;
			_swaped = true;
			cell.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
			if(_block != null)
			{
				_block.x = 0;
				_block.y = 0;
			}
			addChild(_block);
			removeEventListener(SwapType.END_ANIMATION, onEndedAnimation);
		}
		
		public function checkNeigbor():void
		{
			if(_block == null)
				return;
			
			var neigborTypes:Vector.<int> = NeigborType.TYPES;
			
			var neigbor:Cell;
			var twoNeigbor:Cell;
			var backNeigbor:Cell;
			for(var i:int = 0; i < neigborTypes.length; i++)
			{
				if(_neigbor[neigborTypes[i]] == null || _neigbor[neigborTypes[i]].neigbor[neigborTypes[i]] == null)
					continue;
				
				neigbor = _neigbor[neigborTypes[i]];
				twoNeigbor = _neigbor[neigborTypes[i]].neigbor[neigborTypes[i]];
				
				if(neigbor.block != null && twoNeigbor.block != null)
				{
					if(_block.attribute.type == neigbor.block.attribute.type && _block.attribute.type == twoNeigbor.block.attribute.type)
					{
						if(!_block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
						if(!neigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, neigbor.block));
						if(!twoNeigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, twoNeigbor.block));
						
						if(_neigbor[-neigborTypes[i]] != null && _neigbor[-neigborTypes[i]].block != null)
						{
							backNeigbor = _neigbor[-neigborTypes[i]];
							if(_block.attribute.type == backNeigbor.block.attribute.type)
							{
								if(!backNeigbor.block.distroyed)
									dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, backNeigbor.block));
							}
						}
					}
				}
			}
			neigbor = null;
			twoNeigbor = null;
			backNeigbor = null;
			
			for(var j:int = 0; j < neigborTypes.length; j++)
			{
				if(_neigbor[neigborTypes[j]] == null || _neigbor[-neigborTypes[j]] == null)
					continue;
				neigbor = _neigbor[neigborTypes[j]];
				backNeigbor = _neigbor[-neigborTypes[j]];
				if(neigbor.block != null && backNeigbor.block != null)
				{
					if(_block.attribute.type == neigbor.block.attribute.type && _block.attribute.type == backNeigbor.block.attribute.type)
					{
						if(!_block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
						if(!neigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, neigbor.block));
						if(!backNeigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, backNeigbor.block));
					}
				}
			}
		}

		public function get neigbor():Dictionary
		{
			return _neigbor;
		}

		public function set neigbor(value:Dictionary):void
		{
			_neigbor = value;
		}
		
		public function get block():Block
		{
			return _block;
		}
		
		public function set block(value:Block):void
		{
			_block = value;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;
			super.width = _width;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;
			super.height = _height;
		}

		public function get swaped():Boolean
		{
			return _swaped;
		}

		public function set swaped(value:Boolean):void
		{
			_swaped = value;
		}

		public function get swapedBlock():Block
		{
			return _swapBlock;
		}

		public function set swapedBlock(value:Block):void
		{
			_swapBlock = value;
		}

		public function get blanked():Boolean
		{
			return _blanked;
		}

		public function set blanked(value:Boolean):void
		{
			_blanked = value;
		}


	}
}