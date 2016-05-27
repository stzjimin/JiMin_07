package
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class Popup extends DisplayObjectContainer
	{
		private var _backGround:Image;
		
		public function Popup(backGroundTexture:Texture, width:Number, height:Number)
		{
			super();
			
			_backGround = new Image(backGroundTexture);
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			this.visible = false;
		}
	}
}