package com.lpesign
{
	import flash.external.ExtensionContext;

	public class ToastExtension
	{
		private var context:ExtensionContext;
		
		public function ToastExtension()
		{
			try
			{
				context = ExtensionContext.createExtensionContext("com.lpesign.ToastExtension",null);
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function toast(message:String):void
		{
			context.call("toast",message);
		}
	}
}