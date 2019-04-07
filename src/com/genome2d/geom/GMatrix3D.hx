/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.geom;

import unityengine.*;

class GMatrix3D {
	public var nativeMatrix:Matrix4x4;

	public var determinant (get, never):Float;
	public function get_determinant ():Float {

		return ((nativeMatrix[0] * nativeMatrix[5] - nativeMatrix[4] * nativeMatrix[1]) * (nativeMatrix[10] * nativeMatrix[15] - nativeMatrix[14] * nativeMatrix[11])
		- (nativeMatrix[0] * nativeMatrix[9] - nativeMatrix[8] * nativeMatrix[1]) * (nativeMatrix[6] * nativeMatrix[15] - nativeMatrix[14] * nativeMatrix[7])
		+ (nativeMatrix[0] * nativeMatrix[13] - nativeMatrix[12] * nativeMatrix[1]) * (nativeMatrix[6] * nativeMatrix[11] - nativeMatrix[10] * nativeMatrix[7])
		+ (nativeMatrix[4] * nativeMatrix[9] - nativeMatrix[8] * nativeMatrix[5]) * (nativeMatrix[2] * nativeMatrix[15] - nativeMatrix[14] * nativeMatrix[3])
		- (nativeMatrix[4] * nativeMatrix[13] - nativeMatrix[12] * nativeMatrix[5]) * (nativeMatrix[2] * nativeMatrix[11] - nativeMatrix[10] * nativeMatrix[3])
		+ (nativeMatrix[8] * nativeMatrix[13] - nativeMatrix[12] * nativeMatrix[9]) * (nativeMatrix[2] * nativeMatrix[7] - nativeMatrix[6] * nativeMatrix[3]));
	}

	public var position(get, set):GVector3D;
	public function get_position():GVector3D {
		return new GVector3D(nativeMatrix[12], nativeMatrix[13], nativeMatrix[14]);
	}
	
	public function set_position(p_value:GVector3D):GVector3D {
		nativeMatrix[12] = p_value.x;
		nativeMatrix[13] = p_value.y;
		nativeMatrix[14] = p_value.z;
		return p_value;
	}
	
  public function new(p_raw:Array<Float> = null) {
	  	nativeMatrix = Matrix4x4.identity;
		if (p_raw != null) {
			nativeMatrix[0] = p_raw[0];
			nativeMatrix[1] = p_raw[1];
			nativeMatrix[2] = p_raw[2];
			nativeMatrix[3] = p_raw[3];
			
			nativeMatrix[4] = p_raw[4];
			nativeMatrix[5] = p_raw[5];
			nativeMatrix[6] = p_raw[6];
			nativeMatrix[7] = p_raw[7];
			
			nativeMatrix[8] = p_raw[8];
			nativeMatrix[9] = p_raw[9];
			nativeMatrix[10] = p_raw[10];
			nativeMatrix[11] = p_raw[11];
			
			nativeMatrix[12] = p_raw[12];
			nativeMatrix[13] = p_raw[13];
			nativeMatrix[14] = p_raw[14];
			nativeMatrix[15] = p_raw[15];
		}
	}

