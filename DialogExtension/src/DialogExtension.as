package
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class DialogExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;
		private var _resultFunc:Function;
		
		public function DialogExtension(target:IEventDispatcher)
		{
			super(target);
			try
			{
				if(!_context)
					_context = ExtensionContext.createExtensionContext("com.dialog.DialogExtension",null);
				if(_context)
				{
					_context.addEventListener(StatusEvent.STATUS, statusHandle);
				}
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function statusHandle(event:StatusEvent):void
		{
			_resultFunc(event.level);
		}
		
		public function showListDialog(list:Array, resultFunc:Function):void
		{
			_resultFunc = resultFunc;
			_context.call("listDialog",list);
		}
		
		public function showAlertDialog(title:String):void
		{
			_context.call("dialog",title);
		}
		
		public function showInputDialog(title:String, resultFunc:Function):void
		{
			_resultFunc = resultFunc;
			_context.call("inputDialog",title);
		}
		
		public function showGallery(resultFunc:Function):void
		{
			_resultFunc = resultFunc;
			_context.call("gallery", "imageSearch");
		}
		
		public function updateGallery(filePath:String):void
		{
			_context.call("galleryUpdate",filePath);
		}
	}
}