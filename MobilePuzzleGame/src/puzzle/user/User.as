package puzzle.user
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	
	import customize.Exiter;
	
	import puzzle.loading.DBLoaderEvent;
	import puzzle.loading.loader.DBLoader;
	
	import starling.events.EventDispatcher;

	public class User extends EventDispatcher
	{
		public static const PULL_COMPLETE:String = "pullUserData";
		
		private static var _instance:User;
		
		private static const UserStateDir:File = File.applicationStorageDirectory.resolvePath("UserState");
		private var _userType:String;
		
		private var _isLoaded:Boolean;
		
		private var _id:String;
		private var _name:String;
		private var _picture:Bitmap;
		
		private var _email:String;
		private var _playdate:Number;
		private var _clearstage:uint;
		
		private var _heart:uint;
		private var _fork:uint;
		private var _search:uint;
		private var _shuffle:uint;
		
		private var _heartTime:uint;
		private var _dayChanged:Boolean;
		
		private var _bgmActive:Boolean; 
		private var _soundEffectActive:Boolean;

		private var _heartTimer:HeartTimer;
		
		public function User()
		{
			if (!_instance)
			{
				_instance = this;
//				Exiter.getInstance().addExitFunction(saveUserState);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeActivate);
				_bgmActive = true;
				_soundEffectActive = true;
				_isLoaded = false;
				_heart = 5;
				_heartTime = 0;
			}
			else
			{
				throw new IllegalOperationError("User가 이미 만들어져있습니다. User는 싱글톤 클래스에요!!");
			}
		}
		
		public function loadPicture():void
		{
			switch(_userType)
			{
				case UserType.Facebook :
					var pictureURL:URLRequest = new URLRequest("https://graph.facebook.com/"+_id+"/picture");
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedUserImage);
					loader.load(pictureURL);
					break;
			}
			
			function onLoadedUserImage(event:Event):void
			{
				_picture = loader.content as Bitmap;
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadedUserImage);
				dispatchEvent(new UserEvent(UserEvent.LOAD_COMPLETE));
			}
		}
		
		public function loadUserState():void
		{
			if(!UserStateDir.resolvePath("userState.txt").exists)
				return;
			
			var jsonString:String;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(UserStateDir.resolvePath("userState.txt"), FileMode.READ);
			jsonString = fileStream.readUTF();
			fileStream.close();
			
			var jsonObject:Object = JSON.parse(jsonString);
			
			_bgmActive = jsonObject.bgmActive as Boolean;
			_soundEffectActive = jsonObject.soundEffectActive as Boolean;
		}
		
		public function saveUserState():void
		{
			var jsonObject:Object = new Object();
			jsonObject.bgmActive = _bgmActive;
			jsonObject.soundEffectActive = _soundEffectActive;
			
			var jsonString:String = JSON.stringify(jsonObject);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(UserStateDir.resolvePath("userState.txt"), FileMode.WRITE);
			fileStream.writeUTF(jsonString);
			fileStream.close();
		}
		
		public function pullUserData(resultFunction:Function = null):void
		{
			if(!isLoaded)
				return;
			var dbLoader:DBLoader = new DBLoader(this);

			var setString:String = "playdate=" + _playdate + ",clearstage="+_clearstage+",fork="+_fork+",search="+_search+",shuffle="+_shuffle+",heart="+_heart+",hearttime="+_heartTime;
			
			dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteUpdate);
			dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedUpdate);
			dbLoader.updateUserData(setString);
			
			function onCompleteUpdate(event:DBLoaderEvent):void
			{
				trace("onCompleteUpdate in User");
				dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteUpdate);
				dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedUpdate);
				
				if(resultFunction != null)
					resultFunction();
			}
			
			function onFailedUpdate(event:DBLoaderEvent):void
			{
				dbLoader.removeEventListener(DBLoaderEvent.COMPLETE, onCompleteUpdate);
				dbLoader.removeEventListener(DBLoaderEvent.FAILED, onFailedUpdate);
				
				trace("failed = " + event.message);
				
				dbLoader.addEventListener(DBLoaderEvent.COMPLETE, onCompleteUpdate);
				dbLoader.addEventListener(DBLoaderEvent.FAILED, onFailedUpdate);
				dbLoader.updateUserData(setString);
			}
		}
		
		public function calculHeartTime(versSecond:Number):void
		{
			var heartCount:uint;
			
			trace("versSecond = " + versSecond);
			
			if(versSecond >= 1500)
			{
				if(_heart < 5)
					_heart = 5;
			}
			else
			{
				heartCount = uint(versSecond / 300);
				_heartTime = uint(versSecond % 300);
				
				if((_heart + heartCount) > 5)
					_heart = 5;
				else
					_heart += heartCount;
			}
			
			trace("_heartTime = " + _heartTime);
			
			_heartTimer = new HeartTimer(100, 100);
			_heartTimer.init(300);
		}
		
