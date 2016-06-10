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
		
		private var _id:String;
		private var _name:String;
		private var _picture:Bitmap;
		
		private var _email:String;
		private var _playdate:String;
		private var _clearstage:uint;
		
		private var _heart:uint;
		private var _fork:uint;
		private var _search:uint;
		private var _shuffle:uint;
		
		private var _bgmActive:Boolean;
		private var _soundEffectActive:Boolean;
		
		public function User()
		{
			if (!_instance)
			{
				_instance = this;
//				Exiter.getInstance().addExitFunction(saveUserState);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeActivate);
			}
			else
			{
				throw new IllegalOperationError("User가 이미 만들어져있습니다. User는 싱글톤 클래스에요!!");
			}
		}
		
		public function setPicture(resultFunction:Function):void
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
				resultFunction();
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
			trace("bb");
			
			var jsonString:String = JSON.stringify(jsonObject);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(UserStateDir.resolvePath("userState.txt"), FileMode.WRITE);
			fileStream.writeUTF(jsonString);
			fileStream.close();
		}
		
		public function pullUserData(resultFunction:Function = null):void
		{
			var dbLoader:DBLoader = new DBLoader(this);
			
			trace("_heart = " + _heart);
			
			var setString:String = "clearstage = " + _clearstage + ",fork = "+_fork+",search = "+_search+",shuffle = "+_shuffle+",heart = "+_heart;
			
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

		public function get playdate():String
		{
			return _playdate;
		}

		public function set playdate(value:String):void
		{
			_playdate = value;
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

		public function set heart(value:uint):void
		{
			_heart = value;
		}

		public function get fork():uint
		{
			return _fork;
		}

		public function set fork(value:uint):void
		{
			_fork = value;
		}

		public function get search():uint
		{
			return _search;
		}

		public function set search(value:uint):void
		{
			_search = value;
		}

		public function get shuffle():uint
		{
			return _shuffle;
		}

		public function set shuffle(value:uint):void
		{
			_shuffle = value;
		}


	}
}