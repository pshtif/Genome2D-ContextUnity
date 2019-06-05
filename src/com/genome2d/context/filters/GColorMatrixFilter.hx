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
import com.genome2d.geom.GFloat;

class GColorMatrixFilter extends GFilter {

    private var _colorMatrix:cs.NativeArray<GFloat>;

    public function setMatrix(p_matrix:Array<GFloat>):Void {
        _colorMatrix[0] = p_matrix[0];
        _colorMatrix[1] = p_matrix[1];
        _colorMatrix[2] = p_matrix[2];
        _colorMatrix[3] = p_matrix[3];
        _colorMatrix[4] = p_matrix[4]/255;
        _colorMatrix[5] = p_matrix[5];
        _colorMatrix[6] = p_matrix[6];
        _colorMatrix[7] = p_matrix[7];
        _colorMatrix[8] = p_matrix[8];
        _colorMatrix[9] = p_matrix[9]/255;
        _colorMatrix[10] = p_matrix[10];
        _colorMatrix[11] = p_matrix[11];
        _colorMatrix[12] = p_matrix[12];
        _colorMatrix[13] = p_matrix[13];
        _colorMatrix[14] = p_matrix[14]/255;
        _colorMatrix[15] = p_matrix[15];
        _colorMatrix[16] = p_matrix[16];
        _colorMatrix[17] = p_matrix[17];
        _colorMatrix[18] = p_matrix[18];
        _colorMatrix[19] = p_matrix[19]/255;
    }

    public function new() {
        super();
        _colorMatrix = new cs.NativeArray(20);

        g2d_material = new Material(Shader.Find("Genome2D/ColorMatrixShader"));
    }

    override public function bind():Void {
        g2d_material.SetFloatArray("_ColorMatrix", _colorMatrix);
    }
}