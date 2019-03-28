import unityengine.*;
import unitytestlibrary.*;

@:nativeGen
class GUnityContext extends MonoBehaviour {

	function Start() {
		Debug.Log('Initialized...');		

		var utils:GNativeUnityContext = new GNativeUnityContext(this);
        utils.AddValues(2, 3);
        Debug.Log("2 + 3 = " + utils.c);
		utils.LoadTexture("http://i.imgur.com/oIaHNEG.jpg");
	}

	function Update () {
        //Debug.Log(GNativeUnityContext.GenerateRandom(0, 100));
    }
}
