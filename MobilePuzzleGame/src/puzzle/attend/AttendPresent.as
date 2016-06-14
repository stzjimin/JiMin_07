package puzzle.attend
{
	import puzzle.item.ItemType;

	public class AttendPresent
	{	
		private var _attendPresents:Array;
		
		public function AttendPresent()
		{
			_attendPresents = new Array();
			_attendPresents.push(Vector.<String>([ItemType.SEARCH]));
			_attendPresents.push(Vector.<String>([ItemType.FORK]));
			_attendPresents.push(Vector.<String>([ItemType.SHUFFLE]));
			_attendPresents.push(Vector.<String>([ItemType.SEARCH, ItemType.FORK, ItemType.SHUFFLE]));
		}
		
		public function getPresents():Object
		{
			var presentsJson:Object = new Object();
			presentsJson.length = _attendPresents.length;
			
			var jsonObject:Object;
			var present:Vector.<String>;
			for(var i:int = 0; i < _attendPresents.length; i++)
			{
				present = _attendPresents[i];
				trace(present);
				jsonObject = new Object();
				jsonObject.length = present.length;
				for(var j:int = 0; j < present.length; j++)
				{
					jsonObject[j] = present[j];
					trace(jsonObject[j]);
				}
				presentsJson[i] = jsonObject;
			}
			
			trace("presentsJson = " + presentsJson);
			trace("presentsJson[0] = " + presentsJson[0]);
			trace("presentsJson[1] = " + presentsJson[1]);
			return presentsJson;
		}
	}
}