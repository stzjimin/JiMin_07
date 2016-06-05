package customize
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;

	public class CheckBox extends Button
	{
		public static const SWAP_EMPTY:String = "swapEmpty";
		public static const SWAP_CHECK:String = "swapCheck";
		
		private var _emptyTexture:Texture;
		private var _checkTexture:Texture;
		
		private var _checked:Boolean;
		
		public function CheckBox(emptyTexture:Texture, checkTexture:Texture)
		{
			_emptyTexture = emptyTexture;
			_checkTexture = checkTexture;
			_checked = false;
			
			addEventListener(Event.TRIGGERED, onTriggered);
			
			super(emptyTexture);
		}
		
		private function onTriggered(event:Event):void
		{
			_checked = !_checked;
			if(_checked)
			{
				super.upState = _checkTexture;
				dispatchEvent(new Event(CheckBox.SWAP_CHECK));
			}
			else
			{
				super.upState = _emptyTexture;
				dispatchEvent(new Event(CheckBox.SWAP_EMPTY));
			}
		}
		
		/**
		 * 외부에서 CheckBox를 Empty상태로 만들기위해서 사용하는 함수입니다. 
		 * 
		 */		
		public function setEmpty():void
		{
			_checked = false;
			super.upState = _emptyTexture;
		}
		
		/**
		 * 외부에서 CheckBox를 Check상태로 만들기위해서 사용하는 함수입니다. 
		 * 
		 */		
		public function setCheck():void
		{
			_checked = true;
			super.upState = _checkTexture;
		}
		
		public function destroy():void
		{
			removeEventListener(Event.TRIGGERED, onTriggered);
			
			dispose();
		}
	}
}