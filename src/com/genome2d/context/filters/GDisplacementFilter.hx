package com.genome2d.context.filters;

import com.genome2d.textures.GTexture;
import com.genome2d.context.filters.GFilter;
import unityengine.*;
import com.genome2d.geom.GFloat;

class GDisplacementFilter extends GFilter {

    private var _scaleX:Float;
    private var _scaleY:Float;

    public var offset:Float = 0;
    public var displacementMap:GTexture;


    public function new(p_scaleX:Float = .1, p_scaleY:Float = .1) {

        super();

        _scaleX = p_scaleX;
        _scaleY = p_scaleY;

        g2d_material = new Material(Shader.Find("Genome2D/DisplacementShader"));
    }

    override public function bind():Void {

        g2d_material.SetFloat("_Offset", offset);
        g2d_material.SetFloat("_ScaleX", _scaleX);
        g2d_material.SetFloat("_ScaleY", _scaleY);
        g2d_material.SetTexture("_DisplacementMap", displacementMap.nativeTexture);
    }
}