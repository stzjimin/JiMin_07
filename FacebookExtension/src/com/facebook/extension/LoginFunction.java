package com.facebook.extension;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import android.content.Intent;
import android.util.Log;

public class LoginFunction extends BaseFunction 
{
	@Override
	public FREObject call(final FREContext context, FREObject[] args) 
	{
		super.call(context, args);
		try
		{
			Intent intent = new Intent(context.getActivity(), LoginActivity.class);
			context.getActivity().startActivity(intent);
		}
		catch (Exception e)
		{
			Log.d("debug", "?? : " + e.getMessage());
		}
		return null;
	}
}