package puzzle.loader
{
	import starling.events.Event;

	public class LoadingEvent extends Event
	{
		public static const COMPLETE:String = "completeLoading";
		public static const FAILED:String = "failedLoading";
		public static const PROGRESS:String = "progressLoading";
		
		public function LoadingEvent(type:String, data:Object = null)
		{
			super(type, false, data);
		}
	}
}