package com.facebook.extension;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.facebook.AccessToken;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;

import android.content.Intent;
import android.util.JsonWriter;
import android.util.Log;

public class LoadFriendsFunction extends BaseFunction
{
	private String tokenString;
	private JSONObject tokenJson;
	private AccessToken token;
	
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		super.call(context, args);
		
		if(FacebookExtension.context.currentToken == null)
			return null;
		
		try {
			tokenString = args[0].getAsString();
			Log.d("debug", "tokenString: " + tokenString);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			tokenJson = new JSONObject(tokenString);
			Log.d("debug", "tokenJson: " + tokenJson.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Log.d("debug", "error: " + e.toString());
		}
		
		try {
			token = AccessToken.createFromJSONObject(tokenJson);
			Log.d("debug", "token: " + token.toString());
			Log.d("debug", "token: " + token.getToken());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Log.d("debug", "error: " + e.toString());
		}
		
		GraphRequest request = GraphRequest.newMyFriendsRequest(
				token, new GraphRequest.GraphJSONArrayCallback() 
					{	
						@Override
						public void onCompleted(JSONArray objects, GraphResponse response) {
							// TODO Auto-generated method stub
							if (response.getError() != null) 
							{
							}
							else
							{
								Log.d("debug", "user: " + objects.toString());
								Log.d("debug", "response: " + response.toString());
								
								int friendsCount = objects.length();
								FacebookExtension.context.dispatchStatusEventAsync("LOAD_FRIENDS", objects.toString());
							}
						}
					}
				);

				request.executeAsync();
		
//		Intent intent = new Intent(FacebookExtension.context.getActivity().getApplicationContext(), LoadFriendsActivity.class);
//		FacebookExtension.context.getActivity().startActivity(intent);
		
		return null;
	}
}