  public function append(p_lhs:GMatrix3D):Void {	
		var m111:Float = this.nativeMatrix[0], m121:Float = this.nativeMatrix[4], m131:Float = this.nativeMatrix[8], m141:Float = this.nativeMatrix[12],
			m112:Float = this.nativeMatrix[1], m122:Float = this.nativeMatrix[5], m132:Float = this.nativeMatrix[9], m142:Float = this.nativeMatrix[13],
			m113:Float = this.nativeMatrix[2], m123:Float = this.nativeMatrix[6], m133:Float = this.nativeMatrix[10], m143:Float = this.nativeMatrix[14],
			m114:Float = this.nativeMatrix[3], m124:Float = this.nativeMatrix[7], m134:Float = this.nativeMatrix[11], m144:Float = this.nativeMatrix[15],
			m211:Float = p_lhs.nativeMatrix[0], m221:Float = p_lhs.nativeMatrix[4], m231:Float = p_lhs.nativeMatrix[8], m241:Float = p_lhs.nativeMatrix[12],
			m212:Float = p_lhs.nativeMatrix[1], m222:Float = p_lhs.nativeMatrix[5], m232:Float = p_lhs.nativeMatrix[9], m242:Float = p_lhs.nativeMatrix[13],
			m213:Float = p_lhs.nativeMatrix[2], m223:Float = p_lhs.nativeMatrix[6], m233:Float = p_lhs.nativeMatrix[10], m243:Float = p_lhs.nativeMatrix[14],
			m214:Float = p_lhs.nativeMatrix[3], m224:Float = p_lhs.nativeMatrix[7], m234:Float = p_lhs.nativeMatrix[11], m244:Float = p_lhs.nativeMatrix[15];
		
		nativeMatrix[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
		nativeMatrix[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
		nativeMatrix[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
		nativeMatrix[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
		
		nativeMatrix[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
		nativeMatrix[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
		nativeMatrix[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
		nativeMatrix[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
		
		nativeMatrix[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
		nativeMatrix[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
		nativeMatrix[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
		nativeMatrix[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
		
		nativeMatrix[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
		nativeMatrix[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
		nativeMatrix[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
		nativeMatrix[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;		
	}
	
	public function appendRotation(p_degrees:Float, p_axis:GVector3D, p_pivotPoint:GVector3D = null):Void {	
		var m = g2d_getAxisRotation(p_axis.x, p_axis.y, p_axis.z, p_degrees);
		
		if (p_pivotPoint != null) {
			
			var p = p_pivotPoint;
			m.appendTranslation (p.x, p.y, p.z);
			
		}
		
		this.append (m);	
	}
	
	public function appendScale (p_xScale:Float, p_yScale:Float, p_zScale:Float):Void {	
		this.append (new GMatrix3D ([p_xScale, 0.0, 0.0, 0.0, 0.0, p_yScale, 0.0, 0.0, 0.0, 0.0, p_zScale, 0.0, 0.0, 0.0, 0.0, 1.0]));
	}
	
	
	public function appendTranslation (p_x:Float, p_y:Float, p_z:Float):Void {
		nativeMatrix[12] += p_x;
		nativeMatrix[13] += p_y;
		nativeMatrix[14] += p_z;
	}
	
	public function prepend(p_rhs:GMatrix3D):Void {
		var m111:Float = p_rhs.nativeMatrix[0], m121:Float = p_rhs.nativeMatrix[4], m131:Float = p_rhs.nativeMatrix[8], m141:Float = p_rhs.nativeMatrix[12],
			m112:Float = p_rhs.nativeMatrix[1], m122:Float = p_rhs.nativeMatrix[5], m132:Float = p_rhs.nativeMatrix[9], m142:Float = p_rhs.nativeMatrix[13],
			m113:Float = p_rhs.nativeMatrix[2], m123:Float = p_rhs.nativeMatrix[6], m133:Float = p_rhs.nativeMatrix[10], m143:Float = p_rhs.nativeMatrix[14],
			m114:Float = p_rhs.nativeMatrix[3], m124:Float = p_rhs.nativeMatrix[7], m134:Float = p_rhs.nativeMatrix[11], m144:Float = p_rhs.nativeMatrix[15],
			m211:Float = this.nativeMatrix[0], m221:Float = this.nativeMatrix[4], m231:Float = this.nativeMatrix[8], m241:Float = this.nativeMatrix[12],
			m212:Float = this.nativeMatrix[1], m222:Float = this.nativeMatrix[5], m232:Float = this.nativeMatrix[9], m242:Float = this.nativeMatrix[13],
			m213:Float = this.nativeMatrix[2], m223:Float = this.nativeMatrix[6], m233:Float = this.nativeMatrix[10], m243:Float = this.nativeMatrix[14],
			m214:Float = this.nativeMatrix[3], m224:Float = this.nativeMatrix[7], m234:Float = this.nativeMatrix[11], m244:Float = this.nativeMatrix[15];
		
		nativeMatrix[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
		nativeMatrix[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
		nativeMatrix[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
		nativeMatrix[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
		
		nativeMatrix[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
		nativeMatrix[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
		nativeMatrix[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
		nativeMatrix[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
		
		nativeMatrix[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
		nativeMatrix[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
		nativeMatrix[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
		nativeMatrix[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
		
		nativeMatrix[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
		nativeMatrix[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
		nativeMatrix[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
		nativeMatrix[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
	}
	
	public function prependRotation (p_degrees:Float, p_axis:GVector3D, p_pivotPoint:GVector3D = null):Void {
		var m = g2d_getAxisRotation (p_axis.x, p_axis.y, p_axis.z, p_degrees);
		
		if (p_pivotPoint != null) {
			var p = p_pivotPoint;
			m.appendTranslation (p.x, p.y, p.z);
		}
		
		this.prepend(m);
	}
	
	
	public function prependScale(p_xScale:Float, p_yScale:Float, p_zScale:Float):Void {
		this.prepend (new GMatrix3D ([p_xScale, 0.0, 0.0, 0.0, 0.0, p_yScale, 0.0, 0.0, 0.0, 0.0, p_zScale, 0.0, 0.0, 0.0, 0.0, 1.0]));
	}
	
	
	public function prependTranslation (p_x:Float, p_y:Float, p_z:Float):Void {
		var m = new GMatrix3D ();
		m.position = new GVector3D(p_x, p_y, p_z);
		this.prepend (m);
	}
	
	public function clone():GMatrix3D {
		var newData:Array<Float> = new Array<Float>();
		newData[0] = nativeMatrix[0];
		newData[1] = nativeMatrix[1];
		newData[2] = nativeMatrix[2];
		newData[3] = nativeMatrix[3];
		
		newData[4] = nativeMatrix[4];
		newData[5] = nativeMatrix[5];
		newData[6] = nativeMatrix[6];
		newData[7] = nativeMatrix[7];
		
		newData[8] = nativeMatrix[8];
		newData[9] = nativeMatrix[9];
		newData[10] = nativeMatrix[10];
		newData[11] = nativeMatrix[11];
		
		newData[12] = nativeMatrix[12];
		newData[13] = nativeMatrix[13];
		newData[14] = nativeMatrix[14];
		newData[15] = nativeMatrix[15];
		
		return new GMatrix3D(newData);
	}
	
	public function transpose ():Void {
		var newData:Matrix4x4 = Matrix4x4.zero;
		newData[0] = nativeMatrix[0];
		newData[1] = nativeMatrix[4];
		newData[2] = nativeMatrix[8];
		newData[3] = nativeMatrix[12];
		
		newData[4] = nativeMatrix[1];
		newData[5] = nativeMatrix[5];
		newData[6] = nativeMatrix[9];
		newData[7] = nativeMatrix[13];
		
		newData[8] = nativeMatrix[2];
		newData[9] = nativeMatrix[6];
		newData[10] = nativeMatrix[10];
		newData[11] = nativeMatrix[14];
		
		newData[12] = nativeMatrix[3];
		newData[13] = nativeMatrix[7];
		newData[14] = nativeMatrix[11];
		newData[15] = nativeMatrix[15];
		
		nativeMatrix = newData;
	}

	public function invert():Bool {
		var d = determinant;
		var invertable = Math.abs (d) > 0.00000000001;

		if (invertable) {

			d = 1 / d;

			var m11:Float = nativeMatrix[0]; var m21:Float = nativeMatrix[4]; var m31:Float = nativeMatrix[8]; var m41:Float = nativeMatrix[12];
			var m12:Float = nativeMatrix[1]; var m22:Float = nativeMatrix[5]; var m32:Float = nativeMatrix[9]; var m42:Float = nativeMatrix[13];
			var m13:Float = nativeMatrix[2]; var m23:Float = nativeMatrix[6]; var m33:Float = nativeMatrix[10]; var m43:Float = nativeMatrix[14];
			var m14:Float = nativeMatrix[3]; var m24:Float = nativeMatrix[7]; var m34:Float = nativeMatrix[11]; var m44:Float = nativeMatrix[15];

			nativeMatrix[0] = d * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
			nativeMatrix[1] = -d * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
			nativeMatrix[2] = d * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
			nativeMatrix[3] = -d * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));
			nativeMatrix[4] = -d * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
			nativeMatrix[5] = d * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
			nativeMatrix[6] = -d * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
			nativeMatrix[7] = d * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));
			nativeMatrix[8] = d * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
			nativeMatrix[9] = -d * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
			nativeMatrix[10] = d * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
			nativeMatrix[11] = -d * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));
			nativeMatrix[12] = -d * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
			nativeMatrix[13] = d * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
			nativeMatrix[14] = -d * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
			nativeMatrix[15] = d * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));

		}

		return invertable;
	}
	
	public function identity ():Void {	
		nativeMatrix = Matrix4x4.identity;
	}
	
	static private function g2d_getAxisRotation (p_x:Float, p_y:Float, p_z:Float, p_degrees:Float):GMatrix3D {
		var m = new GMatrix3D();

		var a1 = new GVector3D(p_x, p_y, p_z);
		var rad = -p_degrees * (Math.PI / 180);
		var c = Math.cos (rad);
		var s = Math.sin (rad);
		var t = 1.0 - c;
		
		m.nativeMatrix[0] = c + a1.x * a1.x * t;
		m.nativeMatrix[5] = c + a1.y * a1.y * t;
		m.nativeMatrix[10] = c + a1.z * a1.z * t;
		
		var tmp1 = a1.x * a1.y * t;
		var tmp2 = a1.z * s;
		m.nativeMatrix[4] = tmp1 + tmp2;
		m.nativeMatrix[1] = tmp1 - tmp2;
		tmp1 = a1.x * a1.z * t;
		tmp2 = a1.y * s;
		m.nativeMatrix[8] = tmp1 - tmp2;
		m.nativeMatrix[2] = tmp1 + tmp2;
		tmp1 = a1.y * a1.z * t;
		tmp2 = a1.x*s;
		m.nativeMatrix[9] = tmp1 + tmp2;
		m.nativeMatrix[6] = tmp1 - tmp2;

		return m;
	}

	public function transformVector(p_vector:GVector3D):GVector3D {
		var x = p_vector.x;
		var y = p_vector.y;
		var z = p_vector.z;

		return new GVector3D((x * nativeMatrix[0] + y * nativeMatrix[4] + z * nativeMatrix[8] + nativeMatrix[12]),
							 (x * nativeMatrix[1] + y * nativeMatrix[5] + z * nativeMatrix[9] + nativeMatrix[13]),
							 (x * nativeMatrix[2] + y * nativeMatrix[6] + z * nativeMatrix[10] + nativeMatrix[14]),
							 (x * nativeMatrix[3] + y * nativeMatrix[7] + z * nativeMatrix[11] + nativeMatrix[15]));
	}
}