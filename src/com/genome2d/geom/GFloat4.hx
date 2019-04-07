/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.geom;

class GFloat4 {
    public var x:Float;
    public var y:Float;
    public var z:Float;
	public var w:Float;
	
	public function new(p_x:Float = 0, p_y:Float = 0, p_z:Float = 0, p_w:Float = 0) {
		x = p_x;
		y = p_y;
		z = p_z;
		w = p_w;
	}
}
