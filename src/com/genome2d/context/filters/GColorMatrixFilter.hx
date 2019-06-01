/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context.filters;

import unityengine.*;
import com.genome2d.textures.GTexture;

class GColorMatrixFilter extends GFilter {

    private var _colorMatrix:Array<Single>;

    public function setMatrix(p_matrix:Array<Single>):Void {
        p_matrix[4] /= 255;
        p_matrix[9] /= 255;
        p_matrix[14] /= 255;
        p_matrix[19] /= 255;
        _colorMatrix = p_matrix;
    }

    public function new() {
        super();

        g2d_material = new Material(Shader.Find("Genome2D/ColorMatrixShader"));
    }

    override public function bind():Void {
        g2d_material.SetFloatArray("_ColorMatrix", cs.Lib.nativeArray(_colorMatrix,false));
    }
}