package
{
	import starlingOrigin.events.Event;

	public class MapToolLoadingEvent extends Event
	{
		public static const COMPLETE:String = "completeLoading";
		public static const FAILED:String = "failedLoading";
		public static const PROGRESS:String = "progressLoading";
		
		public function MapToolLoadingEvent(type:String, data:Object = null)
		{
			super(type, false, data);
		}
	}
}