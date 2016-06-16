package customize
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;

	public class CustomImage extends DisplayObjectContainer
	{
		private var _backGround:Image;
		private var _textField:TextField;
		
		private var _text:String;
		private var _textFormat:TextFormat;
		
		public function CustomImage(texture:Texture, width:Number, height:Number, text:String = "", textFormat:TextFormat = null)
		{
			super();
			
			_text = text;
			_textFormat = textFormat;
			
			_backGround = new Image(texture);
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_textField = new TextField(_backGround.width, _backGround.height, _text, _textFormat);
			addChild(_textField);
		}
		
		public function destroy():void
		{
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_textField.removeFromParent();
			_textField.dispose();
			_textField = null;
			
			dispose();
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			_textField.text = _text;
		}

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
		}


	}
}