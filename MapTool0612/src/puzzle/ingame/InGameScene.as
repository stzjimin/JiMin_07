package puzzle.ingame
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import customize.PopupFrame;
	import customize.Progress;
	import customize.Scene;
	import customize.SceneEvent;
	import customize.SceneManager;
	import customize.Sound;
	import customize.SoundManager;
	
	import puzzle.StagePopup;
	import puzzle.ingame.cell.blocks.BlockData;
	import puzzle.ingame.cell.blocks.BlockType;
	import puzzle.ingame.timer.ComboTimer;
	import puzzle.ingame.timer.Timer;
	import puzzle.ingame.util.possibleCheck.CheckEvent;
	import puzzle.item.Items;
	import puzzle.item.fork.Forker;
	import puzzle.loading.DBLoaderEvent;
	import puzzle.loading.Loading;
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.Resources;
	import puzzle.loading.loader.DBLoader;
	import puzzle.shop.Shop;
	import puzzle.user.User;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	public class InGameScene extends Scene
	{	
		private static var _testMapData:String;
		
		private var _stageNumber:uint;
		
		private var _resources:Resources;
		private var _dbLoader:DBLoader;
		
		private var _progress:Progress;
		
		private var _isClear:Boolean;
		
		private var _backGround:Image;
		
		private var _blockCount:TextField;
		private var _possibleCount:TextField;
		private var _scoreTextField:TextField;
		
		private var _score:uint;
		private var _record:Number;
		
		private var _paused:Boolean;
		private var _timer:Timer;
		
		private var _countTime:int;
		private var _comboTimer:ComboTimer;
		private var _items:Items;
		
		private var _playJuggler:Juggler;
		
		private var _field:Field;
		private var _pausePopup:PausePopup;
		private var _pausePopupFrame:PopupFrame;
		private var _pauseButton:Button;
		
		private var _resultPopup:ResultPopup;
		private var _resultPopupFrame:PopupFrame;
		
		private var _stagePopup:StagePopup;
		private var _stagePopupFrame:PopupFrame;
		
		private var _readyTextures:TextureAtlas;
		private var _readyMovie:MovieClip;
		
		private var _shopPopup:Shop;
		private var _shopPopupFrame:PopupFrame;
		
		private var _blockDatas:Vector.<BlockData>;
		
		private var _soundManager:SoundManager;
		
		private var _clickedStageNumber:uint;
		
		public function InGameScene()
		{
			super();
			_paused = true;
		}
		
		protected override function onCreate(event:SceneEvent):void
		{
			Loading.getInstance().showLoading(this);
			_soundManager = new SoundManager;
			_soundManager.isBgmActive = User.getInstance().bgmActive;
			_soundManager.isEffectActive = User.getInstance().soundEffectActive;
			
			_stageNumber = int(this.data);
			_isClear = false;
			
			_resources = new Resources(Resources.SpriteDir, Resources.SoundDir, Resources.ImageDir);
			
			_resources.addSpriteName("IngameSpriteSheet.png");
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
		
		protected override function onStart(event:SceneEvent):void
		{
			//음악 on
			if(_soundManager)
				_soundManager.wakeAll();
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			if(!_paused)
				_playJuggler.advanceTime(event.passedTime);
		}
		
		protected override function onEnded(event:SceneEvent):void
		{
			//음악 off
			if(_soundManager)
				_soundManager.stopAll();
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected override function onDestroy(event:SceneEvent):void
		{
			_timer.removeEventListener(Timer.TIME_OVER, onTimeOver);
			_timer.removeFromParent();
			_timer.destroy();
			_timer = null;
			
			_comboTimer.removeFromParent();
			_comboTimer.destroy();
			_comboTimer = null;
			
			_field.removeEventListener(CheckEvent.CHECKED_COMPLETE, onCompletePossibleCheck);
			_field.removeEventListener(Forker.GET_FORK, onGetFork);
			_field.removeEventListener(Field.PANG, onCompletePang);
			_field.removeFromParent();
			_field.destroy();
			_field = null;
			
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_pauseButton.removeEventListener(Event.TRIGGERED, onClickedSettingButton);
			_pauseButton.removeFromParent();
			_pauseButton.dispose();
			_pauseButton = null;
			
			_pausePopupFrame.removeEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			_pausePopupFrame.removeFromParent();
			_pausePopupFrame.destroy();
			_pausePopupFrame = null;
			
			_pausePopup.removeEventListener(PausePopup.CONTINUE_CLICKED, onClickedContinue);
			_pausePopup.removeEventListener(PausePopup.MENU_CLICKED, onClickedMenu);
			_pausePopup.removeEventListener(PausePopup.RESTART_CLICKED, onClickedRestart);
			_pausePopup.removeFromParent();
			_pausePopup.destroy();
			_pausePopup = null;
			
			_resultPopup.removeEventListener(ResultPopup.CLICKED_BACK, onClickedMenu);
			_resultPopup.removeEventListener(ResultPopup.CLICKED_NEXT, onClickedNext);
			_resultPopup.removeEventListener(ResultPopup.CLICKED_RESTART, onClickedRestart);
			_resultPopup.removeFromParent();
			_resultPopup.destroy();
			_resultPopup = null;
			
			_resultPopupFrame.removeFromParent();
			_resultPopupFrame.destroy();
			_resultPopupFrame = null;
			
			_stagePopupFrame.removeFromParent();
			_stagePopupFrame.destroy();
			_stagePopupFrame = null;
			
			_stagePopup.removeEventListener(StagePopup.CLOSE_CLICK, onClickedCloseButton);
			_stagePopup.removeEventListener(StagePopup.START_CLICK, onClickedStartButton);
			_stagePopup.removeFromParent();
			_stagePopup.destroy();
			_stagePopup = null;
			
			_items.removeEventListener(Items.FORK_CHECK, onCheckedFork);
			_items.removeEventListener(Items.FORK_EMPTY, onEmptyFork);
			_items.removeEventListener(Items.CLICKED_SEARCH, onClickedSearch);
			_items.removeEventListener(Items.CLICKED_SHUFFLE, onClickedShuffle);
			_items.removeFromParent();
			_items.destroy();
			_items = null;
			
			_resources.removeEventListener(LoadingEvent.COMPLETE, onCompleteLoading);
			_resources.removeEventListener(LoadingEvent.FAILED, onFailedLoading);
			_resources.destroy();
			_resources = null;
			
			_soundManager.stopAll();
			_soundManager.destroy();
			_soundManager = null;
			
			super.onDestroy(event);
		}
		
		protected override function onActivate(event:SceneEvent):void
		{
			if(_soundManager)
			{
				_soundManager.wakeAll();
			}
			super.onActivate(event);
		}
		
		protected override function onDeActivate(event:SceneEvent):void
		{
			if(_soundManager)
			{
				_soundManager.stopAll();
			}
			
			if(_pauseButton)
			{
				_pauseButton.dispatchEvent(new Event(Event.TRIGGERED));
			}
			super.onDeActivate(event);
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
			Loading.getInstance().completeLoading();
			
			_soundManager.addSound("MilkOut.mp3", _resources.getSoundFile("MilkOut.mp3"));
			_soundManager.addSound("set.mp3", _resources.getSoundFile("set.mp3"));
			_soundManager.addSound("clear.mp3", _resources.getSoundFile("clear.mp3"));
			_soundManager.addSound("NeverForget.mp3", _resources.getSoundFile("NeverForget.mp3"));
			_soundManager.addSound("fork.mp3", _resources.getSoundFile("fork.mp3"));
			_soundManager.addSound("searchSound.mp3", _resources.getSoundFile("searchSound.mp3"));
			_soundManager.addSound("shuffleSound2.mp3", _resources.getSoundFile("shuffleSound2.mp3"));
			_soundManager.play("MilkOut.mp3", Sound.INFINITE);

			_score = 0;
			
			_backGround = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "IngameBackGround"));
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
			
			_scoreTextField = new TextField(70, 30);
			_scoreTextField.alignPivot();
			_scoreTextField.x = _backGround.width / 2;
			_scoreTextField.y = 75;
			_scoreTextField.text = "0";
			_scoreTextField.format.bold = true;
			_scoreTextField.format.size = 20;
			_scoreTextField.format.color = Color.RED;
			addChild(_scoreTextField);
			
			_timer = new Timer(_resources);
			_timer.init(70, 10, 450, 50);
			_timer.addEventListener(Timer.TIME_OVER, onTimeOver);
			addChild(_timer);
			
			_comboTimer = new ComboTimer(_resources);
			_comboTimer.init(520, 65, 100, 30, 3);
			addChild(_comboTimer);
			
			_items = new Items(_resources);
			_items.init(280, 70);
			_items.x = 300;
			_items.y = 950;
			_items.addEventListener(Items.FORK_CHECK, onCheckedFork);
			_items.addEventListener(Items.FORK_EMPTY, onEmptyFork);
			_items.addEventListener(Items.CLICKED_SEARCH, onClickedSearch);
			_items.addEventListener(Items.CLICKED_SHUFFLE, onClickedShuffle);
			addChild(_items);
			
			_blockDatas = new Vector.<BlockData>();
			if(_stageNumber == 0)
			{
				trace(_testMapData);
				var mapData:Object = JSON.parse(_testMapData);
				_countTime = mapData.countTime;
				trace(_countTime);
				_timer.startCount(_countTime);
				var blockDatas:Object = mapData.blockData;
				for(var i:int = 0; i < blockDatas.length; i++)
					_blockDatas.push(new BlockData(blockDatas[i].row, blockDatas[i].column, blockDatas[i].type));
			}
			else
			{
				
			}
//			_blockDatas.push(new BlockData(0, 0, BlockType.BLUE));
//			_blockDatas.push(new BlockData(11, 11, BlockType.BLUE));
//			_blockDatas.push(new BlockData(1, 8, BlockType.BLUE));
//			_blockDatas.push(new BlockData(1, 1, BlockType.MICKY));
//			_blockDatas.push(new BlockData(2, 1, BlockType.MICKY));
//			_blockDatas.push(new BlockData(6, 6, BlockType.MICKY));
//			_blockDatas.push(new BlockData(2, 2, BlockType.PINKY));
//			_blockDatas.push(new BlockData(4, 3, BlockType.PINKY));
//			_blockDatas.push(new BlockData(6, 4, BlockType.MICKY));
//			_blockDatas.push(new BlockData(2, 5, BlockType.BLUE));
//			_blockDatas.push(new BlockData(1, 4, BlockType.MICKY));
//			_blockDatas.push(new BlockData(1, 5, BlockType.MICKY));
//			_blockDatas.push(new BlockData(1, 2, BlockType.BLUE));
//			_blockDatas.push(new BlockData(5, 1, BlockType.BLUE));
//			_blockDatas.push(new BlockData(4, 2, BlockType.PINKY));
//			_blockDatas.push(new BlockData(3, 6, BlockType.PINKY));
//			_blockDatas.push(new BlockData(10, 10, BlockType.MONGYI));
//			_blockDatas.push(new BlockData(10, 3, BlockType.MONGYI));
//			_blockDatas.push(new BlockData(7, 10, BlockType.LUCY));
//			_blockDatas.push(new BlockData(10, 5, BlockType.LUCY));
//			_blockDatas.push(new BlockData(10, 5, BlockType.LUCY));
//			_blockDatas.push(new BlockData(10, 1, BlockType.LUCY));
//			_blockDatas.push(new BlockData(10, 2, BlockType.LUCY));
//			_blockDatas.push(new BlockData(10, 8, BlockType.LUCY));
//			_blockDatas.push(new BlockData(8, 5, BlockType.LUCY));
//			_blockDatas.push(new BlockData(3, 5, BlockType.LUCY));
//			_blockDatas.push(new BlockData(10, 9, BlockType.LUCY));
//			_blockDatas.push(new BlockData(9, 3, BlockType.LUCY));
//			_blockDatas.push(new BlockData(7, 5, BlockType.LUCY));
			
			_field = new Field(_resources);
			//			_field.x = 18;
			_field.y = 100;
			_field.init();
			_field.addEventListener(CheckEvent.CHECKED_COMPLETE, onCompletePossibleCheck);
			_field.addEventListener(Forker.GET_FORK, onGetFork);
			_field.addEventListener(Field.PANG, onCompletePang);
			addChild(_field);
			
			_pauseButton = new Button(_resources.getSubTexture("IngameSpriteSheet.png", "popUpButton"));
			_pauseButton.x = 536;
			_pauseButton.width = 40;
			_pauseButton.height = 40;
			_pauseButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_pauseButton);
			
			_pausePopup = new PausePopup(_resources);
			_pausePopup.init(400, 300);
			_pausePopup.addEventListener(PausePopup.CONTINUE_CLICKED, onClickedContinue);
			_pausePopup.addEventListener(PausePopup.MENU_CLICKED, onClickedMenu);
			_pausePopup.addEventListener(PausePopup.RESTART_CLICKED, onClickedRestart);
			
			_pausePopupFrame = new PopupFrame(576, 1024);
			_pausePopupFrame.setContent(_pausePopup);
			_pausePopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_pausePopupFrame);
			
			_resultPopup = new ResultPopup(_resources);
			_resultPopup.init(500, 700);
			_resultPopup.addEventListener(ResultPopup.CLICKED_BACK, onClickedMenu);
			_resultPopup.addEventListener(ResultPopup.CLICKED_NEXT, onClickedNext);
			_resultPopup.addEventListener(ResultPopup.CLICKED_RESTART, onClickedRestart);
			
			_resultPopupFrame = new PopupFrame(576, 1024);
			_resultPopupFrame.setContent(_resultPopup);
			addChild(_resultPopupFrame);
			
			_stagePopup = new StagePopup(_resources);
			_stagePopup.addEventListener(StagePopup.CLOSE_CLICK, onClickedCloseButton);
			_stagePopup.addEventListener(StagePopup.START_CLICK, onClickedStartButton);
			_stagePopup.init(400, 500);
			
			_stagePopupFrame = new PopupFrame(576, 1024);
			_stagePopupFrame.setContent(_stagePopup);
