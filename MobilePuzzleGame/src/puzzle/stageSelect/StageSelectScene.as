package puzzle.stageSelect
{
	import flash.display.Bitmap;
	
	import customize.Scene;
	import customize.SceneManager;
	
	import puzzle.ingame.InGame;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class StageSelectScene extends Scene
	{
		[Embed(source="stageSelectBackGround.png")]
		private const backGroundImage:Class;
		
		[Embed(source="stageButtonImage.png")]
		private const stageButtonImage:Class;
		
		[Embed(source="stageBlockButton.png")]
		private const stageBlockImage:Class;
		
		private var _backGround:Image;
		private var _stageButtons:Vector.<Button>;
		
		public function StageSelectScene()
		{
			_backGround = new Image(Texture.fromBitmap(new backGroundImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			_backGround.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_backGround);
			
			_stageButtons = new Vector.<Button>();
			for(var i:int = 0; i < 5; i++)
			{
				_stageButtons[i] = new Button(Texture.fromBitmap(new stageButtonImage() as Bitmap));
				_stageButtons[i].width = 80;
				_stageButtons[i].height = 80;
				_stageButtons[i].alignPivot();
				_stageButtons[i].text = (i+1).toString();
				_stageButtons[i].textFormat.bold = true;
				_stageButtons[i].textFormat.size = 40;
				_stageButtons[i].name = (i+1).toString();
				_stageButtons[i].addEventListener(Event.TRIGGERED, onClickedStageButton);
				addChild(_stageButtons[i]);
			}
			
			_stageButtons[0].x = 322;
			_stageButtons[0].y = 777;
			
			_stageButtons[1].x = 106;
			_stageButtons[1].y = 637;
			
			_stageButtons[2].x = 394;
			_stageButtons[2].y = 519;
			
			_stageButtons[3].x = 192;
			_stageButtons[3].y = 369;
			
			_stageButtons[4].x = 414;
			_stageButtons[4].y = 224;
		}
		
		public override function destroy():void
		{
			_backGround.removeEventListener(TouchEvent.TOUCH, onTouch);
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			for(var i:int = 0; i < _stageButtons.length; i++)
			{
				_stageButtons[i].removeEventListener(Event.TRIGGERED, onClickedStageButton);
				_stageButtons[i].removeFromParent();
				_stageButtons[i].dispose();
				_stageButtons[i] = null;
			}
			_stageButtons.splice(0, _stageButtons.length);
			_stageButtons = null;
		}
		
		protected override function onStart(event:Event):void
		{
			
		}
		
		protected override function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		protected override function onEnded(event:Event):void
		{
			
		}
		
		private function onClickedStageButton(event:Event):void
		{
			var stageNumber:String = Button(event.currentTarget).name;
			trace(stageNumber);
			SceneManager.current.addScene(InGame, "game");
			SceneManager.current.goScene("game", stageNumber);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_backGround);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.ENDED)
			{
				trace(touch.getLocation(this));
//				SceneManager.current.goScene("game");
			}
		}
	}
}