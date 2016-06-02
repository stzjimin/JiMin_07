package Puzzle.ingame.cell
{
	public class NeigborType
	{
		public static const TOP:int = 1;
		public static const LEFT:int = -2;
		public static const RIGHT:int = 2;
		public static const BOTTOM:int = -1;
		
		public function NeigborType()
		{
		}
		
		public static function get TYPES():Vector.<int>
		{
			var types:Vector.<int> = new Vector.<int>();
			types.push(TOP);
			types.push(LEFT);
			types.push(RIGHT);
			types.push(BOTTOM);
			
			return types;
		}
	}
}