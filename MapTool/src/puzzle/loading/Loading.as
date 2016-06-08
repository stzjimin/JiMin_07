package puzzle.loading
{
	import flash.errors.IllegalOperationError;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class Loading extends DisplayObjectContainer
	{
		private static var _instance:Loading;
		
		private var _backGround:Image;
		
		public function Loading()
		{
			if (!_instance)
			{
				_instance = this;
				super();
			}
			else
			{
				throw new IllegalOperationError("Loading이 이미 만들어져있습니다. Loading은 싱글톤 클래스에요!!");
			}
		}
		
		public static function getInstance():Loading
		{
			return _instance ? _instance : new Loading();
		}
		
		public function init(screenWidth:Number, screenHeight:Number, loadingImage:Texture):void
		{
			_backGround = new Image(loadingImage);
			_backGround.width = screenWidth;
			_backGround.height = screenHeight;
			addChild(_backGround);
		}
	}
}