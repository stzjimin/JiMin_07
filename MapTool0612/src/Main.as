package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filesystem.File;
	
	import customize.Scene;
	
	import puzzle.ingame.Field;
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.NeigborType;
	import puzzle.ingame.cell.blocks.Block;
	import puzzle.ingame.cell.blocks.BlockType;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	
	import starlingOrigin.display.Button;
	import starlingOrigin.display.Image;
	import starlingOrigin.events.Event;
	import starlingOrigin.events.Touch;
	import starlingOrigin.events.TouchEvent;
	import starlingOrigin.events.TouchPhase;
	import starlingOrigin.text.TextField;
	import starlingOrigin.textures.Texture;
	import starlingOrigin.utils.Color;

	public class Main extends Scene
	{	
		[Embed(source="wall.png")]
		private const wallImage:Class;
		
		public static const ROW_NUM:uint = 12;
		public static const COLUMN_NUM:uint = 12;
		public static const PADDING:uint = 18;
		
//		private var _spirteDir:File = File.applicationDirectory.resolvePath("puzzle/resources/spriteSheet");
//		private var _soundDir:File = File.applicationDirectory.resolvePath("puzzle/resources/sound");
//		private var _imageDir:File = File.applicationDirectory.resolvePath("puzzle/resources/image");
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
		private var _wall:Button;
		
		private var _countTime:int;
		private var _countTimeText:TextField;
		private var _countUpButton:Button;
		private var _countDownButton:Button;
		
		private var _testButton:Button;
		private var _saveButton:Button;
		private var _loadButton:Button;
		
//		private var _cells:Vector.<MapToolCell>;
		
		public function Main()
		{
			super();
			
			_resources = new Resources(Resources.SpriteDir, Resources.SoundDir, Resources.ImageDir);
			
			_resources.addSpriteName("IngameSpriteSheet.png");
			_resources.addSpriteName("StageSelectSceneSpriteSheet.png");
			_resources.addSpriteName("UserInfoSpriteSheet.png");
			_resources.addSpriteName("PausePopupSpriteSheet.png");
			_resources.addSpriteName("ResultSpriteSheet.png");
			_resources.addSpriteName("StagePopupSpriteSheet.png");
			_resources.addSpriteName("FieldSpriteSheet.png");
			_resources.addSpriteName("ShopSpriteSheet.png");
			_resources.addSpriteName("RankingSpriteSheet.png");
			_resources.addSpriteName("readyClip.png");
			_resources.addSoundName("MilkOut.mp3");
			_resources.addSoundName("NeverForget.mp3");
			_resources.addSoundName("set.mp3");
			_resources.addSoundName("clear.mp3");
			_resources.addSoundName("fork.mp3");
			_resources.addSoundName("searchSound.mp3");
			_resources.addSoundName("shuffleSound2.mp3");
			
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
			_countTime = 0;
			
			_backGround = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "IngameBackGround"));
			_backGround.width = 800;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_cells = new Vector.<MapToolCell>();
			var columnNum:int = 0;
			for(var i:int = 0; i < COLUMN_NUM*ROW_NUM; i++)
			{
				var cell:MapToolCell = new MapToolCell(_resources.getSubTexture("FieldSpriteSheet.png", "backGround"), Cell.WIDTH_SIZE, Cell.HEIGHT_SIZE);
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
			
			_block1 = new Button(_resources.getSubTexture("FieldSpriteSheet.png", "blue"));
			_block1.name = BlockType.BLUE;
			_block1.width = Cell.WIDTH_SIZE;
			_block1.height = Cell.HEIGHT_SIZE;
			_block1.x = Field.PADDING + (13 * Cell.WIDTH_SIZE);
			_block1.y = Field.PADDING;
			_block1.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_block1);
			
			_block2 = new Button(_resources.getSubTexture("FieldSpriteSheet.png", "lucy"));
			_block2.name = BlockType.LUCY;
			_block2.width = Cell.WIDTH_SIZE;
			_block2.height = Cell.HEIGHT_SIZE;
			_block2.x = _block1.x;
			_block2.y = _block1.y + _block1.height + 10;
			_block2.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_block2);
			
			_block3 = new Button(_resources.getSubTexture("FieldSpriteSheet.png", "micky"));
			_block3.name = BlockType.MICKY;
			_block3.width = Cell.WIDTH_SIZE;
			_block3.height = Cell.HEIGHT_SIZE;
			_block3.x = _block2.x;
			_block3.y = _block2.y + _block2.height + 10;
			_block3.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_block3);
			
			_block4 = new Button(_resources.getSubTexture("FieldSpriteSheet.png", "mongyi"));
			_block4.name = BlockType.MONGYI;
			_block4.width = Cell.WIDTH_SIZE;
			_block4.height = Cell.HEIGHT_SIZE;
			_block4.x = _block3.x;
			_block4.y = _block3.y + _block3.height + 10;
			_block4.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_block4);
			
			_block5 = new Button(_resources.getSubTexture("FieldSpriteSheet.png", "pinky"));
			_block5.name = BlockType.PINKY;
			_block5.width = Cell.WIDTH_SIZE;
			_block5.height = Cell.HEIGHT_SIZE;
			_block5.x = _block4.x;
			_block5.y = _block4.y + _block4.height + 10;
			_block5.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_block5);
			
			_wall = new Button(Texture.fromBitmap(new wallImage() as Bitmap));
			_wall.name = BlockType.WALL;
			_wall.width = Cell.WIDTH_SIZE;
			_wall.height = Cell.HEIGHT_SIZE;
			_wall.x = _block5.x;
			_wall.y = _block5.y + _block5.height + 10;
			_wall.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_wall);
			
			_countUpButton = new Button(_resources.getSubTexture("StageSelectSceneSpriteSheet.png", "upArrow"));
			_countUpButton.width = 50;
			_countUpButton.height = 50;
			_countUpButton.x = Field.PADDING;
			_countUpButton.y = Field.PADDING + (13 * Cell.HEIGHT_SIZE);
			_countUpButton.addEventListener(Event.TRIGGERED, onClickedUpButton);
			addChild(_countUpButton);
			
			_countTimeText = new TextField(200, 50);
			_countTimeText.text = "제한시간 : " + _countTime + "초";
			_countTimeText.format.bold = true;
			_countTimeText.format.size = 20;
			_countTimeText.format.color = Color.RED;
			_countTimeText.x = _countUpButton.x + _countUpButton.width;
			_countTimeText.y = _countUpButton.y;
			addChild(_countTimeText);
			
			_countDownButton = new Button(_resources.getSubTexture("StageSelectSceneSpriteSheet.png", "downArrow"));
			_countDownButton.width = 50;
			_countDownButton.height = 50;
			_countDownButton.x = _countTimeText.x + _countTimeText.width;
			_countDownButton.y = _countTimeText.y;
			_countDownButton.addEventListener(Event.TRIGGERED, onClickedDownButton);
			addChild(_countDownButton);
			
			_testButton = new Button(_resources.getSubTexture("FieldSpriteSheet.png", "backGround"), "TEST");
			_testButton.width = 80;
			_testButton.height = 60;
			_testButton.textFormat.bold = true;
			_testButton.textFormat.size = 20;
			_testButton.x = 380;
			_testButton.y = 870;
			_testButton.addEventListener(Event.TRIGGERED, onClickdedTestButton);
			addChild(_testButton);
		}
		
		private function onClickedBlock(event:Event):void
		{
			trace("aa");
			
			var target:Button = event.currentTarget as Button;
			
			if(!_currentClickedCell)
				return;
			
			_currentClickedCell.name = target.name;
			_currentClickedCell.setBackGroundTexture(target.upState);
			
			_currentClickedCell.dispatchEvent(new Event(Event.TRIGGERED));
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
		
		private function onClickdedTestButton(event:Event):void
		{
			createNativeWindow();
		}
		
		private function onClickedUpButton(event:Event):void
		{
			_countTime += 10;
			_countTimeText.text = "제한시간 : " + _countTime + "초";
		}
		
		private function onClickedDownButton(event:Event):void
		{
			_countTime -= 10;
			if(_countTime < 0)
				_countTime = 0;
			
			_countTimeText.text = "제한시간 : " + _countTime + "초";
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				trace(touch.getLocation(_backGround));
			}
		}
		
		private function createNativeWindow():void
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.transparent = false;
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.renderMode = NativeWindowRenderMode.DIRECT;
			options.type = NativeWindowType.NORMAL;
			
			var newWindow:NewWindow = new NewWindow(options);
			
			newWindow.title = "A title";
			newWindow.width = 600;
			newWindow.height = 1024;
			
			newWindow.stage.align = StageAlign.TOP_LEFT;
			newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			newWindow.activate();
			
			newWindow.startStarling();
		}
	}
}