package puzzle.ingame.cell
{
	public class NeigborType
	{
		public static const TOP:int = 1;
		public static const LEFT:int = -2;
		public static const RIGHT:int = 2;
		public static const BOTTOM:int = -1;
		
		/**
		 * 각셀의 이웃하는 셀들을 나타낼때 사요하는 타입입니다.
		 * 1 = TOP
		 * -2 = LEFT
		 * 2 = RIGHT
		 * -1 = BOTTOM 
		 * 
		 */		
		public function NeigborType()
		{
		}
		
		/**
		 * 이웃타입을 배열로 받아옵니다. 
		 * @return 
		 * 
		 */		
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