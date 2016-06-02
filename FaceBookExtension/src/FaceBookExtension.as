package
{
	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.events.InvokeEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;

	public class FaceBookExtension extends EventDispatcher
	{
		private static const FILE_URI:String = "com.example.facebooktest.token.information.file";
		
		private static var _instance:FaceBookExtension;
		
		private var _context:ExtensionContext;
		
		private var _callbacks:Object = {};
		
		private var _accessToken:String;
		private var _expirationTimeStamp:String;
		private var _lastAccessTokenTimeStamp:int;
		
		private var _cacheDir:File;
		
		public function FaceBookExtension()
		{
			if (!_instance)
			{
				if (this.isFacebookSupported)
				{
					_context = ExtensionContext.createExtensionContext("com.example.facebooktest.FaceBookExtension", null);
					NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
					if (_context != null)
					{
						_context.addEventListener(StatusEvent.STATUS, onStatus);
					} else
					{
						trace('[Facebook Error] extCtx is null.');
					}
				}
				_instance = this;
			}
			else
			{
				throw Error( 'This is a singleton, use getInstance, do not call the constructor directly');
			}
		}
		
		public static function getInstance() : FaceBookExtension
		{
			return _instance ? _instance : new FaceBookExtension();
		}
		
		private function getCacheDirectory():File
		{
			if (_cacheDir != null)
			{
				return _cacheDir;
			}
			
			if (Capabilities.manufacturer.indexOf("iOS") > -1)
			{
				var str:String = File.applicationDirectory.nativePath;
				_cacheDir= new File(str +"/\.\./Library/Caches");
			} else
			{
				_cacheDir = File.applicationStorageDirectory;
			}
			
			return _cacheDir;
		}
		
		private function deleteTokenInfo():void
		{
			this._accessToken = null;
			this._expirationTimeStamp = null;
			trace('[Facebook]  delete : '+{}.toString());
			
			var file:File = getCacheDirectory().resolvePath(FILE_URI);
			if (!file.exists) {
				return;
			} else
			{
				file.deleteFile();
			}
		}
		
		private function storeTokenInfo(newAccessToken:String, newExpirationTime:String):void
		{
			this._accessToken = newAccessToken;
			this._expirationTimeStamp = newExpirationTime;
			
			var object:Object = {'access_token': _accessToken, 'expiration_timestamp': _expirationTimeStamp};
			
			//create a file under the application storage folder
			var file:File = getCacheDirectory().resolvePath(FILE_URI);
			
			var fileStream:FileStream = new FileStream(); //create a file stream
			fileStream.open(file, FileMode.WRITE);// and open the file for write
			fileStream.writeObject(object);//write the object to the file
			fileStream.close();
			trace('[Facebook] stored :', _accessToken,', ',_expirationTimeStamp);
			
		}
		
		private function onStatus(event:StatusEvent):void
		{
			trace('[Facebook] status '+event);
			var e:FacebookEvent;
			var today:Date = new Date();
			switch (event.code)
			{
				case 'INIT_FACEBOOK':
					if(event.level == "DONE")
						e = new FacebookEvent(FacebookEvent.INIT);
					break;
				case 'USER_LOGGED_IN':
				case 'ACCESS_TOKEN_REFRESHED':
					e = new FacebookEvent(FacebookEvent.USER_LOGGED_IN_SUCCESS_EVENT);
					var msg:String = event.level;
					var msgArray:Array = msg.split('&');
					this.storeTokenInfo(msgArray[0], msgArray[1]);
					_lastAccessTokenTimeStamp = today.time;
					break;
				case 'USER_LOGGED_OUT':
					e = new FacebookEvent(FacebookEvent.USER_LOGGED_OUT_SUCCESS_EVENT);
					this.deleteTokenInfo();
					_lastAccessTokenTimeStamp = 0;
					break;
				case 'USER_LOG_IN_CANCEL':
					e = new FacebookEvent(FacebookEvent.USER_LOGGED_IN_CANCEL_EVENT);
					break;
				case 'USER_LOG_IN_FB_ERROR':
					e = new FacebookEvent(FacebookEvent.USER_LOGGED_IN_FACEBOOK_ERROR_EVENT);
					e.message = event.level;
					break;
				case 'USER_LOG_IN_ERROR':
					e = new FacebookEvent(FacebookEvent.USER_LOGGED_IN_ERROR_EVENT);
					e.message = event.level;
					break;
				case 'LOGGING':
					trace(event.level);
					break;
				case 'DELETE_INVITE':
					trace("[Facebook] DELETE_INVITE ", event.level);
					break;
				default:
					if (_callbacks.hasOwnProperty(event.code))
					{
						var callback:Function = _callbacks[event.code];
						var data:Object;
						_lastAccessTokenTimeStamp = today.time;
						try {
							data = JSON.parse(event.level);
							if (this._accessToken != null)
							{
								data['accessToken'] = this._accessToken;
							}
						} catch (e:Error)
						{
							trace("[Facebook Error] ERROR ", e);
						}
						if (callback != null)
						{
							callback(data);
						}
						delete _callbacks[event.code];
					}
			}
			if (e != null)
			{
				this.dispatchEvent(e);
			}
		}
		
		private function onInvoke(event:InvokeEvent):void
		{
			trace(event);
			if (event.arguments != null && event.arguments.length > 0)
			{
				if (this.isFacebookSupported)
				{
					_context.call('handleOpenURL', String(event.arguments[0]));
				}
			}
		}
		
		private function loadTokenInfo():void
		{
			trace('[Facebook] load token info');
			var file:File = getCacheDirectory().resolvePath(FILE_URI);
			if (!file.exists) {
				return;
			}
			
			//create a file stream and open it for reading
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var object:Object = fileStream.readObject(); //read the object
			
			if (object != null && object.hasOwnProperty('access_token'))
			{
				this._accessToken = object['access_token'];
				if (object.hasOwnProperty('expiration_timestamp'))
				{
					this._expirationTimeStamp = object['expiration_timestamp'];
				}
				trace('[Facebook] loaded ', this._accessToken, this._expirationTimeStamp);
			}else{
				trace('[Facebook] load : '+object.toString());
			}
		}
		
		private function get isSessionValid():Boolean
		{
			var today:Date = new Date();
			trace('[Facebook] tokenInfo : '+this._accessToken + ' - ' + this._expirationTimeStamp + ' - '+today.time);
			return this._accessToken != null && (this._expirationTimeStamp != null && Number(this._expirationTimeStamp) > today.time);
		}
		
		private static const REFRESH_TOKEN_BARRIER:int = 24 * 60 * 60 * 1000; // access_token has less than 24 hours to live
		
		private function get shouldRefreshSession():Boolean
		{
			var today:Date = new Date();
			return this.isSessionValid && _lastAccessTokenTimeStamp > 0 && today.time - _lastAccessTokenTimeStamp >= REFRESH_TOKEN_BARRIER;
		}
		
		public function get isFacebookSupported():Boolean
		{
			var result:Boolean = Capabilities.manufacturer.indexOf('iOS') > -1 || Capabilities.manufacturer.indexOf('Android') > -1;
			trace("[Facebook] ", result ? 'Facebook is supported' : 'Facebook is not supported');
			return result;
		}
		
		public function init(appId:String):void
		{
//			_context.call("init", appId);
			
			if (this.isFacebookSupported)
			{
				this.loadTokenInfo();
				trace('[Facebook] initializing Facebook Library '+appId+' access '+this._accessToken+' expires '+this._expirationTimeStamp);
//				trace('[Facebook] url suffix', URL_SUFFIX)
				_context.call('init', appId, this._accessToken, this._expirationTimeStamp);
			}
		}
		
		public function extendAccessTokenIfNeeded():void
		{
			if (this.isFacebookSupported)
			{
				if (shouldRefreshSession)
				{
					_context.call('extendAccessTokenIfNeeded');
				}
			}
		}
		
		public function login(permissions:Array):void
		{
			if (this.isFacebookSupported)
			{
				if (!isSessionValid)
				{
					trace('[Facebook] session invalid, calling login');
					_context.call('login', permissions);
				} else
				{
					if (shouldRefreshSession) // expiration time is about to be done
					{
						trace('[Facebook] session needs to be refreshed');
						this.extendAccessTokenIfNeeded();
						
					} else
					{
						trace('[Facebook] session valid');
						this.dispatchEvent(new FacebookEvent(FacebookEvent.USER_LOGGED_IN_SUCCESS_EVENT));
					}
				}
			}
		}
	}
}