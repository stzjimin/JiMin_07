package
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	import starling.events.EventDispatcher;

	public class FileIOManager extends EventDispatcher
	{
		private var _file:File;
		
		/**
		 *파일입출력과 관련하여 입력경로와 출력경로 설정을 도와주는 클래스입니다. 
		 * 
		 */		
		public function FileIOManager()
		{
			_file = File.documentsDirectory;
		}
		
		public function selectFile(title:String ,fileFilter:FileFilter):void
		{
			_file.addEventListener(Event.SELECT, onClickInputSelectButton);
			_file.browseForOpen(title,[fileFilter]);
			
			function onClickInputSelectButton(event:Event):void
			{
				var fileString:String;
				_file.removeEventListener(Event.SELECT, onClickInputSelectButton);
				var fileStream:FileStream = new FileStream();
				fileStream.open(_file, FileMode.READ);
				fileString = fileStream.readUTF();
				fileStream.close();
				
				dispatchEvent(new FileEvent(FileEvent.LOAD_COMPLETE, fileString));
			}
		}
		
		public function saveFile(title:String, data:String):void
		{
			_file.addEventListener(Event.SELECT, onClickOutputSelectButton);
			_file.browseForSave(title);
			
			function onClickOutputSelectButton(event:Event):void
			{
				_file.removeEventListener(Event.SELECT, onClickOutputSelectButton);
				var fileStream:FileStream = new FileStream();
				_file.nativePath = _file.nativePath+".json";
				fileStream.open(_file, FileMode.WRITE);
				fileStream.writeUTF(data);
				fileStream.close();
			}
		}
	}
}