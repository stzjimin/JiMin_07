package com.facebook.extension;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.login.LoginManager;

public class LogoutFunction extends BaseFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// TODO Auto-generated method stub
		super.call(context, args);
		
		LoginManager.getInstance().logOut();
		
		return null; 
	}
}
