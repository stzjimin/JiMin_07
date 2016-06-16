package
{
	import flash.display.BitmapData;
	import flash.external.ExtensionContext;

	public class NotificationExtension
	{
		private var _context:ExtensionContext;
		private var _resultFunc:Function;
		
		public function NotificationExtension()
		{
			try
			{
				if(!_context)
					_context = ExtensionContext.createExtensionContext("com.push.PushExtension",null);
//				if(_context)
//				{
//					_context.addEventListener(StatusEvent.STATUS, statusHandle);
//				}
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function setNotification(title:String, message:String, time:int):void
		{
//			_resultFunc = resultFunc;
//			var arrayTemp:Array = new Array();
//			arrayTemp.push(title);
//			arrayTemp.push(message);
//			arrayTemp.push(time);
//			arrayTemp.push(image);
			
			_context.call("pushNotification", title, message, time);
		}
		
		public function removeNotification():void
		{
			_context.call("removeNotification",[]);
		}
	}
}