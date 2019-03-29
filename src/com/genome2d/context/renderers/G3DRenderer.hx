/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context.renderers;

import com.genome2d.context.GProjectionMatrix;
import com.genome2d.context.IGContext;
import com.genome2d.context.IGRenderer;
import com.genome2d.debug.GDebug;
import com.genome2d.geom.GFloat4;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.textures.GTexture;

class G3DRenderer implements IGRenderer
{
	private var g2d_context:GUnityContext;

	public var modelMatrix:GMatrix3D;
	public var cameraMatrix:GMatrix3D;
	public var projectionMatrix:GProjectionMatrix;
	
	
	public var lightDirection:GFloat4;
	public var lightColor:GFloat4;
    public var ambientColor:GFloat4;
    public var tintColor:GFloat4;
	
	public var texture:GTexture;


	public function getProgram() {
		return null;
	}
	
	public function invalidateGeometry(p_vertices:Array<Float>, p_uvs:Array<Float>, p_indices:Array<UInt>, p_normals:Array<Float>):Void {
		
	}
	
	public function new(p_vertices:Array<Float>, p_uvs:Array<Float>, p_indices:Array<UInt>, p_normals:Array<Float>, p_generatePerspectiveMatrix:Bool = false):Void {
		invalidateGeometry(p_vertices, p_uvs, p_indices, p_normals);
		
		modelMatrix = new GMatrix3D();
		cameraMatrix = new GMatrix3D();
		lightDirection = new GFloat4();
    }

    public function initialize(p_context:GUnityContext):Void {
		g2d_context = p_context;
		
	}

	@:access(com.genome2d.context.GWebGLContext)
    public function bind(p_context:IGContext, p_reinitialize:Int):Void {
		
    }
	
	@:access(com.genome2d.context.GWebGLContext)
	public function draw(p_cull:Int = 0, p_renderType:Int):Void {
		
    }
	
	public function push():Void {
		
	}

    public function clear():Void {

    }
	
	public function dispose():Void {

	}
}