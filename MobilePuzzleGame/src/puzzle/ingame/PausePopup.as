package puzzle.ingame
{
	import puzzle.Popup;
	import puzzle.loader.Resources;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	public class PausePopup extends Popup
	{	
		public static const CONTINUE_CLICKED:String = "continueClicked";
		public static const MENU_CLICKED:String = "menuClicked";
		public static const RESTART_CLICKED:String = "restartClicked";
		
		private var _resources:Resources;
		
		private var _closeButton:Button;
		
		private var _continueButton:Button;
		private var _menuButton:Button;
		private var _restartButton:Button;
		
		private var _profileImage:Image;
		private var _profileText:TextField;

		public function PausePopup(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			super.init(width, height, _resources.getSubTexture("IngameSprite1.png", "settingPopup"));
			
			_continueButton = new Button(_resources.getSubTexture("IngameSprite1.png", "continue"));
			_continueButton.width = width * 0.8;
			_continueButton.height = height * 0.2;
			_continueButton.alignPivot();
			_continueButton.x = this.width / 2;
			_continueButton.y = (this.height / 2) - (height * 0.25) + (height * 0.08);
			_continueButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_continueButton);
			
			_menuButton = new Button(_resources.getSubTexture("IngameSprite1.png", "menu"));
			_menuButton.width = width * 0.8;
			_menuButton.height = height * 0.2;
			_menuButton.alignPivot();
			_menuButton.x = this.width/2;
			_menuButton.y = (this.height / 2) + (height * 0.08);
			_menuButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_menuButton);
			
			_restartButton = new Button(_resources.getSubTexture("IngameSprite1.png", "restart"));
			_restartButton.width = width * 0.8;
			_restartButton.height = height * 0.2;
			_restartButton.alignPivot();
			_restartButton.x = this.width/2;
			_restartButton.y = (this.height / 2) + (height * 0.25) + (height * 0.08);
			_restartButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_restartButton);
			
			_resources = null;
		}
		
		public override function destroy():void
		{	
			_continueButton.removeEventListener(Event.TRIGGERED, onTriggered);
			_menuButton.removeEventListener(Event.TRIGGERED, onTriggered);
			_restartButton.removeEventListener(Event.TRIGGERED, onTriggered);
			
			super.destroy();
		}
		
		private function onTriggered(event:Event):void
		{
			if(event.currentTarget == _continueButton)
				dispatchEvent(new Event(PausePopup.CONTINUE_CLICKED));
			else if(event.currentTarget == _menuButton)
				dispatchEvent(new Event(PausePopup.MENU_CLICKED));
			else if(event.currentTarget == _restartButton)
				dispatchEvent(new Event(PausePopup.RESTART_CLICKED));
		}
	}
}