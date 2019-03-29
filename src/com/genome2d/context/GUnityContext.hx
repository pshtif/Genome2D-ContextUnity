package com.genome2d.context;

import unityengine.*;
import unitytestlibrary.*;
import com.genome2d.node.GNode;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.GPrototype;

@:nativeGen
class GUnityContext extends MonoBehaviour {


	@:access(com.genome2d.proto.GPrototypeFactory)
	function Start() {
		Debug.Log('Initialized...');		
		GPrototypeFactory.initializePrototypes();

		var test:GNativeUnityAsset = new GNativeUnityAsset(this, call);

		var node:GNode = new GNode();
		var xml:Xml = GXmlPrototypeParser.toXml(node.getPrototype());
		Debug.Log(xml);
		var prototype:GPrototype = GXmlPrototypeParser.fromXml(xml);
		Debug.Log(prototype.prototypeClass);
		node = GPrototypeFactory.createInstance(prototype,["name"]);
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
