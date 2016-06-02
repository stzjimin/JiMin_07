package Puzzle
{
	import starling.display.Button;
	import starling.textures.Texture;

	public class Item extends Button
	{
		public static const FORK:String = "fork";
		public static const SEARCH:String = "search";
		public static const SHUFFLE:String = "shuffle";
		
		private var _type:String;
		
		public function Item(texture:Texture)
		{
			super(texture);
		}
		
		public function init(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			alignPivot();
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
	}
}