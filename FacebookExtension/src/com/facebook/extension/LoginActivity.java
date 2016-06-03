package com.facebook.extension;

import java.util.Arrays;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphRequest.GraphJSONObjectCallback;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

public class LoginActivity extends Activity {

	private CallbackManager callbackManager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		FacebookSdk.sdkInitialize(getApplicationContext());
		callbackManager = CallbackManager.Factory.create();

		LoginManager.getInstance().logInWithReadPermissions(LoginActivity.this, Arrays.asList("public_profile", "email", "user_friends"));
		LoginManager.getInstance().registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
			@Override
			public void onSuccess(final LoginResult result) {
				GraphRequest request = GraphRequest.newMeRequest(result.getAccessToken(),
						new GraphJSONObjectCallback() {

							@Override
							public void onCompleted(JSONObject object, GraphResponse response) {
								if (response.getError() != null) 
								{

								} 
								else 
								{
									Log.d("debug", "user: " + object.toString());
									Log.d("debug", "AccessToken: " + result.getAccessToken().toString());
									ExtensionContext.currentToken = result.getAccessToken();
									setResult(RESULT_OK);
//									AccessToken token = AccessToken.createFromJSONObject(jsonObject)
									
									JSONObject tokenJson = null;
									try {
										tokenJson = result.getAccessToken().toJSONObject();
									} catch (JSONException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									String tokenString = tokenJson.toString();
									if(tokenJson == null || tokenString == null)
										Log.d("debug", "ÅäÅ« ±ØÇø");
									
									FacebookExtension.context.dispatchStatusEventAsync("LOGIN_SUCCESS-THROW_USER", object.toString());
									FacebookExtension.context.dispatchStatusEventAsync("LOGIN_SUCCESS-THROW_TOKEN", tokenString);
									finish();
								}
							}
						});

				Bundle parameters = new Bundle();
				parameters.putString("fields", "id,name,email,gender,birthday");
				request.setParameters(parameters);
				request.executeAsync();
			}

			@Override
			public void onCancel() {
				finish();
			}

			@Override
			public void onError(FacebookException error) {
				Log.d("debug", "Error: " + error);
				finish();
			}
		});
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) 
	{
		super.onActivityResult(requestCode, resultCode, data);
		Log.d("debug", "onActivityResult");
		callbackManager.onActivityResult(requestCode, resultCode, data);
	}
}