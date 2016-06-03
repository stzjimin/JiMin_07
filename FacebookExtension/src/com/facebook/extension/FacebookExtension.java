package com.facebook.extension;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class FacebookExtension implements FREExtension {

	public static ExtensionContext context;
	
	@Override
	public FREContext createContext(String arg0) {
		return new ExtensionContext();
	}

	@Override
	public void dispose() {
		
	}

	@Override
	public void initialize() {
		
	}
}