//		public function pushHeart():void
//		{
//			_heart += 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_HEART, UserEvent.PUSH, false, _heart));
//		}
//		
//		public function popHeart():Boolean
//		{
//			if(_heart <= 0)
//				return false;
//			
//			_heart -= 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_HEART, UserEvent.POP, false, _heart));
//			return true;
//		}
//		
//		public function pushFork():void
//		{
//			_fork += 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_FORK, UserEvent.PUSH, false, _fork));
//		}
//		
//		public function popFork():Boolean
//		{
//			if(_fork <= 0)
//				return false;
//			
//			_fork -= 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_FORK, UserEvent.POP, false, _fork));
//			return true;
//		}
//		
//		public function pushShuffle():void
//		{
//			_shuffle += 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_SHUFFLE, UserEvent.PUSH, false, _shuffle));
//		}
//		
//		public function popShuffle():Boolean
//		{
//			if(_shuffle <= 0)
//				return false;
//			
//			_shuffle -= 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_SHUFFLE, UserEvent.POP, false, _shuffle));
//			return true;
//		}
//		
//		public function pushSearch():void
//		{
//			_search += 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_SEARCH, UserEvent.PUSH, false, _search));
//		}
//		
//		public function popSearch():Boolean
//		{
//			if(_search <= 0)
//				return false;
//			
//			_search -= 1;
//			dispatchEvent(new UserEvent(UserEvent.CHANGE_SEARCH, UserEvent.POP, false, _search));
//			return true;
//		}
		
//		public function loadUserItems():void
//		{
//			if(!UserStateDir.resolvePath("userItemChange.txt").exists)
//				return;
//			
//			var jsonString:String;
//			
//			var fileStream:FileStream = new FileStream();
//			fileStream.open(UserStateDir.resolvePath("userItemChange.txt"), FileMode.READ);
//			jsonString = fileStream.readUTF();
//			fileStream.close();
//			
//			UserStateDir.resolvePath("userItemChange.txt").deleteDirectory(true);
//			
//			var jsonObject:Object = JSON.parse(jsonString);
//		}
//		
//		public function saveUserItems():void
//		{
//			var jsonObject:Object = new Object();
//			jsonObject.fork = _fork;
//			jsonObject.search = _search;
//			jsonObject.shuffle = _shuffle;
//			jsonObject.heart = _heart;
//			
//			var jsonString:String = JSON.stringify(jsonObject);
//			
//			var fileStream:FileStream = new FileStream();
//			fileStream.open(UserStateDir.resolvePath("userItemChange.txt"), FileMode.WRITE);
//			fileStream.writeUTF(jsonString);
//			fileStream.close();
//		}
		
		private function onDeActivate(event:Event):void
		{
			saveUserState();
			pullUserData();
		}
		
		public static function getInstance():User
		{
			return _instance ? _instance : new User();
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get userType():String
		{
			return _userType;
		}

		public function set userType(value:String):void
		{
			_userType = value;
		}

		public function get picture():Bitmap
		{
			return _picture;
		}

		public function set picture(value:Bitmap):void
		{
			_picture = value;
		}

		public function get email():String
		{
			return _email;
		}

		public function set email(value:String):void
		{
			_email = value;
		}

		public function get clearstage():uint
		{
			return _clearstage;
		}

		public function set clearstage(value:uint):void
		{
			_clearstage = value;
		}

		public function get bgmActive():Boolean
		{
			return _bgmActive;
		}

		public function set bgmActive(value:Boolean):void
		{
			_bgmActive = value;
		}

		public function get soundEffectActive():Boolean
		{
			return _soundEffectActive;
		}

		public function set soundEffectActive(value:Boolean):void
		{
			_soundEffectActive = value;
		}

		public function get heart():uint
		{
			return _heart;
		}

		public function get fork():uint
		{
			return _fork;
		}

		public function get search():uint
		{
			return _search;
		}

		public function get shuffle():uint
		{
			return _shuffle;
		}

		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}

		public function set isLoaded(value:Boolean):void
		{
			_isLoaded = value;
		}

		public function get playdate():Number
		{
			return _playdate;
		}

		public function set playdate(value:Number):void
		{
			_playdate = value;
		}

		public function set heart(value:uint):void
		{
			_heart = value;
			dispatchEvent(new UserEvent(UserEvent.CHANGE_HEART));
		}

		public function set fork(value:uint):void
		{
			_fork = value;
			dispatchEvent(new UserEvent(UserEvent.CHANGE_FORK));
		}

		public function set search(value:uint):void
		{
			_search = value;
			dispatchEvent(new UserEvent(UserEvent.CHANGE_SEARCH));
		}

		public function set shuffle(value:uint):void
		{
			_shuffle = value;
			dispatchEvent(new UserEvent(UserEvent.CHANGE_SHUFFLE));
		}

		public function get heartTime():uint
		{
			return _heartTime;
		}

		public function set heartTime(value:uint):void
		{
			_heartTime = value;
		}

		public function get dayChanged():Boolean
		{
			return _dayChanged;
		}

		public function set dayChanged(value:Boolean):void
		{
			_dayChanged = value;
		}

		public function get heartTimer():HeartTimer
		{
			return _heartTimer;
		}

		public function set heartTimer(value:HeartTimer):void
		{
			_heartTimer = value;
		}

	}
}