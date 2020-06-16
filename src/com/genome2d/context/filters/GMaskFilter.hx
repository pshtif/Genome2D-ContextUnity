package com.genome2d.context.filters;

import com.genome2d.textures.GTexture;
import com.genome2d.context.filters.GFilter;
import unityengine.*;
import com.genome2d.geom.GFloat;

class GMaskFilter extends GFilter {

    private var _uRatio:Float;
    private var _vRatio:Float;

    private var _u1:Float;
    private var _v1:Float;

    private var _u2:Float;
    private var _v2:Float;

    public var maskTexture:GTexture;


    public function new(p_uRatio:Float = 1, p_vRatio:Float = 1, p_u1:Float = 0, p_v1:Float, p_u2:Float, p_v2:Float) {

        super();

        _uRatio = p_uRatio;
        _vRatio = p_vRatio;

        _u1 = p_u1;
        _v1 = p_v1;

        _u2 = p_u2;
        _v2 = p_v2;

        g2d_material = new Material(Shader.Find("Genome2D/MaskShader"));
    }

    override public function bind():Void {

        g2d_material.SetVector("_UVRatio", untyped __cs__("new Vector4({0},{1},0.0,0.0);", _uRatio, _vRatio));
        g2d_material.SetVector("_UVS", untyped __cs__("new Vector4({0},{1},{2},{3});", _u1, _v1, _u2, _v2));
        g2d_material.SetTexture("_MaskTex", maskTexture.nativeTexture);
    }
}