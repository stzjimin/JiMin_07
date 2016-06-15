package
{
	import starling.events.Event;

	public class FileEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "fileLoadComplete";
		
		public function FileEvent(type:String, data:Object)
		{
			super(type, false, data);
		}
	}
}