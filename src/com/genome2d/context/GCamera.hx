package com.genome2d.context;

import com.genome2d.context.GProjectionMatrix;
import unityengine.*;

class GCamera 
{
    public var rotation:Float = 0;
    public var scaleX:Float = 1;
    public var scaleY:Float = 1;
    public var x:Float = 0;
    public var y:Float = 0;

    private var _nativeCamera:Camera;

    /**
	 * 	Camera group used against node camera group a node is rendered through this camera if camera.group and nodecameraGroup != 0
	 */
    public var group:Int = 0xFFFFFF;

    /**
	 * 	Viewport x offset, this value should be always within 0 and 1 its based on context main viewport
	 */
    public var normalizedViewX:Float = 0;
    /**
	 * 	Viewport y offset, this value should be always within 0 and 1 it based on context main viewport
	 */
    public var normalizedViewY:Float = 0;
    /**
	 * 	Viewport width, this value should be always within 0 and 1 its based on context main viewport
	 */
    public var normalizedViewWidth:Float = 1;
    /**
	 * 	Viewport height, this value should be always within 0 and 1 its  based on context main viewport
	 */
    public var normalizedViewHeight:Float = 1;

    public var matrix:GProjectionMatrix;

    public function new(p_context:IGContext) {
        matrix = new GProjectionMatrix();

        var gameObject:GameObject = new GameObject("camera");
        _nativeCamera = untyped __cs__("{0}.AddComponent<UnityEngine.Camera>()", gameObject);
        Debug.Log(gameObject.transform);
        Debug.Log(p_context.getNativeStage().gameObject);
        gameObject.transform.parent = p_context.getNativeStage().gameObject.transform;
    }
}