package
{
	import flash.events.Event;

	public class FacebookEvent extends Event
	{
		public static const USER_LOGGED_IN_SUCCESS_EVENT:String = 'userLoggedInSuccessEvent';
		public static const USER_LOGGED_OUT_SUCCESS_EVENT:String = 'userLoggedOutSuccessEvent'
		public static const USER_LOGGED_IN_FACEBOOK_ERROR_EVENT:String = 'userLoggedInFacebookErrorEvent';
		public static const USER_LOGGED_IN_ERROR_EVENT:String = 'userLoggedInErrorEvent';
		public static const USER_LOGGED_IN_CANCEL_EVENT:String = 'userLoggedInCancelEvent';
		public static const GRAPH_API_SUCCESS_EVENT:String = 'graphApiSuccessEvent';
		public static const INIT:String = "init";
		
		public var message:String;
		
		public function FacebookEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}