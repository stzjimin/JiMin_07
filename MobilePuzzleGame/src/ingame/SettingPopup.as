package ingame
{
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class SettingPopup extends Popup
	{	
		[Embed(source="settingPopup.png")]
		private const testPopupImage:Class;
		
		[Embed(source="continue.png")]
		private const continueButtonImage:Class;
		
		[Embed(source="menu.png")]
		private const menuButtonImage:Class;
		
		[Embed(source="restart.png")]
		private const restartButtonImage:Class;
		
		public static const CONTINUE_CLICKED:String = "continueClicked";
		public static const MENU_CLICKED:String = "menuClicked";
		public static const RESTART_CLICKED:String = "restartClicked";
		
		private var _closeButton:Button;
		private var _bgmCheckButton:CheckBox;
		private var _effectCheckButton:CheckBox;
		
		private var _continueButton:Button;
		private var _menuButton:Button;
		private var _restartButton:Button;
		
		private var _profileImage:Image;
		private var _profileText:TextField;

		public function SettingPopup(width:Number, height:Number)
		{
			super(Texture.fromBitmap(new testPopupImage() as Bitmap), width, height);
			
			_continueButton = new Button(Texture.fromBitmap(new continueButtonImage() as Bitmap));
			_continueButton.width = width * 0.8;
			_continueButton.height = height * 0.2;
			_continueButton.alignPivot();
			_continueButton.x = this.width / 2;
			_continueButton.y = (this.height / 2) - (height * 0.25) + (height * 0.08);
			_continueButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_continueButton);
			
			_menuButton = new Button(Texture.fromBitmap(new menuButtonImage() as Bitmap));
			_menuButton.width = width * 0.8;
			_menuButton.height = height * 0.2;
			_menuButton.alignPivot();
			_menuButton.x = this.width/2;
			_menuButton.y = (this.height / 2) + (height * 0.08);
			_menuButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_menuButton);
			
			_restartButton = new Button(Texture.fromBitmap(new restartButtonImage() as Bitmap));
			_restartButton.width = width * 0.8;
			_restartButton.height = height * 0.2;
			_restartButton.alignPivot();
			_restartButton.x = this.width/2;
			_restartButton.y = (this.height / 2) + (height * 0.25) + (height * 0.08);
			_restartButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_restartButton);
		}
		
		public override function destroy():void
		{	
			_bgmCheckButton.destroy();
			_effectCheckButton.destroy();
			
			dispose();
		}
		
		private function onTriggered(event:Event):void
		{
			if(event.currentTarget == _continueButton)
				dispatchEvent(new Event(SettingPopup.CONTINUE_CLICKED));
			else if(event.currentTarget == _menuButton)
				dispatchEvent(new Event(SettingPopup.MENU_CLICKED));
			else if(event.currentTarget == _restartButton)
				dispatchEvent(new Event(SettingPopup.RESTART_CLICKED));
		}
	}
}