package puzzle.loading.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import puzzle.loading.DBLoaderEvent;
	import puzzle.user.User;
	
	import starling.events.EventDispatcher;

	public class DBLoader extends EventDispatcher
	{
		private var _user:User;
		
		public function DBLoader(user:User)
		{
			_user = user;
		}
		
		public function destroy():void
		{
			_user = null;
		}
		
		public function setUserData():void
		{
			checkID(onCompleteCheck);
			
			function onCompleteCheck(result:int):void
			{
				var urlRequest:URLRequest;
				var dbLoader:URLLoader;
				
				if(result == 0)
				{
					urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/insertUser.php?id="+_user.id+"&name="+_user.name+"&email="+_user.email+"&playdate="+_user.playdate);
					dbLoader = new URLLoader();
					dbLoader.addEventListener(Event.COMPLETE, onCompleteInsertUser);
					dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildInsertUser);
					dbLoader.load(urlRequest);
					
					function onCompleteInsertUser(event:Event):void
					{
						dbLoader.removeEventListener(Event.COMPLETE, onCompleteInsertUser);
						dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildInsertUser);
						
						checkID(onCompleteCheck);
//						dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
					}
					
					function onFaildInsertUser(event:IOErrorEvent):void
					{
						dbLoader.removeEventListener(Event.COMPLETE, onCompleteInsertUser);
						dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildInsertUser);
						
						dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
					}
				}
				else
				{
					urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/selectUser.php?id="+_user.id);
					dbLoader = new URLLoader();
					dbLoader.addEventListener(Event.COMPLETE, onCompleteSelectUser);
					dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildSelectUser);
					dbLoader.load(urlRequest);
					
					function onCompleteSelectUser(event:Event):void
					{
						dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectUser);
						dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectUser);
						
						var result:String = dbLoader.data as String;
						var jsonObject:Object = JSON.parse(result);
						trace(jsonObject[0].id);
						trace(jsonObject[0].name);
						trace(jsonObject[0].playdate);
						trace(jsonObject[0].clearstage);
						_user.clearstage = jsonObject[0].clearstage;
						dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
					}
					
					function onFaildSelectUser(event:IOErrorEvent):void
					{
						dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectUser);
						dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectUser);
						
						dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
					}
				}
			}
		}
		
		public function updateUserData(target:String, value:String):void
		{
			var urlRequest:URLRequest;
			var dbLoader:URLLoader;
			
			urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/updateUser.php?id="+_user.id+"&target="+target+"&value="+value);
			dbLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCompleteUpdateUser);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildUpdateUser);
			dbLoader.load(urlRequest);
			
			function onCompleteUpdateUser(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteUpdateUser);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildUpdateUser);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
			}
			
			function onFaildUpdateUser(event:IOErrorEvent):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteUpdateUser);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildUpdateUser);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
			}
		}
		
		public function selectScoreData(stageNumber:uint):void
		{
			var urlRequest:URLRequest;
			var dbLoader:URLLoader;
			
			urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/selectScore.php?stage="+stageNumber.toString());
			dbLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCompleteSelectScore);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
			dbLoader.load(urlRequest);
			
			function onCompleteSelectScore(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
				
				var result:String = dbLoader.data as String;
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE, result));
			}
			
			function onFaildSelectScore(event:IOErrorEvent):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
			}
		}
		
		public function setScoreData(stage:uint, score:uint):void
		{
			checkScore(onCompleteCheck, stage, score);
			
			function onCompleteCheck(result:int):void
			{
				if(result == 0)
					insertScoreData(stage, score);
				else if(result == 1)
					updataScoreData(stage, score);
				else
					dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
			}
		}
		
		private function checkScore(resultFunction:Function, stage:uint, score:uint):void
		{
			var urlRequest:URLRequest;
			var dbLoader:URLLoader;
			
			urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/selectUserScore.php?id="+_user.id+"&stage="+stage.toString());
			dbLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCompleteSelectScore);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
			dbLoader.load(urlRequest);
			
			function onCompleteSelectScore(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
				
				trace(dbLoader.data);
				var result:String = dbLoader.data as String;
				var jsonObject:Object = JSON.parse(result);
				
				if(jsonObject.length == 0)
				{
					resultFunction(0);
					return;
				}
				
				if(int(jsonObject[0].score) < score)
					resultFunction(1);
				else
					resultFunction(-1);
//				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
			}
			
			function onFaildSelectScore(event:IOErrorEvent):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
			}
		}
		
		private function insertScoreData(stageNumber:uint, score:uint):void
		{
			var urlRequest:URLRequest;
			var dbLoader:URLLoader;
			
			urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/insertScore.php?id="+_user.id+"&stage="+stageNumber.toString()+"&score="+score.toString());
			dbLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCompleteInsertScore);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildInsertScore);
			dbLoader.load(urlRequest);
			
			function onCompleteInsertScore(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteInsertScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildInsertScore);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
			}
			
			function onFaildInsertScore(event:IOErrorEvent):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteInsertScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildInsertScore);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
			}
		}
		
		private function updataScoreData(stageNumber:uint, score:uint):void
		{
			var urlRequest:URLRequest;
			var dbLoader:URLLoader;
			
			urlRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/updateScore.php?id="+_user.id+"&stage="+stageNumber.toString()+"&target=score"+"&value="+score.toString());
			dbLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCompleteUpdateScore);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildUpdateScore);
			dbLoader.load(urlRequest);
			
			function onCompleteUpdateScore(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteUpdateScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildUpdateScore);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
			}
			
			function onFaildUpdateScore(event:IOErrorEvent):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteUpdateScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildUpdateScore);
				
				dispatchEvent(new DBLoaderEvent(DBLoaderEvent.FAILED, event.text));
			}
		}
		
		private function checkID(resultFunction:Function):void
		{
			var urlRequest:URLRequest = new URLRequest("http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/checkID.php?id="+_user.id);
			var dbLoader:URLLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCheckUserId);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildCheckUserId);
			dbLoader.load(urlRequest);
			
			function onCheckUserId(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCheckUserId);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildCheckUserId);
				
				var result:int = int(dbLoader.data);
				resultFunction(result);
			}
			
			function onFaildCheckUserId(event:IOErrorEvent):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCheckUserId);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildCheckUserId);
				
				trace(event.text);
			}
		}
	}
}