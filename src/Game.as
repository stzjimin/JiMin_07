package
{
	import starling.display.DisplayObjectContainer;
	
	public class Game extends DisplayObjectContainer
	{
		private var _field:Field;
		
		public function Game()
		{
			_field = new Field();
			addChild(_field);
//			_field.getCell(5,5).block.removeFromParent();
//			_field.getCell(5,5).block = null;
		}
	}
}