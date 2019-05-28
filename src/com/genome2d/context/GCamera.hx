/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context;

import com.genome2d.context.GProjectionMatrix;
import unityengine.*;
import com.genome2d.debug.GDebug;

class GCamera 
{
    public var rotation:Float = 0;
    public var scaleX:Float = 1;
    public var scaleY:Float = 1;
    public var x:Float = 0;
    public var y:Float = 0;

    static private var _nativeCamera:Camera;
    public function getNativeCamera():Camera {
        return _nativeCamera;
    }

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

        if (_nativeCamera == null) {
            var gameObject:GameObject = p_context.getNativeStage().gameObject;
            _nativeCamera = untyped __cs__("{0}.AddComponent<UnityEngine.Camera>()", gameObject);

            // Clear nothing Genome2D will handle direct GL call
            _nativeCamera.clearFlags = CameraClearFlags.Depth;

            // Disable all this unnecessary default Unity stuff as it will result in multiple passes
            _nativeCamera.allowHDR = false;
            _nativeCamera.allowMSAA = false;
            _nativeCamera.useOcclusionCulling = false;
            _nativeCamera.worldToCameraMatrix = Matrix4x4.identity;

            /* Removed as all this is now handled by Genome2D context overriding the projection matrix directly
            /* All cameras inside Genome2D are now actually rendered through single Unity camera

            var aspectRatio:Float = Screen.height/p_context.getStageViewRect().height;
            _nativeCamera.orthographic = true;
            _nativeCamera.orthographicSize = p_context.getStageViewRect().height/2;
            _nativeCamera.gameObject.transform.position = new Vector3(Screen.width/(2*aspectRatio), p_context.getStageViewRect().height/2,1);
            _nativeCamera.gameObject.transform.Rotate(0,180,180);
            /**/
        }
    }
}