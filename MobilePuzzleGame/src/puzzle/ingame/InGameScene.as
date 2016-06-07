package puzzle.ingame
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.filesystem.File;
	
	import customize.Scene;
	import customize.SceneEvent;
	import customize.SceneManager;
	
	import puzzle.Popup;
	import puzzle.ingame.cell.blocks.BlockData;
	import puzzle.ingame.cell.blocks.BlockType;
	import puzzle.ingame.item.Items;
	import puzzle.ingame.item.fork.Forker;
	import puzzle.ingame.timer.ComboTimer;
	import puzzle.ingame.timer.Timer;
	import puzzle.ingame.util.possibleCheck.CheckEvent;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	
	import starling.animation.Juggler;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class InGameScene extends Scene
	{	
		private var _spirteDir:File = File.applicationDirectory.resolvePath("puzzle/ingame/ingameSpriteSheet");
		private var _resources:Resources;
		
		private var _backGround:Image;
		
		private var _blockCount:TextField;
		private var _possibleCount:TextField;
		
		private var _paused:Boolean;
		private var _timer:Timer;
		
		private var _comboTimer:ComboTimer;
		
		private var _items:Items;
		
		private var _playJuggler:Juggler;
		
		private var _field:Field;
		private var _pausePopup:PausePopup;
		private var _settingButton:Button;
		
		private var _blockDatas:Vector.<BlockData>;
		
		public function InGameScene()
		{
			super();
			_paused = true;
		}
		
		protected override function onCreate(event:SceneEvent):void
		{
			_resources = new Resources(_spirteDir, null, null);
			
			_resources.addSpriteName("IngameSprite0.png");
			_resources.addSpriteName("IngameSprite1.png");
			_resources.addSpriteName("IngameSprite2.png");
			
			_resources.addEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.addEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.loadResource();
		}
		
		protected override function onStart(event:SceneEvent):void
		{
			//음악 on
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			if(!_paused)
				_playJuggler.advanceTime(event.passedTime);
		}
		
		protected override function onEnded(event:SceneEvent):void
		{
			//음악 off
		}
		
		protected override function onDestroy(event:SceneEvent):void
		{
			_timer.removeEventListener(Timer.TIME_OVER, onTimeOver);
			_timer.removeFromParent();
			_timer.destroy();
			
			_comboTimer.removeEventListener(ComboTimer.COMBOED, onCombo);
			_comboTimer.removeFromParent();
			_comboTimer.destroy();
			
			_field.removeEventListener(CheckEvent.CHECKED_COMPLETE, onCompletePossibleCheck);
			_field.removeEventListener(Forker.GET_FORK, onGetFork);
			_field.removeEventListener(Field.PANG, onCompletePang);
			_field.removeFromParent();
			_field.destroy();
			
			_backGround.removeFromParent();
			_backGround.dispose();
			
			_settingButton.removeEventListener(Event.TRIGGERED, onClickedSettingButton);
			_settingButton.removeFromParent();
			_settingButton.dispose();
			
			_pausePopup.removeEventListener(Popup.COVER_CLICKED, onClickedCover);
			_pausePopup.removeEventListener(PausePopup.CONTINUE_CLICKED, onClickedContinue);
			_pausePopup.removeEventListener(PausePopup.MENU_CLICKED, onClickedMenu);
			_pausePopup.removeEventListener(PausePopup.RESTART_CLICKED, onClickedRestart);
			_pausePopup.removeFromParent();
			_pausePopup.destroy();
			
			_items.removeEventListener(Items.FORK_CHECK, onCheckedFork);
			_items.removeEventListener(Items.FORK_EMPTY, onEmptyFork);
			_items.removeEventListener(Items.SEARCH, onClickedSearch);
			_items.removeEventListener(Items.SHUFFLE, onClickedShuffle);
			_items.removeFromParent();
			_items.destroy();
			
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
			_resources = null;
			
			super.onDestroy(event);
		}
		
		private function onFailedLoading(event:LoadingEvent):void
		{
			trace(event.data);
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
			//			NativeApplication.nativeApplication.exit();
		}
		
		private function onCompleteLoading(event:LoadingEvent):void
		{
			addEventListener(SceneEvent.DEACTIVATE, onDeActivate);
			
			_paused = false;
			
			_backGround = new Image(_resources.getSubTexture("IngameSprite2.png", "IngameBackGround"));
			_backGround.width = 576;
			_backGround.height = 1024;
			addChild(_backGround);
			
			_blockCount = new TextField(70, 30);
			_blockCount.y = 10;
			_blockCount.format.bold = true;
			_blockCount.format.size = 20;
			_blockCount.format.color = Color.AQUA;
			addChild(_blockCount);
			
			_possibleCount = new TextField(70, 30);
			_possibleCount.y = 50;
			_possibleCount.format.bold = true;
			_possibleCount.format.size = 20;
			_possibleCount.format.color = Color.AQUA;
			addChild(_possibleCount);
			
			_timer = new Timer(_resources);
			_timer.init(70, 10, 450, 50);
			_timer.addEventListener(Timer.TIME_OVER, onTimeOver);
			_timer.startCount(60);
			addChild(_timer);
			
			_comboTimer = new ComboTimer();
			_comboTimer.init(520, 65, 100, 30, 3);
			_comboTimer.addEventListener(ComboTimer.COMBOED, onCombo);
			addChild(_comboTimer);
			
			_items = new Items(_resources);
			_items.init(280, 70);
			_items.x = 300;
			_items.y = 950;
			_items.addEventListener(Items.FORK_CHECK, onCheckedFork);
			_items.addEventListener(Items.FORK_EMPTY, onEmptyFork);
			_items.addEventListener(Items.SEARCH, onClickedSearch);
			_items.addEventListener(Items.SHUFFLE, onClickedShuffle);
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
			
			_field = new Field(_resources);
			//			_field.x = 18;
			_field.y = 100;
			_field.init();
			_field.addEventListener(CheckEvent.CHECKED_COMPLETE, onCompletePossibleCheck);
			_field.addEventListener(Forker.GET_FORK, onGetFork);
			_field.addEventListener(Field.PANG, onCompletePang);
			addChild(_field);
			
			_settingButton = new Button(_resources.getSubTexture("IngameSprite2.png", "popUpButton"));
			_settingButton.x = 536;
			_settingButton.width = 40;
			_settingButton.height = 40;
			_settingButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_settingButton);
			
			_pausePopup = new PausePopup(_resources);
			_pausePopup.init(400, 300);
			_pausePopup.addEventListener(Popup.COVER_CLICKED, onClickedCover);
			_pausePopup.addEventListener(PausePopup.CONTINUE_CLICKED, onClickedContinue);
			_pausePopup.addEventListener(PausePopup.MENU_CLICKED, onClickedMenu);
			_pausePopup.addEventListener(PausePopup.RESTART_CLICKED, onClickedRestart);
			addChild(_pausePopup);
			
			var blockData:BlockData;
			while(_blockDatas.length != 0)
			{
				blockData = _blockDatas.shift();
				_field.createBlock(blockData, _resources);
			}
			blockData = null;
			
			_field.checkPossibleCell();
			
			_playJuggler = new Juggler();
			_playJuggler.add(_field);
			_playJuggler.add(_timer);
			_playJuggler.add(_comboTimer);
			
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
		
		private function onDeActivate(event:SceneEvent):void
		{
			_settingButton.dispatchEvent(new Event(Event.TRIGGERED));
		}
		
		private function onCombo(event:Event):void
		{
			trace("현제 콤보 : " + event.data);
			_timer.addTime(0.5);
		}
		
		private function onCompletePang(event:Event):void
		{
			_comboTimer.startNewComboTime();
		}
		
		private function onCompletePossibleCheck(event:CheckEvent):void
		{
			_blockCount.text = event.blockCount.toString();
			_possibleCount.text = event.possibleCount.toString();
		}
		
		private function onGetFork(event:Event):void
		{
			_items.setEmptyFork();
		}
		
		private function onCheckedFork(event:Event):void
		{
			trace("forkCheck");
			_field.isFork = true;
		}
		
		private function onEmptyFork(event:Event):void
		{
			trace("forkEmpty");
			_field.isFork = false;
		}
		
		private function onClickedSearch(event:Event):void
		{
			trace("search");
			_field.search();
		}
		
		private function onClickedShuffle(event:Event):void
		{
			trace("shuffle");
//			_field.dispatchEvent(new Event("shuffle"));
			_field.shuffle();
		}
		
		private function keepPlay():void
		{
			_paused = false;
			_pausePopup.visible = false; 
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
			SceneManager.current.outScene();
			SceneManager.current.addScene(InGameScene, "game");
			SceneManager.current.goScene("game", this.data);
//			keepPlay();
//			_field.dispatchEvent(new Event("shuffle"));
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
//			SceneManager.current.outScene();
		}
		
		private function onClickedSettingButton(event:Event):void
		{
			_paused = !_paused;
			if(_paused)
			{
				_pausePopup.visible = true;
//				_field.touchable = false;
			}
			else
			{
				_pausePopup.visible = false;
//				_field.touchable = true;
				//				SceneManager.current.goScene("title");
			}
		}
	}
}