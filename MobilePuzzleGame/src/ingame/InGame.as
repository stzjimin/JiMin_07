package ingame
{
	import flash.display.Bitmap;
	
	import customize.Scene;
	import customize.SceneManager;
	
	import ingame.cell.blocks.BlockData;
	import ingame.cell.blocks.BlockType;
	import ingame.timer.Timer;
	
	import starling.animation.Juggler;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class InGame extends Scene
	{	
		[Embed(source="popUpButton.png")]
		private const popUpButtonImage:Class;
		
		[Embed(source="IngameBackGround.png")]
		private const testBackGroundImage:Class;
		
		private var _backGround:Image;
		
		private var _paused:Boolean;
		private var _timer:Timer;
		
		private var _items:Items;
		
		private var _playJuggler:Juggler;
		
		private var _field:Field;
		private var _settingPopup:SettingPopup;
		private var _settingButton:Button;
		
		private var _blockDatas:Vector.<BlockData>;
		
		public function InGame()
		{
			super();
			
			_paused = true;
			
			this.width = 576;
			this.height = 1024;
			
			_backGround = new Image(Texture.fromBitmap(new testBackGroundImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			addChild(_backGround);
			
			_timer = new Timer();
			_timer.init(50, 10, 450, 70);
			_timer.addEventListener(Timer.TIME_OVER, onTimeOver);
			_timer.startCount(60);
			addChild(_timer);
			
			_items = new Items();
			_items.init(280, 70);
			_items.x = 300;
			_items.y = 950;
			_items.addEventListener(Item.FORK, onClickedFork);
			_items.addEventListener(Item.SEARCH, onClickedSearch);
			_items.addEventListener(Item.SHUFFLE, onClickedShuffle);
			addChild(_items);
			
			_blockDatas = new Vector.<BlockData>();
			_blockDatas.push(new BlockData(0, 0, BlockType.BLUE));
			_blockDatas.push(new BlockData(11, 11, BlockType.BLUE));
			_blockDatas.push(new BlockData(1, 8, BlockType.BLUE));
			_blockDatas.push(new BlockData(1, 1, BlockType.MICKY));
			_blockDatas.push(new BlockData(2, 1, BlockType.MICKY));
			_blockDatas.push(new BlockData(6, 6, BlockType.MICKY));
			_blockDatas.push(new BlockData(2, 2, BlockType.PINKY));
			_blockDatas.push(new BlockData(4, 3, BlockType.PINKY));
			_blockDatas.push(new BlockData(6, 4, BlockType.MICKY));
			_blockDatas.push(new BlockData(2, 5, BlockType.BLUE));
			_blockDatas.push(new BlockData(1, 4, BlockType.MICKY));
			_blockDatas.push(new BlockData(1, 5, BlockType.MICKY));
			_blockDatas.push(new BlockData(1, 2, BlockType.BLUE));
			_blockDatas.push(new BlockData(5, 1, BlockType.BLUE));
			_blockDatas.push(new BlockData(4, 2, BlockType.PINKY));
			_blockDatas.push(new BlockData(3, 6, BlockType.PINKY));
			_blockDatas.push(new BlockData(10, 10, BlockType.MONGYI));
			_blockDatas.push(new BlockData(10, 3, BlockType.MONGYI));
			_blockDatas.push(new BlockData(7, 10, BlockType.LUCY));
			_blockDatas.push(new BlockData(10, 5, BlockType.LUCY));
			_blockDatas.push(new BlockData(10, 5, BlockType.LUCY));
			_blockDatas.push(new BlockData(10, 1, BlockType.LUCY));
			_blockDatas.push(new BlockData(10, 2, BlockType.LUCY));
			_blockDatas.push(new BlockData(10, 8, BlockType.LUCY));
			_blockDatas.push(new BlockData(8, 5, BlockType.LUCY));
			_blockDatas.push(new BlockData(3, 5, BlockType.LUCY));
			_blockDatas.push(new BlockData(10, 9, BlockType.LUCY));
			_blockDatas.push(new BlockData(9, 3, BlockType.LUCY));
			_blockDatas.push(new BlockData(7, 5, BlockType.LUCY));
			
			_field = new Field();
//			_field.x = 18;
			_field.y = 100;
			_field.init();
			addChild(_field);
			
			_settingButton = new Button(Texture.fromBitmap(new popUpButtonImage() as Bitmap));
			_settingButton.x = 536;
			_settingButton.width = 40;
			_settingButton.height = 40;
			_settingButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_settingButton);
			
			_settingPopup = new SettingPopup(400, 300);
			_settingPopup.addEventListener(Popup.COVER_CLICKED, onClickedCover);
			_settingPopup.addEventListener(SettingPopup.CONTINUE_CLICKED, onClickedContinue);
			_settingPopup.addEventListener(SettingPopup.MENU_CLICKED, onClickedMenu);
			_settingPopup.addEventListener(SettingPopup.RESTART_CLICKED, onClickedRestart);
			addChild(_settingPopup);
			
			var blockData:BlockData;
			while(_blockDatas.length != 0)
			{
				blockData = _blockDatas.shift();
				_field.createBlock(blockData);
			}
			blockData = null;
			
			_field.checkPossibleCell();
			
			_playJuggler = new Juggler();
			_playJuggler.add(_field);
			_playJuggler.add(_timer);
			
			trace(flash.display.Screen.mainScreen.bounds);
			//			
			//			_button = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
			//			_button.x = 300;
			//			_button.y = 800;
			//			_button.addEventListener(Event.TRIGGERED, onTriggered2);
			//			addChild(_button);
			
			//			this.alignPivot();
			//			
			//			this.x = flash.display.Screen.mainScreen.bounds.width / 2;
			//			this.y = flash.display.Screen.mainScreen.bounds.height / 2;
			//			
			//			this.width = flash.display.Screen.mainScreen.bounds.width /11 * 10; 
			//			this.height = flash.display.Screen.mainScreen.bounds.height /11 * 10;
		}
		
		protected override function onStart(event:Event):void
		{
			_paused = false;
			//음악 on
		}
		
		protected override function onEnded(event:Event):void
		{
			//음악 off
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			if(!_paused)
				_playJuggler.advanceTime(event.passedTime);
		}
		
		public override function destroy():void
		{
			_timer.removeEventListener(Timer.TIME_OVER, onTimeOver);
			_timer.destroy();
			
			_field.destroy();
			
			_backGround.dispose();
			
			_settingButton.removeEventListener(Event.TRIGGERED, onClickedSettingButton);
			_settingButton.dispose();
			
			_settingPopup.removeEventListener(Popup.COVER_CLICKED, onClickedCover);
			_settingPopup.removeEventListener(SettingPopup.CONTINUE_CLICKED, onClickedContinue);
			_settingPopup.removeEventListener(SettingPopup.MENU_CLICKED, onClickedMenu);
			_settingPopup.removeEventListener(SettingPopup.RESTART_CLICKED, onClickedRestart);
			_settingPopup.destroy();
			
			_items.removeEventListener(Item.FORK, onClickedFork);
			_items.removeEventListener(Item.SEARCH, onClickedSearch);
			_items.removeEventListener(Item.SHUFFLE, onClickedShuffle);
			_items.destroy();
			
			removeChildren(0, numChildren);
			
			dispose();
		}
		
		private function onClickedFork(event:Event):void
		{
			trace("fork");
		}
		
		private function onClickedSearch(event:Event):void
		{
			trace("search");
		}
		
		private function onClickedShuffle(event:Event):void
		{
			trace("shuffle");
		}
		
		private function keepPlay():void
		{
			_paused = false;
			_settingPopup.visible = false; 
//			_field.touchable = true;
		}
		
		private function onClickedContinue(event:Event):void
		{
			keepPlay();
		}
		
		private function onClickedMenu(event:Event):void
		{
			SceneManager.current.outScene();
		}
		
		private function onClickedRestart(event:Event):void
		{
			
		}
		
		private function onClickedCover(event:Event):void
		{
			keepPlay();
		}
		
		private function onTimeOver(event:Event):void
		{
			trace("끝");
			_paused = false;
			_field.touchable = false;
		}
		
		private function onClickedSettingButton(event:Event):void
		{
			_paused = !_paused;
			if(_paused)
			{
				_settingPopup.visible = true;
//				_field.touchable = false;
			}
			else
			{
				_settingPopup.visible = false;
//				_field.touchable = true;
				//				SceneManager.current.goScene("title");
			}
		}
	}
}