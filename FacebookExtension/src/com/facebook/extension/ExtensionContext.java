package com.facebook.extension;
import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.facebook.AccessToken;

public class ExtensionContext extends FREContext {
	
	public static AccessToken currentToken;
	
	public ExtensionContext() 
	{
		
	}
	
	@Override
	public void dispose() 
	{
		
	}

	@Override
	public Map<String, FREFunction> getFunctions() 
	{
		Map<String, FREFunction> map = new HashMap<String, FREFunction>();
		map.put("login", new LoginFunction());
		map.put("logout", new LogoutFunction());
		map.put("friends", new LoadFriendsFunction());
		map.put("score", new ScoreFunction());

		return map;
	}
}