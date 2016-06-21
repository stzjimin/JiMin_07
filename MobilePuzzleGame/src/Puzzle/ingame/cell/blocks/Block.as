package puzzle.ingame.cell.blocks
{	
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.util.possibleCheck.PossibleCheckerEventType;
	import puzzle.loading.Resources;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Block extends DisplayObjectContainer
	{	
		public static const PADDING_SIZE:Number = 5;
		
		private var _resources:Resources;
		
		private var _blockRightPadding:Image;
		private var _blockBottomPadding:Image;
		private var _blockImage:Image;
		
		private var _blockTexture:Texture;
		private var _type:String;
		private var _skill:String;
		
		private var _distroyed:Boolean = false;
		
		private var _clicked:Boolean;
		private var _originScale:Number;
		
		/**
		 * 게임의 기본이 되는 블럭입니다. 
		 * @param resources
		 * 
		 */		
		public function Block(resources:Resources)
		{	
			super();
			
			_resources = resources;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/**
		 * 인자로 받아온 블럭데이터를 이용하여 블럭을 초기화시키는 함수입니다.
		 * @param blockData
		 * 
		 */		
		public function init(blockData:BlockData):void
		{
			_clicked = false;
			
			_type = blockData.type;
			this.name = blockData.type;
			_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", _type);
			if(_type == BlockType.WALL)
				this.touchable = false;
			
			_blockImage = new Image(_blockTexture);
			_blockImage.x = -Block.PADDING_SIZE;
			_blockImage.y = -Block.PADDING_SIZE;
			_blockImage.width = Cell.WIDTH_SIZE;
			_blockImage.height = Cell.HEIGHT_SIZE;
			addChild(_blockImage);
			
			_blockRightPadding = new Image(_resources.getSubTexture("FieldSpriteSheet.png", "blockRightPadding"));
			_blockRightPadding.x = Cell.WIDTH_SIZE - Block.PADDING_SIZE;
			_blockRightPadding.width = Block.PADDING_SIZE;
			_blockRightPadding.height = Cell.HEIGHT_SIZE;
			addChild(_blockRightPadding);
			
			_blockBottomPadding = new Image(_resources.getSubTexture("FieldSpriteSheet.png", "blockBottomPadding"));
			_blockBottomPadding.y = Cell.HEIGHT_SIZE - Block.PADDING_SIZE;
			_blockBottomPadding.width = Cell.WIDTH_SIZE;
			_blockBottomPadding.height = Block.PADDING_SIZE;
			addChild(_blockBottomPadding);
		}
		
		/**
		 * 블럭을 제거하고 메모리를 반납하기위한 함수입니다. 
		 * 
		 */		
		public function destroy():void
		{	
			_blockImage.removeFromParent();
			_blockImage.dispose();
			
			_blockRightPadding.removeFromParent();
			_blockRightPadding.dispose();
			
			_blockBottomPadding.removeFromParent();
			_blockBottomPadding.dispose();
			
			removeEventListener(TouchEvent.TOUCH, onTouch);
			removeFromParent();
			
			removeChildren(0, this.numChildren);
			
			dispose();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			if(touch.phase == TouchPhase.BEGAN)
			{
				this.y -= 10;
				this.scale = 1.2;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.scale = 1.0;
				this.y += 10;
				_clicked = !_clicked;
				if(_clicked)
				{
					this.scale = 0.8;
					parent.dispatchEvent(new Event(PossibleCheckerEventType.ADD_PREV));
				}
				else
				{
					parent.dispatchEvent(new Event(PossibleCheckerEventType.OUT_CHECKER));
				}
			}
		}
		
		public function pullPrev():void
		{
			_clicked = false;
			this.scale = 1.0;
		}

		public function get distroyed():Boolean
		{
			return _distroyed;
		}

		public function set distroyed(value:Boolean):void
		{
			_distroyed = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get skill():String
		{
			return _skill;
		}

		public function set skill(value:String):void
		{
			_skill = value;
		}


	}
}