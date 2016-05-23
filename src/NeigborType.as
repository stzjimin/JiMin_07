package
{
	public class NeigborType
	{		
		
		public static const TOP:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = -2;
		public static const BOTTOM:int = -1;
		
//		public static const TOP_LEFT:String = "topLeft";
//		public static const TOP_RIGHT:String = "topRight";
//		public static const BOTTOM_LEFT:String = "bottomLeft";
//		public static const BOTTOM_RIGHT:String = "bottomRight";
		
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
			
//			types.push(TOP_LEFT);
//			types.push(TOP_RIGHT);
//			types.push(BOTTOM_LEFT);
//			types.push(BOTTOM_RIGHT);
			
			return types;
		}
	}
}