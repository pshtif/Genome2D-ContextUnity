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

class GDesaturateFilter extends GFilter {

    public function new() {
        super();

        g2d_material = new Material(Shader.Find("Genome2D/DesaturateShader"));
    }
}