package
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	import customize.Scene;
	
	import puzzle.ingame.Field;
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.NeigborType;
	import puzzle.ingame.cell.blocks.Block;
	import puzzle.ingame.cell.blocks.BlockType;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;

	public class Main extends Scene
	{	
		[Embed(source="iu3.jpg")]
		private const testImage:Class;
		
		public static const ROW_NUM:uint = 12;
		public static const COLUMN_NUM:uint = 12;
		public static const PADDING:uint = 18;
		
		private var _spirteDir:File = File.applicationDirectory.resolvePath("puzzle/ingame/resources/ingameSpriteSheet");
		private var _soundDir:File = File.applicationDirectory.resolvePath("puzzle/ingame/resources/sound");
		private var _imageDir:File = File.applicationDirectory.resolvePath("puzzle/ingame/resources/image");
		private var _resources:Resources;
		
		private var _backGround:Image;
		private var _cells:Vector.<MapToolCell>;
		
		private var _currentClickedCell:MapToolCell;
		
		private var _blockTypes:Vector.<String>;
		
		private var _block1:Button;
		private var _block2:Button;
		private var _block3:Button;
		private var _block4:Button;
		private var _block5:Button;
		
//		private var _cells:Vector.<MapToolCell>;
		
		public function Main()
		{
			super();
			
			_resources = new Resources(_spirteDir, _soundDir, _imageDir);
			
			_resources.addSpriteName("IngameSprite0.png");
			_resources.addSpriteName("IngameSprite1.png");
			_resources.addSpriteName("IngameSprite2.png");
			_resources.addSpriteName("readyClip.png");
			_resources.addSoundName("MilkOut.mp3");
			_resources.addSoundName("NeverForget.mp3");
			_resources.addSoundName("set.mp3");
			_resources.addSoundName("clear.mp3");
			_resources.addSoundName("fork.mp3");
			
			_resources.addEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.addEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.loadResource();
		}
		
		private function onFailedLoading(event:LoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
			NativeApplication.nativeApplication.exit();
		}
		
		private function onCompleteLoading(event:LoadingEvent):void
		{
			_backGround = new Image(_resources.getSubTexture("IngameSprite2.png", "IngameBackGround"));
			_backGround.width = 800;
			_backGround.height = 1024;
			addChild(_backGround);
			
			_cells = new Vector.<MapToolCell>();
			var columnNum:int = 0;
			for(var i:int = 0; i < COLUMN_NUM*ROW_NUM; i++)
			{
				var cell:MapToolCell = new MapToolCell(_resources.getSubTexture("IngameSprite0.png", "backGround"), Cell.WIDTH_SIZE, Cell.HEIGHT_SIZE);
				var rowNum:int = i%ROW_NUM;
				_cells.push(cell);
				//				cell.addEventListener(PossibleCheckerEventType.ADD_PREV, onAddPrev);
				//				cell.addEventListener(PossibleCheckerEventType.OUT_CHECKER, onOutChecker);
				cell.width = Cell.WIDTH_SIZE;
				cell.height = Cell.HEIGHT_SIZE;
				cell.x = Field.PADDING + (rowNum * Cell.WIDTH_SIZE);
				cell.y = Field.PADDING + (columnNum * Cell.HEIGHT_SIZE);
				cell.row = columnNum;
				cell.column = rowNum;
				_cells[i].name = rowNum.toString() + "/" + columnNum.toString();
				cell.init();
				cell.addEventListener(Event.TRIGGERED, onClickedCell);
				addChild(cell);
				if(columnNum != 0)
				{
					_cells[i].neigbor[NeigborType.TOP] = _cells[i-ROW_NUM];
					_cells[i-ROW_NUM].neigbor[NeigborType.BOTTOM] = _cells[i];
				}
				if(rowNum != 0)
				{
					_cells[i].neigbor[NeigborType.LEFT] = _cells[i-1];
					_cells[i-1].neigbor[NeigborType.RIGHT] = _cells[i];
				}
				if(rowNum == (ROW_NUM-1))
					columnNum++;
			}
			
			_block1 = new Button(_resources.getSubTexture("IngameSprite1.png", "blue"));
			_block1.name = BlockType.BLUE;
			
			_block2 = new Button(_resources.getSubTexture("IngameSprite1.png", "lucy"));
			_block2.name = BlockType.LUCY;
			
			_block3 = new Button(_resources.getSubTexture("IngameSprite1.png", "micky"));
			_block3.name = BlockType.MICKY;
			
			_block4 = new Button(_resources.getSubTexture("IngameSprite1.png", "mongyi"));
			_block4.name = BlockType.MONGYI;
			
			_block5 = new Button(_resources.getSubTexture("IngameSprite1.png", "pinky"));
			_block5.name = BlockType.PINKY;
		}
		
		private function onClickedCell(event:Event):void
		{
			var selectCell:MapToolCell = event.currentTarget as MapToolCell;
			
			if(!_currentClickedCell)
			{
				selectCell.showColor();
				selectCell.clicked = true;
				_currentClickedCell = selectCell;
			}
			else if(_currentClickedCell && (_currentClickedCell == selectCell))
			{
				_currentClickedCell.offColor();
				_currentClickedCell.clicked = false;
				_currentClickedCell = null;
			}
			else
			{
				_currentClickedCell.offColor();
				_currentClickedCell.clicked = false;
				_currentClickedCell = null;
				
				selectCell.showColor();
				selectCell.clicked = true;
				_currentClickedCell = selectCell;
			}
		}
	}
}