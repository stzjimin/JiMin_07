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
	import flash.utils.Dictionary;
	
	import puzzle.item.ItemType;
	import puzzle.loading.DBLoaderEvent;
	import puzzle.loading.loader.DBLoader;
	
	import starling.events.EventDispatcher;

	public class User extends EventDispatcher
	{
		public static const PULL_COMPLETE:String = "pullUserData";
		private static const HEART_TIME:int = 300;
		private static const MAX_HEART_NUM:int = 5;
		
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
		
		private var _attendCount:uint;

		private var _heartTimer:HeartTimer;
		private var _notification:NotificationExtension;
		
		public function User()
		{
			if (!_instance)
			{
				_instance = this;
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onClose);
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, onClose);
				_bgmActive = true;
				_soundEffectActive = true;
				_isLoaded = false;
				_heart = 5;
				_heartTime = 0;
				_notification = new NotificationExtension();
			}
			else
			{
				throw new IllegalOperationError("User가 이미 만들어져있습니다. User는 싱글톤 클래스에요!!");
			}
		}
		
		public function destroy():void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, onClose);
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onClose);
			_heartTimer.destroy();
			_heartTimer = null;
			
			_instance = null;
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

			var setString:String = "clearstage="+_clearstage+",fork="+_fork+",search="+_search+",shuffle="+_shuffle+",heart="+_heart+",hearttime="+_heartTime+",attend="+_attendCount;
			
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
			
			if(versSecond >= (HEART_TIME * MAX_HEART_NUM))
			{
				if(_heart < MAX_HEART_NUM)
					_heart = MAX_HEART_NUM;
			}
			else
			{
				heartCount = uint(versSecond / HEART_TIME);
				_heartTime = uint(versSecond % HEART_TIME);
				
				if((_heart + heartCount) > MAX_HEART_NUM)
					_heart = MAX_HEART_NUM;
				else
					_heart += heartCount;
			}
			
			trace("_heartTime = " + _heartTime);
			
			_heartTimer = new HeartTimer(100, 100);
			_heartTimer.init(HEART_TIME);
		}
		
		public function setNoti(title:String, message:String, second:int):void
		{	
			_notification.setNotification(title, message, second);
		}
		
		public function removeNoti():void
		{
			_notification.removeNotification();
		}
		
		public function logout():void
		{
			switch(_userType)
			{
				case UserType.Facebook :
					FBExtension.getInstance().logout();
					break;
			}
			this.destroy();
		}
		
		public function getFriends():Dictionary
		{
			var result:Dictionary = null;
			switch(_userType)
			{
				case UserType.Facebook :
					result = FacebookUser.getInstance().friends;
					break;
			}
			return result;
		}
		
		public function addItem(itemType:String, value:int):void
		{
			switch(itemType)
			{
				case ItemType.FORK :
					fork += value;
					break;
				case ItemType.SEARCH :
					search += value;
					break;
				case ItemType.SHUFFLE :
					shuffle += value;
					break;
				case ItemType.HEART :
					heart += value;
					break;
			}
		}
		
//		private function onExit(event:Event):void
//		{
//			saveUserState();
//			pullUserData();
//			
//			var second:int = (1500 - (_heart * 300) - (_heartTime));
//			if(second > 0)
//				setNoti("사천성", "하트가 꽉 찼어요!!", second);
//		}
//		
//		private function onDeActivate(event:Event):void
//		{
//			saveUserState();
//			pullUserData();
//			
//			var second:int = (1500 - (_heart * 300) - (_heartTime));
//			if(second > 0)
//				setNoti("사천성", "하트가 꽉 찼어요!!", second);
//		}
		
		private function onClose(event:Event):void
		{
			saveUserState();
			pullUserData();
			
			var second:int = ((HEART_TIME * (MAX_HEART_NUM-1)) - (_heart * HEART_TIME) + (_heartTime));
			if(second > 0)
				setNoti("사천성", "하트가 꽉 찼어요!!", second);
		}
		
		private function onActivate(event:Event):void
		{
			removeNoti();
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

		public function get attendCount():uint
		{
			return _attendCount;
		}

		public function set attendCount(value:uint):void
		{
			_attendCount = value;
		}


	}
}