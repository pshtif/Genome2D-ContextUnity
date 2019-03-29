package com.genome2d.context;

import unityengine.*;
import unitytestlibrary.*;

@:nativeGen
class GUnityContext extends MonoBehaviour {

	function Start() {
		Debug.Log('Initialized...');		

		var test:GNativeUnityAsset = new GNativeUnityAsset(this, call);

		//var utils:GNativeUnityContext = new GNativeUnityContext(this);
        //utils.AddValues(2, 3);
        //Debug.Log("2 + 3 = " + utils.c);
		test.Load("http://i.imgur.com/oIaHNEG.jpg");
	}

	function Update () {
        //Debug.Log(GNativeUnityContext.GenerateRandom(0, 100));
    }

	function call(p_url:String) {
		Debug.Log("Fuck "+p_url);
	}
}