//			_stagePopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_stagePopupFrame);
			
			_shopPopup = new Shop(_resources);
			_shopPopup.init(400, 600);
			_shopPopup.addEventListener(Shop.CLICKED_BUY, onClickedShopBuy);
			_shopPopup.addEventListener(Shop.CLICKED_CLOSE, onClickedShopClose);
			
			_shopPopupFrame = new PopupFrame(576, 1024);
			_shopPopupFrame.setContent(_shopPopup);
			_shopPopupFrame.addEventListener(PopupFrame.COVER_CLICKED, onClickedCover);
			addChild(_shopPopupFrame)
			
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
			
			_readyTextures = _resources.getSpriteSheet("readyClip.png");
			_readyMovie = new MovieClip(_readyTextures.getTextures("ready_"), 10);
			_readyMovie.width = 300;
			_readyMovie.height = 500;
			_readyMovie.alignPivot();
			_readyMovie.x = _backGround.width / 2;
			_readyMovie.y = _backGround.height / 2;
			
			readyTime();
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
//			trace(flash.display.Screen.mainScreen.bounds);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				if(_stagePopupFrame.visible)
					return;
				if(_resultPopupFrame.visible)
					return;
				
				if(!_paused)
				{
					if(_shopPopupFrame.visible)
						keepPlay();
					else
					{
						_paused = true;
						_pausePopupFrame.show();
					}
				}
				else
					keepPlay();
			}
		}
		
		private function readyTime():void
		{
			this.touchable = false;
			addChild(_readyMovie);
			Starling.juggler.add(_readyMovie);
			Starling.juggler.delayCall(goTime, 1.5);
		}
		
		private function goTime():void
		{
			Starling.juggler.remove(_readyMovie);
			_readyMovie.removeFromParent();
			_paused = false;
			this.touchable = true;
		}
		
		private function updateScore():void
		{
			_scoreTextField.text = _score.toString();
		}
		
		private function onCombo():void
		{
			trace("현제 콤보 : " + _comboTimer.comboCount);
			_timer.addTime(0.5);
			_score += (100 * int(_comboTimer.comboCount));
		}
		
		private function onCompletePang(event:Event):void
		{
			_soundManager.play("set.mp3");
			pang();
		}
		
		private function pang():void
		{
			var combo:Boolean;
			_score += 100;
			
			combo = _comboTimer.checkCombo();
			if(combo)
				onCombo();
			
			updateScore();
			_field.checkPossibleCell();
		}
		
		private function onCompletePossibleCheck(event:CheckEvent):void
		{
			_blockCount.text = event.blockCount.toString();
			_possibleCount.text = event.possibleCount.toString();
			
			if(event.blockCount == 0 && event.possibleCount == 0)
			{
				trace("클리어");
				trace(User.getInstance().clearstage);
				trace(_stageNumber);
				_isClear = true;
				
				_record = _timer.getRecord();
				_score += int(_record * 100);
				
				_playJuggler.remove(_timer);
				_playJuggler.remove(_comboTimer);
				
				if(User.getInstance().clearstage < _stageNumber)
					User.getInstance().clearstage = _stageNumber;
//				User.getInstance().heart = 1;
				
				User.getInstance().pullUserData(setScoreData);
			}
		}
		
		private function setScoreData():void
		{
			trace("setScoreData");
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteSetScore);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedSetScore);
			
			_dbLoader.setScoreData(_stageNumber, _score);
		}
		
		private function onCompleteSetScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteSetScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedSetScore);
			_dbLoader.destroy();
			
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			
			_dbLoader.selectScoreData(_stageNumber);
		}
		
		private function onFailedSetScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteSetScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedSetScore);
			_dbLoader.destroy();
			
			trace(event.message);
		}
		
		private function onCompleteLoadingScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			_dbLoader.destroy();
			
			var result:String = event.message;
			var jsonObject:Object = JSON.parse(result);
			
			trace("jsonLength = " + jsonObject.length);
			
			if(_isClear)
			{
				_resultPopup.setTitleMessage("성공!!");
				_resultPopup.setScore(_score);
				_resultPopup.setRecord(_record.toFixed(_record < 100 ? 1 : 0));
			}
			else
			{
				_resultPopup.setTitleMessage("실패");
				_resultPopup.setScore(0);
				_resultPopup.setRecord("0");
				_soundManager.play("NeverForget.mp3", Sound.INFINITE);
			}
			
			_resultPopup.setRanking(jsonObject);
			
			_resultPopupFrame.show();
		}
		
		private function onFailedLoadingScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			_dbLoader.destroy();
			
			trace(event.message);
		}
		
		private function outThisGame():void
		{
			User.getInstance().pullUserData();
			SceneManager.current.outScene(_stageNumber);
		}
		
		private function onGetFork(event:Event):void
		{
			User.getInstance().fork -= 1;
			_items.setEmptyFork();
			_soundManager.play("fork.mp3");
			pang();
		}
		
		private function onCheckedFork(event:Event):void
		{
			trace("forkCheck");
			if(User.getInstance().fork <= 0)
			{
				_items.setEmptyFork();
				_paused = true;
				_shopPopup.setItem(event.data as String);
				_shopPopupFrame.show();
				return;
			}
			_field.forkChecked();
		}
		
		private function onEmptyFork(event:Event):void
		{
			trace("forkEmpty");
			_field.forkEmptyed();
		}
		
		private function onClickedSearch(event:Event):void
		{
			trace("search");
			if(User.getInstance().search <= 0)
			{
				_paused = true;
				_shopPopup.setItem(event.data as String);
				_shopPopupFrame.show();
				return;
			}
			User.getInstance().search -= 1;
			_soundManager.play("searchSound.mp3");
			_field.search();
			
		}
		
		private function onClickedShuffle(event:Event):void
		{
			trace("shuffle");
			if(User.getInstance().shuffle <= 0)
			{
				_paused = true;
				_shopPopup.setItem(event.data as String);
				_shopPopupFrame.show();
				return;
			}
			User.getInstance().shuffle -= 1;
			_soundManager.play("shuffleSound2.mp3");
			_field.shuffle();
		}
		
		private function keepPlay():void
		{
			_paused = false;
			_pausePopupFrame.hide();
			_resultPopupFrame.hide();
			_shopPopupFrame.hide();
		}
		
		private function onClickedContinue(event:Event):void
		{
			keepPlay();
		}
		
		private function onClickedMenu(event:Event):void
		{
			outThisGame();
		}
		
		private function onClickedRestart(event:Event):void
		{	
			_resultPopupFrame.hide();
			
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingStageScore);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedLoadingStageScore);
			
			_dbLoader.selectScoreData(_stageNumber); 
 			_clickedStageNumber = _stageNumber;
		}
		
		private function onClickedNext(event:Event):void
		{
			_resultPopupFrame.hide();
			
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingStageScore);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedLoadingStageScore);
			
			_dbLoader.selectScoreData(_stageNumber+1);
			_clickedStageNumber = _stageNumber+1;
		}
		
		private function onCompleteLoadingStageScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingStageScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedLoadingStageScore);
			_dbLoader.destroy();
			
			var result:String = event.message;
			var jsonObject:Object = JSON.parse(result);
			
			_stagePopup.setTitleMessage(_clickedStageNumber.toString());
			_stagePopup.setLanking(jsonObject);
			_stagePopupFrame.show();
		}
		
		private function onFailedLoadingStageScore(event:DBLoaderEvent):void
		{
			_dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingStageScore);
			_dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedLoadingStageScore);
			_dbLoader.destroy();
			
			trace(event.message);
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			_stagePopupFrame.hide();
			outThisGame();
		}
		
		private function onClickedStartButton(event:Event):void
		{
			_stagePopupFrame.hide();
			outThisGame();	
			if(User.getInstance().heart <= 0)
				return;
			User.getInstance().heart -= 1;
			SceneManager.current.addScene(InGameScene, "game");
			SceneManager.current.goScene("game", _clickedStageNumber);
		}
		
		private function onClickedShopBuy(event:Event):void
		{
			keepPlay();
			User.getInstance().pullUserData();
		}
		
		private function onClickedShopClose(event:Event):void
		{
			keepPlay();
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
			
			_dbLoader = new DBLoader(User.getInstance());
			_dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteLoadingScore);
			_dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedLoadingScore);
			
			_dbLoader.selectScoreData(_stageNumber);
		}
		
		private function onClickedSettingButton(event:Event):void
		{
			_paused = !_paused;
			if(_paused)
			{
				_pausePopupFrame.show();
			}
			else
			{
				_pausePopupFrame.hide();
			}
		}

		public static function get testMapData():String
		{
			return _testMapData;
		}

		public static function set testMapData(value:String):void
		{
			_testMapData = value;
		}

	}
}