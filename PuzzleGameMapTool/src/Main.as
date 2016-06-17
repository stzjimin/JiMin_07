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
	import flash.events.KeyboardEvent;
	import flash.net.FileFilter;
	import flash.ui.Keyboard;
	
	import puzzle.ingame.Field;
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.NeigborType;
	import puzzle.ingame.cell.blocks.BlockType;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	
	import starlingOrigin.display.Button;
	import starlingOrigin.display.DisplayObjectContainer;
	import starlingOrigin.display.Image;
	import starlingOrigin.events.Event;
	import starlingOrigin.events.Touch;
	import starlingOrigin.events.TouchEvent;
	import starlingOrigin.events.TouchPhase;
	import starlingOrigin.text.TextField;
	import starlingOrigin.textures.Texture;
	import starlingOrigin.utils.Color;

	public class Main extends DisplayObjectContainer
	{	
		[Embed(source="wall.png")]
		private const wallImage:Class;
		
		[Embed(source="backGround.png")]
		private const backGroundImage:Class;
		
		[Embed(source="IngameBackGround.png")]
		private const ingameBackGroundImage:Class;
		
		[Embed(source="blue.png")]
		private const blueImage:Class;
		[Embed(source="blue_circle.png")]
		private const blueCircleImage:Class;
		[Embed(source="blue_line.png")]
		private const blueLineImage:Class;
		
		[Embed(source="lucy.png")]
		private const lucyImage:Class;
		[Embed(source="lucy_circle.png")]
		private const lucyCircleImage:Class;
		[Embed(source="lucy_line.png")]
		private const lucyLineImage:Class;
		
		[Embed(source="micky.png")]
		private const mickyImage:Class;
		[Embed(source="micky_circle.png")]
		private const mickyCircleImage:Class;
		[Embed(source="micky_line.png")]
		private const mickyLineImage:Class;
		
		[Embed(source="mongyi.png")]
		private const mongyiImage:Class;
		[Embed(source="mongyi_circle.png")]
		private const mongyiCircleImage:Class;
		[Embed(source="mongyi_line.png")]
		private const mongyiLineImage:Class;
		
		[Embed(source="pinky.png")]
		private const pinkyImage:Class;
		[Embed(source="pinky_circle.png")]
		private const pinkyCircleImage:Class;
		[Embed(source="pinky_line.png")]
		private const pinkyLineImage:Class;
		
		[Embed(source="ari.png")]
		private const ariImage:Class;
		[Embed(source="ari_circle.png")]
		private const ariCircleImage:Class;
		[Embed(source="ari_line.png")]
		private const ariLineImage:Class;
		
		[Embed(source="upArrow.png")]
		private const upArrowImage:Class;
		[Embed(source="downArrow.png")]
		private const downArrowImage:Class;
		
		public static const ROW_NUM:uint = 12;
		public static const COLUMN_NUM:uint = 12;
		public static const PADDING:uint = 18;
		
		public static const NONE:String = "None";
		
//		private var _spirteDir:File = File.applicationDirectory.resolvePath("puzzle/resources/spriteSheet");
//		private var _soundDir:File = File.applicationDirectory.resolvePath("puzzle/resources/sound");
//		private var _imageDir:File = File.applicationDirectory.resolvePath("puzzle/resources/image");
		private var _resources:MapToolResources;
		
		private var _backGround:Image;
		private var _cells:Vector.<MapToolCell>;
		
		private var _currentClickedCell:MapToolCell;
		
		private var _blockTypes:Vector.<String>;
		
		private var _blueBlock:Button;
		private var _blueCircleBlock:Button;
		private var _blueLineBlock:Button;
		
		private var _lucyBlock:Button;
		private var _lucyCircleBlock:Button;
		private var _lucyLineBlock:Button;
		
		private var _mickyBlock:Button;
		private var _mickyCircleBlock:Button;
		private var _mickyLineBlock:Button;
		
		private var _mongyiBlock:Button;
		private var _mongyiCircleBlock:Button;
		private var _mongyiLineBlock:Button;
		
		private var _pinkyBlock:Button;
		private var _pinkyCircleBlock:Button;
		private var _pinkyLineBlock:Button;
		
		private var _ariBlock:Button;
		private var _ariCircleBlock:Button;
		private var _ariLineBlock:Button;
		
		private var _wall:Button;
		private var _removeBlockButton:Button;
		
		private var _blueTexture:Texture;
		private var _blueCircleTexture:Texture;
		private var _blueLineTexture:Texture;
		
		private var _lucyTexture:Texture;
		private var _lucyCircleTexture:Texture;
		private var _lucyLineTexture:Texture;
		
		private var _mickyTexture:Texture;
		private var _mickyCircleTexture:Texture;
		private var _mickyLineTexture:Texture;
		
		private var _mongyiTexture:Texture;
		private var _mongyiCircleTexture:Texture;
		private var _mongyiLineTexture:Texture;
		
		private var _pinkyTexture:Texture;
		private var _pinkyCircleTexture:Texture;
		private var _pinkyLineTexture:Texture;
		
		private var _ariTexture:Texture;
		private var _ariCircleTexture:Texture;
		private var _ariLineTexture:Texture;
		
		private var _wallTexture:Texture;
		private var _emptyBlockTexture:Texture;
		
		private var _countTime:int;
		private var _countTimeText:TextField;
		private var _countUpButton:Button;
		private var _countDownButton:Button;
		
		private var _testButton:Button;
		private var _saveButton:Button;
		private var _loadButton:Button;
		private var _clearButton:Button;
		
		private var _newWindow:NewWindow;
		
//		private var _cells:Vector.<MapToolCell>;
		
		public function Main()
		{
			super();
			
			_resources = new MapToolResources(Resources.SpriteDir, Resources.SoundDir, Resources.ImageDir);
			
			_resources.addSpriteName("IngameSpriteSheet.png");
//			_resources.addSpriteName("StageSelectSceneSpriteSheet.png");
//			_resources.addSpriteName("UserInfoSpriteSheet.png");
//			_resources.addSpriteName("PausePopupSpriteSheet.png");
//			_resources.addSpriteName("ResultSpriteSheet.png");
//			_resources.addSpriteName("StagePopupSpriteSheet.png");
			_resources.addSpriteName("FieldSpriteSheet.png");
//			_resources.addSpriteName("ShopSpriteSheet.png");
//			_resources.addSpriteName("RankingSpriteSheet.png");
//			_resources.addSpriteName("readyClip.png");
			_resources.addSoundName("MilkOut.mp3");
			_resources.addSoundName("NeverForget.mp3");
			_resources.addSoundName("set.mp3");
			_resources.addSoundName("clear.mp3");
			_resources.addSoundName("fork.mp3");
			_resources.addSoundName("searchSound.mp3");
			_resources.addSoundName("shuffleSound2.mp3");
			
			_resources.addEventListener(MapToolLoadingEvent.COMPLETE, onCompleteLoading);
			_resources.addEventListener(MapToolLoadingEvent.FAILED, onFailedLoading);
			_resources.loadResource();
		}
		
		private function onFailedLoading(event:MapToolLoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(MapToolLoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(MapToolLoadingEvent .FAILED, onFailedLoading);
			_resources.destroy();
			NativeApplication.nativeApplication.exit();
		}
		
		private function onCompleteLoading(event:MapToolLoadingEvent):void
		{
			_countTime = 10;
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_backGround = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "IngameBackGround"));
			_backGround.width = 800;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_emptyBlockTexture = Texture.fromBitmap(new backGroundImage() as Bitmap);
			
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
				cell.name = Main.NONE;
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
			
			_blueTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.BLUE);
			_blueCircleTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.BLUE_CIRCLE);
			_blueLineTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.BLUE_LINE);
				
			_lucyTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.LUCY);
			_lucyCircleTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.LUCY_CIRCLE);
			_lucyLineTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.LUCY_LINE);
			
			_mickyTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.MICKY);
			_mickyCircleTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.MICKY_CIRCLE);
			_mickyLineTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.MICKY_LINE);
			
			_mongyiTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.MONGYI);
			_mongyiCircleTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.MONGYI_CIRCLE);
			_mongyiLineTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.MONGYI_LINE);
			
			_pinkyTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.PINKY);
			_pinkyCircleTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.PINKY_CIRCLE);
			_pinkyLineTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.PINKY_LINE);
			
			_ariTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.ARI);
			_ariCircleTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.ARI_CIRCLE);
			_ariLineTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.ARI_LINE);
			
			_wallTexture = _resources.getSubTexture("FieldSpriteSheet.png", BlockType.WALL);
			
			_blueBlock = new Button(_blueTexture, "Q");
			_blueBlock.textFormat.bold = true;
			_blueBlock.textFormat.size = 20;
			_blueBlock.textFormat.color = Color.RED;
			_blueBlock.name = BlockType.BLUE;
			_blueBlock.width = Cell.WIDTH_SIZE;
			_blueBlock.height = Cell.HEIGHT_SIZE;
			_blueBlock.x = Field.PADDING + (13 * Cell.WIDTH_SIZE);
			_blueBlock.y = Field.PADDING;
			_blueBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_blueBlock);
			
			_blueCircleBlock = new Button(_blueCircleTexture, "ctrl+Q");
			_blueCircleBlock.textFormat.bold = true;
			_blueCircleBlock.textFormat.size = 20;
			_blueCircleBlock.textFormat.color = Color.RED;
			_blueCircleBlock.name = BlockType.BLUE_CIRCLE;
			_blueCircleBlock.width = Cell.WIDTH_SIZE;
			_blueCircleBlock.height = Cell.HEIGHT_SIZE;
			_blueCircleBlock.x = _blueBlock.x + _blueBlock.width + 10;
			_blueCircleBlock.y = _blueBlock.y;
			_blueCircleBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_blueCircleBlock);
			
			_blueLineBlock = new Button(_blueLineTexture, "alt+Q");
			_blueLineBlock.textFormat.bold = true;
			_blueLineBlock.textFormat.size = 20;
			_blueLineBlock.textFormat.color = Color.RED;
			_blueLineBlock.name = BlockType.BLUE_LINE;
			_blueLineBlock.width = Cell.WIDTH_SIZE;
			_blueLineBlock.height = Cell.HEIGHT_SIZE;
			_blueLineBlock.x = _blueCircleBlock.x + _blueCircleBlock.width + 10;
			_blueLineBlock.y = _blueCircleBlock.y;
			_blueLineBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_blueLineBlock);
			
			_lucyBlock = new Button(_lucyTexture, "W");
			_lucyBlock.textFormat.bold = true;
			_lucyBlock.textFormat.size = 20;
			_lucyBlock.textFormat.color = Color.RED;
			_lucyBlock.name = BlockType.LUCY;
			_lucyBlock.width = Cell.WIDTH_SIZE;
			_lucyBlock.height = Cell.HEIGHT_SIZE;
			_lucyBlock.x = _blueBlock.x;
			_lucyBlock.y = _blueBlock.y + _blueBlock.height + 10;
			_lucyBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_lucyBlock);
			
			_lucyCircleBlock = new Button(_lucyCircleTexture, "ctrl+W");
			_lucyCircleBlock.textFormat.bold = true;
			_lucyCircleBlock.textFormat.size = 20;
			_lucyCircleBlock.textFormat.color = Color.RED;
			_lucyCircleBlock.name = BlockType.LUCY_CIRCLE;
			_lucyCircleBlock.width = Cell.WIDTH_SIZE;
			_lucyCircleBlock.height = Cell.HEIGHT_SIZE;
			_lucyCircleBlock.x = _lucyBlock.x + _lucyBlock.width + 10;
			_lucyCircleBlock.y = _lucyBlock.y;
			_lucyCircleBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_lucyCircleBlock);
			
			_lucyLineBlock = new Button(_lucyLineTexture, "alt+W");
			_lucyLineBlock.textFormat.bold = true;
			_lucyLineBlock.textFormat.size = 20;
			_lucyLineBlock.textFormat.color = Color.RED;
			_lucyLineBlock.name = BlockType.LUCY_LINE;
			_lucyLineBlock.width = Cell.WIDTH_SIZE;
			_lucyLineBlock.height = Cell.HEIGHT_SIZE;
			_lucyLineBlock.x = _lucyCircleBlock.x + _lucyCircleBlock.width + 10;
			_lucyLineBlock.y = _lucyCircleBlock.y;
			_lucyLineBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_lucyLineBlock);
			
			_mickyBlock = new Button(_mickyTexture, "E");
			_mickyBlock.textFormat.bold = true;
			_mickyBlock.textFormat.size = 20;
			_mickyBlock.textFormat.color = Color.RED;
			_mickyBlock.name = BlockType.MICKY;
			_mickyBlock.width = Cell.WIDTH_SIZE;
			_mickyBlock.height = Cell.HEIGHT_SIZE;
			_mickyBlock.x = _lucyBlock.x;
			_mickyBlock.y = _lucyBlock.y + _lucyBlock.height + 10;
			_mickyBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_mickyBlock);
			
			_mickyCircleBlock = new Button(_mickyCircleTexture, "ctrl+E");
			_mickyCircleBlock.textFormat.bold = true;
			_mickyCircleBlock.textFormat.size = 20;
			_mickyCircleBlock.textFormat.color = Color.RED;
			_mickyCircleBlock.name = BlockType.MICKY_CIRCLE;
			_mickyCircleBlock.width = Cell.WIDTH_SIZE;
			_mickyCircleBlock.height = Cell.HEIGHT_SIZE;
			_mickyCircleBlock.x = _mickyBlock.x + _mickyBlock.width + 10;
			_mickyCircleBlock.y = _mickyBlock.y;
			_mickyCircleBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_mickyCircleBlock);
			
			_mickyLineBlock = new Button(_mickyLineTexture, "alt+E");
			_mickyLineBlock.textFormat.bold = true;
			_mickyLineBlock.textFormat.size = 20;
			_mickyLineBlock.textFormat.color = Color.RED;
			_mickyLineBlock.name = BlockType.MICKY_LINE;
			_mickyLineBlock.width = Cell.WIDTH_SIZE;
			_mickyLineBlock.height = Cell.HEIGHT_SIZE;
			_mickyLineBlock.x = _mickyCircleBlock.x + _mickyCircleBlock.width + 10;
			_mickyLineBlock.y = _mickyCircleBlock.y;
			_mickyLineBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_mickyLineBlock);
			
			_mongyiBlock = new Button(_mongyiTexture, "R");
			_mongyiBlock.textFormat.bold = true;
			_mongyiBlock.textFormat.size = 20;
			_mongyiBlock.textFormat.color = Color.RED;
			_mongyiBlock.name = BlockType.MONGYI;
			_mongyiBlock.width = Cell.WIDTH_SIZE;
			_mongyiBlock.height = Cell.HEIGHT_SIZE;
			_mongyiBlock.x = _mickyBlock.x;
			_mongyiBlock.y = _mickyBlock.y + _mickyBlock.height + 10;
			_mongyiBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_mongyiBlock);
			
			_mongyiCircleBlock = new Button(_mongyiCircleTexture, "ctrl+R");
			_mongyiCircleBlock.textFormat.bold = true;
			_mongyiCircleBlock.textFormat.size = 20;
			_mongyiCircleBlock.textFormat.color = Color.RED;
			_mongyiCircleBlock.name = BlockType.MONGYI_CIRCLE;
			_mongyiCircleBlock.width = Cell.WIDTH_SIZE;
			_mongyiCircleBlock.height = Cell.HEIGHT_SIZE;
			_mongyiCircleBlock.x = _mongyiBlock.x + _mongyiBlock.width + 10;
			_mongyiCircleBlock.y = _mongyiBlock.y;
			_mongyiCircleBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_mongyiCircleBlock);
			
			_mongyiLineBlock = new Button(_mongyiLineTexture, "alt+R");
			_mongyiLineBlock.textFormat.bold = true;
			_mongyiLineBlock.textFormat.size = 20;
			_mongyiLineBlock.textFormat.color = Color.RED;
			_mongyiLineBlock.name = BlockType.MONGYI_LINE;
			_mongyiLineBlock.width = Cell.WIDTH_SIZE;
			_mongyiLineBlock.height = Cell.HEIGHT_SIZE;
			_mongyiLineBlock.x = _mongyiCircleBlock.x + _mongyiCircleBlock.width + 10;
			_mongyiLineBlock.y = _mongyiCircleBlock.y;
			_mongyiLineBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_mongyiLineBlock);
			
			_pinkyBlock = new Button(_pinkyTexture, "T");
			_pinkyBlock.textFormat.bold = true;
			_pinkyBlock.textFormat.size = 20;
			_pinkyBlock.textFormat.color = Color.RED;
			_pinkyBlock.name = BlockType.PINKY;
			_pinkyBlock.width = Cell.WIDTH_SIZE;
			_pinkyBlock.height = Cell.HEIGHT_SIZE;
			_pinkyBlock.x = _mongyiBlock.x;
			_pinkyBlock.y = _mongyiBlock.y + _mongyiBlock.height + 10;
			_pinkyBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_pinkyBlock);
			
			_pinkyCircleBlock = new Button(_pinkyCircleTexture, "atrl+T");
			_pinkyCircleBlock.textFormat.bold = true;
			_pinkyCircleBlock.textFormat.size = 20;
			_pinkyCircleBlock.textFormat.color = Color.RED;
			_pinkyCircleBlock.name = BlockType.PINKY_CIRCLE;
			_pinkyCircleBlock.width = Cell.WIDTH_SIZE;
			_pinkyCircleBlock.height = Cell.HEIGHT_SIZE;
			_pinkyCircleBlock.x = _pinkyBlock.x + _pinkyBlock.width + 10;
			_pinkyCircleBlock.y = _pinkyBlock.y;
			_pinkyCircleBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_pinkyCircleBlock);
			
			_pinkyLineBlock = new Button(_pinkyLineTexture, "alt+T");
			_pinkyLineBlock.textFormat.bold = true;
			_pinkyLineBlock.textFormat.size = 20;
			_pinkyLineBlock.textFormat.color = Color.RED;
			_pinkyLineBlock.name = BlockType.PINKY_LINE;
			_pinkyLineBlock.width = Cell.WIDTH_SIZE;
			_pinkyLineBlock.height = Cell.HEIGHT_SIZE;
			_pinkyLineBlock.x = _pinkyCircleBlock.x + _pinkyCircleBlock.width + 10;
			_pinkyLineBlock.y = _pinkyCircleBlock.y;
			_pinkyLineBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_pinkyLineBlock);
			
			_ariBlock = new Button(_ariTexture, "Y");
			_ariBlock.textFormat.bold = true;
			_ariBlock.textFormat.size = 20;
			_ariBlock.textFormat.color = Color.RED;
			_ariBlock.name = BlockType.ARI;
			_ariBlock.width = Cell.WIDTH_SIZE;
			_ariBlock.height = Cell.HEIGHT_SIZE;
			_ariBlock.x = _pinkyBlock.x;
			_ariBlock.y = _pinkyBlock.y + _pinkyBlock.height + 10;
			_ariBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_ariBlock);
			
			_ariCircleBlock = new Button(_ariCircleTexture, "ctrl+Y");
			_ariCircleBlock.textFormat.bold = true;
			_ariCircleBlock.textFormat.size = 20;
			_ariCircleBlock.textFormat.color = Color.RED;
			_ariCircleBlock.name = BlockType.ARI_CIRCLE;
			_ariCircleBlock.width = Cell.WIDTH_SIZE;
			_ariCircleBlock.height = Cell.HEIGHT_SIZE;
			_ariCircleBlock.x = _ariBlock.x + _ariBlock.width + 10;
			_ariCircleBlock.y = _ariBlock.y;
			_ariCircleBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_ariCircleBlock);
			
			_ariLineBlock = new Button(_ariLineTexture, "alt+Y");
			_ariLineBlock.textFormat.bold = true;
			_ariLineBlock.textFormat.size = 20;
			_ariLineBlock.textFormat.color = Color.RED;
			_ariLineBlock.name = BlockType.ARI_LINE;
			_ariLineBlock.width = Cell.WIDTH_SIZE;
			_ariLineBlock.height = Cell.HEIGHT_SIZE;
			_ariLineBlock.x = _ariCircleBlock.x + _ariCircleBlock.width + 10;
			_ariLineBlock.y = _ariCircleBlock.y;
			_ariLineBlock.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_ariLineBlock);
			
			_wall = new Button(_wallTexture, "A");
			_wall.textFormat.bold = true;
			_wall.textFormat.size = 20;
			_wall.name = BlockType.WALL;
			_wall.width = Cell.WIDTH_SIZE;
			_wall.height = Cell.HEIGHT_SIZE;
			_wall.x = _ariBlock.x;
			_wall.y = _ariBlock.y + _ariBlock.height + 10;
			_wall.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_wall);
			
			_removeBlockButton = new Button(Texture.fromBitmap(new backGroundImage() as Bitmap), "C");
			_removeBlockButton.textFormat.bold = true;
			_removeBlockButton.textFormat.size = 20;
			_removeBlockButton.name = Main.NONE;
			_removeBlockButton.width = Cell.WIDTH_SIZE;
			_removeBlockButton.height = Cell.HEIGHT_SIZE;
			_removeBlockButton.x = _ariCircleBlock.x;
			_removeBlockButton.y = _ariCircleBlock.y + _ariCircleBlock.height + 10;
			_removeBlockButton.addEventListener(Event.TRIGGERED, onClickedBlock);
			addChild(_removeBlockButton);
				
			_countUpButton = new Button(Texture.fromBitmap(new upArrowImage() as Bitmap));
			_countUpButton.width = 50;
			_countUpButton.height = 50;
			_countUpButton.x = Field.PADDING;
			_countUpButton.y = Field.PADDING + (13 * Cell.HEIGHT_SIZE);
			_countUpButton.addEventListener(Event.TRIGGERED, onClickedUpButton);
			addChild(_countUpButton);
			
			_countTimeText = new TextField(200, 50);
			_countTimeText.border = true;
			_countTimeText.text = "제한시간 : " + _countTime + "초";
			_countTimeText.format.bold = true;
			_countTimeText.format.size = 20;
			_countTimeText.format.color = Color.RED;
			_countTimeText.x = _countUpButton.x + _countUpButton.width;
			_countTimeText.y = _countUpButton.y;
			addChild(_countTimeText);
			
			_countDownButton = new Button(Texture.fromBitmap(new downArrowImage() as Bitmap));
			_countDownButton.width = 50;
			_countDownButton.height = 50;
			_countDownButton.x = _countTimeText.x + _countTimeText.width;
			_countDownButton.y = _countTimeText.y;
			_countDownButton.addEventListener(Event.TRIGGERED, onClickedDownButton);
			addChild(_countDownButton);
			
			_testButton = new Button(Texture.fromBitmap(new backGroundImage() as Bitmap), "TEST");
			_testButton.width = 80;
			_testButton.height = 60;
			_testButton.textFormat.bold = true;
			_testButton.textFormat.size = 20;
			_testButton.x = 380;
			_testButton.y = 870;
			_testButton.addEventListener(Event.TRIGGERED, onClickdedTestButton);
			addChild(_testButton);
			
			_saveButton = new Button(Texture.fromBitmap(new backGroundImage() as Bitmap), "SAVE");
			_saveButton.width = 80;
			_saveButton.height = 60;
			_saveButton.textFormat.bold = true;
			_saveButton.textFormat.size = 20;
			_saveButton.x = _testButton.x + _testButton.width + 20;
			_saveButton.y = _testButton.y;
			_saveButton.addEventListener(Event.TRIGGERED, onClickdedSaveButton);
			addChild(_saveButton);
			
			_loadButton = new Button(Texture.fromBitmap(new backGroundImage() as Bitmap), "LOAD");
			_loadButton.width = 80;
			_loadButton.height = 60;
			_loadButton.textFormat.bold = true;
			_loadButton.textFormat.size = 20;
			_loadButton.x = _saveButton.x + _saveButton.width + 20;
			_loadButton.y = _saveButton.y;
			_loadButton.addEventListener(Event.TRIGGERED, onClickdedLoadButton);
			addChild(_loadButton);
			
			_clearButton = new Button(Texture.fromBitmap(new backGroundImage() as Bitmap), "CLEAR");
			_clearButton.width = 80;
			_clearButton.height = 60;
			_clearButton.textFormat.bold = true;
			_clearButton.textFormat.size = 20;
			_clearButton.x = _loadButton.x + _loadButton.width + 20;
			_clearButton.y = _loadButton.y;
			_clearButton.addEventListener(Event.TRIGGERED, onClickdedClearButton);
			addChild(_clearButton);
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
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.Q :
					if(event.ctrlKey)
						_blueCircleBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else if(event.altKey)
						_blueLineBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else
						_blueBlock.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.W :
					if(event.ctrlKey)
						_lucyCircleBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else if(event.altKey)
						_lucyLineBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else
						_lucyBlock.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.E :
					if(event.ctrlKey)
						_mickyCircleBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else if(event.altKey)
						_mickyLineBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else
						_mickyBlock.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.R :
					if(event.ctrlKey)
						_mongyiCircleBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else if(event.altKey)
						_mongyiLineBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else
						_mongyiBlock.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.T :
					if(event.ctrlKey)
						_pinkyCircleBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else if(event.altKey)
						_pinkyLineBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else
						_pinkyBlock.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.Y :
					if(event.ctrlKey)
						_ariCircleBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else if(event.altKey)
						_ariLineBlock.dispatchEvent(new Event(Event.TRIGGERED));
					else
						_ariBlock.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.A :
					_wall.dispatchEvent(new Event(Event.TRIGGERED));
					break;
				case Keyboard.C :
					_removeBlockButton.dispatchEvent(new Event(Event.TRIGGERED));
					break;
			}
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
			var jsonString:String = parseData();
			if(jsonString == null)
				trace("블럭잉벗음");
			else
				createNativeWindow(jsonString);
		}
		
		private function onClickdedSaveButton(event:Event):void
		{
			var jsonString:String = parseData();
			
			var ioManager:FileIOManager = new FileIOManager();
			ioManager.saveFile("저장 위치 선택", jsonString);
		}
		
		private function onClickdedLoadButton(event:Event):void
		{
			var ioManager:FileIOManager = new FileIOManager();
			ioManager.addEventListener(FileEvent.LOAD_COMPLETE, onCompleteLoad);
			ioManager.selectFile("저장 위치 선택", new FileFilter("JSON파일", "*.json"));
			
			function onCompleteLoad(event:FileEvent):void
			{
				fieldClear();
				
				trace(event.data as String);
				var mapData:Object = JSON.parse(event.data as String);
				_countTime = mapData.countTime;
				trace(mapData.countTime);
				swapCountTimeText();
				
				var blockData:Object = mapData.blockData;
				var index:int;
				var blockTexture:Texture;
				for(var i:int = 0; i < blockData.length; i++)
				{
					index = (blockData[i].row*ROW_NUM) + (blockData[i].column);
					
					var type:String = blockData[i].type;
					_cells[index].setBackGroundTexture(_resources.getSubTexture("FieldSpriteSheet.png", type));
					_cells[index].name = type;
//					if(type == BlockType.PINKY)
//					{
//						_cells[index].setBackGroundTexture(_pinkyTexture);
//						_cells[index].name = BlockType.PINKY;
//					}
//					else if(type == BlockType.BLUE)
//					{
//						_cells[index].setBackGroundTexture(_blueTexture);
//						_cells[index].name = BlockType.BLUE;
//					}
//					else if(type == BlockType.MICKY)
//					{
//						_cells[index].setBackGroundTexture(_mickyTexture);
//						_cells[index].name = BlockType.MICKY;
//					}
//					else if(type == BlockType.LUCY)
//					{
//						_cells[index].setBackGroundTexture(_lucyTexture);
//						_cells[index].name = BlockType.LUCY;
//					}
//					else if(type == BlockType.MONGYI)
//					{
//						_cells[index].setBackGroundTexture(_mongyiTexture);
//						_cells[index].name = BlockType.MONGYI;
//					}
//					else if(type == BlockType.WALL)
//					{
//						_cells[index].setBackGroundTexture(_wallTexture);
//						_cells[index].name = BlockType.WALL;
//					}
				}
			}
		}
		
		private function onClickdedClearButton(event:Event):void
		{
			fieldClear();
		}
		
		private function fieldClear():void
		{
			for(var i:int; i < _cells.length; i++)
			{
				_cells[i].name = Main.NONE;
				_cells[i].setBackGroundTexture(_emptyBlockTexture);
			}
		}
		
		private function parseData():String
		{
			var mapData:Object = new Object();
			mapData.countTime = _countTime;
			
			var blockData:Object = new Object();
			var length:int = 0;
			var block:Object;
			for(var i:int = 0; i < _cells.length; i++)
			{
				if(_cells[i].name != Main.NONE)
				{
					block = new Object();
					blockData[length] = block;
					blockData[length].row = _cells[i].row;
					blockData[length].column = _cells[i].column;
					blockData[length].type = _cells[i].name;
					length++;
				}
			}
			block = null;
			blockData.length = length;
			
			if(blockData.length == 0)
				return null;
			
			mapData.blockData = blockData;
			
			var jsonString:String = JSON.stringify(mapData);
			
			return jsonString
		}
		
		private function onClickedUpButton(event:Event):void
		{
			_countTime += 10;
			swapCountTimeText();
		}
		
		private function onClickedDownButton(event:Event):void
		{
			_countTime -= 10;
			if(_countTime < 10)
				_countTime = 10;
			
			swapCountTimeText();
		}
		
		private function swapCountTimeText():void
		{
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
		
		private function createNativeWindow(data:String):void
		{
			if(_newWindow != null)
			{
				trace("aa");
				_newWindow.close();
			}
			
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.transparent = false;
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.renderMode = NativeWindowRenderMode.DIRECT;
			options.type = NativeWindowType.NORMAL;
			
			_newWindow = new NewWindow(options);
			
			_newWindow.title = "A title";
			_newWindow.width = 600;
			_newWindow.height = 1024;
			
			_newWindow.stage.align = StageAlign.TOP_LEFT;
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_newWindow.activate();
			
			_newWindow.startStarling(data);
		}
	}
}