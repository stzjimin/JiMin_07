package
{
	public class NeigborType
	{		
		
		public static const TOP:String = "top";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		
//		public static const TOP_LEFT:String = "topLeft";
//		public static const TOP_RIGHT:String = "topRight";
//		public static const BOTTOM_LEFT:String = "bottomLeft";
//		public static const BOTTOM_RIGHT:String = "bottomRight";
		
		public function NeigborType()
		{
		}
		
		public static function get TYPES():Vector.<String>
		{
			var types:Vector.<String> = new Vector.<String>();
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