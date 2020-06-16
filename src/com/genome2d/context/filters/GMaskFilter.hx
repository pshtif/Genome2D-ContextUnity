package com.genome2d.context.filters;

import com.genome2d.textures.GTexture;
import com.genome2d.context.filters.GFilter;
import unityengine.*;
import com.genome2d.geom.GFloat;

class GMaskFilter extends GFilter {

    private var _uRatio:GFloat;
    private var _vRatio:GFloat;

    private var _u1:GFloat;
    private var _v1:GFloat;

    private var _u2:GFloat;
    private var _v2:GFloat;

    public var maskTexture:GTexture;


    public function new(p_uRatio:GFloat = 1, p_vRatio:GFloat = 1, p_u1:GFloat = 0, p_v1:GFloat, p_u2:GFloat, p_v2:GFloat) {

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

        g2d_material.SetVector("_UVRatio", untyped __cs__("new UnityEngine.Vector4({0},{1},0.0f,0.0f)", _uRatio, _vRatio));
        g2d_material.SetVector("_UVS", untyped __cs__("new UnityEngine.Vector4({0},{1},{2},{3})", _u1, _v1, _u2, _v2));
        g2d_material.SetTexture("_MaskTex", maskTexture.nativeTexture);
    }
}