/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */

package com.genome2d.geom;

/**/
extern class GMatrix {
    var a:Float;
    var b:Float;
    var c:Float;
    var d:Float;
    var tx:Float;
    var ty:Float;

    function new();

    function copyFrom(p_from:GMatrix):Void;
    function setTo(p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float):Void;
    function identity():Void;
    function concat(p_matrix:GMatrix):Void;
    function invert():GMatrix;
    function scale(p_scaleX:Float, p_scaleY:Float):Void;
    function rotate (p_angle:Float):Void;
    function translate(p_x:Float, p_y:Float):Void;
}
/**
//typedef GMatrix = com.genome2d.geom.GMatrixNative;

abstract GMatrix(GMatrixNative) {
    inline public function new(p_a:Float = 1, p_b:Float = 0, p_c:Float = 0, p_d:Float = 1, p_tx:Float = 0, p_ty:Float = 0) {
        this = new com.genome2d.geom.GMatrixNative(p_a, p_b, p_c, p_d, p_tx, p_ty);
    }

    public var a(get,set):Float;
    inline public function get_a():Float {
        return this.a;
    }
    inline public function set_a(p_a:Float):Float {
        this.a = p_a;
        return p_a;
    }

    public var b(get,set):Float;
    inline public function get_b():Float {
        return this.b;
    }
    inline public function set_b(p_b:Float):Float {
        this.b = p_b;
        return p_b;
    }

    public var c(get,set):Float;
    inline public function get_c():Float {
        return this.c;
    }
    inline public function set_c(p_c:Float):Float {
        this.c = p_c;
        return p_c;
    }

    public var d(get,set):Float;
    inline public function get_d():Float {
        return this.d;
    }
    inline public function set_d(p_d:Float):Float {
        this.d = p_d;
        return p_d;
    }

    public var tx(get,set):Float;
    inline public function get_tx():Float {
        return this.tx;
    }
    inline public function set_tx(p_tx:Float):Float {
        this.tx = p_tx;
        return p_tx;
    }

    public var ty(get,set):Float;
    inline public function get_ty():Float {
        return this.ty;
    }
    inline public function set_ty(p_ty:Float):Float {
        this.ty = p_ty;
        return p_ty;
    }

    inline public function copyFrom(p_from:GMatrix):Void {
        this.copyFrom(cast p_from);
    }

    inline public function setTo(p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float):Void {
        this.setTo(p_a, p_b, p_c, p_d, p_tx, p_ty);
    }

    inline public function identity():Void {
        this.identity();
    }

    inline public function concat(p_matrix:GMatrix):Void {
        this.concat(cast p_matrix);
    }

    inline public function invert():GMatrix {
        return cast this.invert();
    }

    inline public function scale(p_scaleX:Float, p_scaleY:Float):Void {
        this.scale(p_scaleX, p_scaleY);
    }

    inline public function rotate (p_angle:Float):Void { 
        this.rotate(p_angle);
    }

    inline public function translate(p_x:Float, p_y:Float):Void {
        this.translate(p_x, p_y);
    }
}
/*
class GMatrix {
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var d:Float;
    public var tx:Float;
    public var ty:Float;

    public function new(p_a:Float = 1, p_b:Float = 0, p_c:Float = 0, p_d:Float = 1, p_tx:Float = 0, p_ty:Float = 0) {
        a = p_a;
        b = p_b;
        c = p_c;
        d = p_d;
        tx = p_tx;
        ty = p_ty;
    }

    public function copyFrom(p_from:GMatrix):Void {
        a = p_from.a;
        b = p_from.b;
        c = p_from.c;
        d = p_from.d;
        tx = p_from.tx;
        ty = p_from.ty;
    }

    public function setTo(p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float):Void {
        a = p_a;
        b = p_b;
        c = p_c;
        d = p_d;
        tx = p_tx;
        ty = p_ty;
    }

    public function identity():Void {
        a = 1;
        b = 0;
        c = 0;
        d = 1;
        tx = 0;
        ty = 0;
    }

    public function concat(p_matrix:GMatrix):Void {
        var a1:Float = a * p_matrix.a + b * p_matrix.c;
        b = a * p_matrix.b + b * p_matrix.d;
        a = a1;

        var c1:Float = c * p_matrix.a + d * p_matrix.c;
        d = c * p_matrix.b + d * p_matrix.d;

        c = c1;

        var tx1:Float = tx * p_matrix.a + ty * p_matrix.c + p_matrix.tx;
        ty = tx * p_matrix.b + ty * p_matrix.d + p_matrix.ty;
        tx = tx1;
    }

    public function invert():GMatrix {
        var n:Float = a * d - b * c;

        if (n == 0) {
            a = b = c = d = 0;
            tx = -tx;
            ty = -ty;
        } else {
            n = 1/n;
            var a1:Float = d * n;
            d = a * n;
            a = a1;
            b *= -n;
            c *= -n;

            var tx1:Float = - a * tx - c * ty;
            ty = - b * tx - d * ty;
            tx = tx1;
        }

        return this;
    }

    public function scale(p_scaleX:Float, p_scaleY:Float):Void {
        a *= p_scaleX;
        b *= p_scaleY;
        c *= p_scaleX;
        d *= p_scaleY;
        tx *= p_scaleX;
        ty *= p_scaleY;
    }

    public function rotate (p_angle:Float):Void {
        var cos:Float = Math.cos(p_angle);
        var sin:Float = Math.sin(p_angle);

        var a1 = a * cos - b * sin;
        b = a * sin + b * cos;
        a = a1;

        var c1 = c * cos - d * sin;
        d = c * sin + d * cos;
        c = c1;

        var tx1 = tx * cos - ty * sin;
        ty = tx * sin + ty * cos;
        tx = tx1;
    }

    public function translate(p_x:Float, p_y:Float):Void {
        tx += p_x;
        ty += p_y;
    }
}
/**/
