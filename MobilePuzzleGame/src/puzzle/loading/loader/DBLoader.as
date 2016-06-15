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
		public static const SEVER_URL:String = "http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com";
		
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
					trace(_user.playdate);
					urlRequest = new URLRequest(SEVER_URL + "/insertUser.php?id="+_user.id+"&name="+_user.name+"&email="+_user.email);
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
					urlRequest = new URLRequest(SEVER_URL + "/selectUser.php?id="+_user.id);
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
						var setString:String = "";
						
						if(!_user.clearstage || _user.clearstage <= int(jsonObject[0].clearstage))
							_user.clearstage = jsonObject[0].clearstage;
						else
							setString = setString.concat("clearstage=" + _user.clearstage.toString() + ",");
						
						if(jsonObject[0].fork != _user.fork)
							_user.fork = jsonObject[0].fork;
						if(jsonObject[0].search != _user.search)
							_user.search = jsonObject[0].search;
						if(jsonObject[0].shuffle != _user.shuffle)
							_user.shuffle = jsonObject[0].shuffle;
						if(jsonObject[0].heart != _user.heart)
							_user.heart = jsonObject[0].heart;
						if(jsonObject[0].attend != _user.attendCount)
							_user.attendCount = jsonObject[0].attend;
						
						trace("jsonObject[0].updateday = " + jsonObject[0].updateday);
						trace("jsonObject[0].updatehour = " + jsonObject[0].updatehour);
						trace("jsonObject[0].updateminute = " + jsonObject[0].updateminute);
						trace("jsonObject[0].updatesecond = " + jsonObject[0].updatesecond);
						
						var seconds:Number = 0;
						if(Number(jsonObject[0].updateday) >= 1)
						{
							User.getInstance().dayChanged = true;
							seconds += 1500;
						}
						if(Number(jsonObject[0].updatehour) >= 1)
							seconds += 1500;
						if(seconds < 1500)
						{
							seconds += (Number(jsonObject[0].updateminute) * 60);
							seconds += Number(jsonObject[0].updatesecond);
						}
						//						User.getInstance().dayChanged = true;
						_user.calculHeartTime(seconds + int(jsonObject[0].heartTime));
						
						if(setString == "")
							dispatchEvent(new DBLoaderEvent(DBLoaderEvent.COMPLETE));
						else
							updateUserData(setString);
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
		
		public function updateUserData(setString:String):void
		{
			var urlRequest:URLRequest;
			var dbLoader:URLLoader;
			
			if(setString.charAt(setString.length-1) == ',')
				setString = setString.substr(0, setString.length-1);
			
			trace("setString = " + setString);
			
			urlRequest = new URLRequest(SEVER_URL + "/updateUser.php?id=" + _user.id + "&set="+setString);
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
			
			urlRequest = new URLRequest(SEVER_URL + "/selectScore.php?stage="+stageNumber.toString());
			dbLoader = new URLLoader();
			dbLoader.addEventListener(Event.COMPLETE, onCompleteSelectScore);
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
			dbLoader.load(urlRequest);
			
			function onCompleteSelectScore(event:Event):void
			{
				dbLoader.removeEventListener(Event.COMPLETE, onCompleteSelectScore);
				dbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFaildSelectScore);
				
				var result:String = dbLoader.data as String;
				
				var dbEvent:DBLoaderEvent = new DBLoaderEvent(DBLoaderEvent.COMPLETE, result);
				dispatchEvent(dbEvent);
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
			
			urlRequest = new URLRequest(SEVER_URL + "/selectUserScore.php?id="+_user.id+"&stage="+stage.toString());
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
			
			urlRequest = new URLRequest(SEVER_URL + "/insertScore.php?id="+_user.id+"&stage="+stageNumber.toString()+"&score="+score.toString());
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
			
			urlRequest = new URLRequest(SEVER_URL + "/updateScore.php?id="+_user.id+"&stage="+stageNumber.toString()+"&target=score"+"&value="+score.toString());
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
			var urlRequest:URLRequest = new URLRequest(SEVER_URL + "/checkID.php?id="+_user.id);
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