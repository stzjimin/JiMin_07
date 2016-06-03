package com.facebook.extension;

import org.json.JSONException;
import org.json.JSONObject;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.facebook.AccessToken;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;

import android.os.Bundle;
import android.util.Log;

public class ScoreFunction extends BaseFunction
{
	private String tokenString;
	private JSONObject tokenJson;
	private AccessToken token;
	
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		super.call(context, args);
		
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
//		Bundle params = new Bundle();
//		params.putString("score", "3444");
		
//		Bundle params = new Bundle();
//		params.putString("achievement", "1334");
		
		new GraphRequest(
				token,
			    "/"+ FacebookSdk.getApplicationId() + "/scores",
//				"/me/achievements",
				null,
			    HttpMethod.GET,
			    new GraphRequest.Callback() {
			        public void onCompleted(GraphResponse response) {
			            /* handle the result */
			        	Log.d("debug", response.toString());
			        }
			    }
			).executeAsync();
		
		return null;
	}
}
