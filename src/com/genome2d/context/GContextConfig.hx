/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context;

import unityengine.*;
import com.genome2d.geom.GRectangle;

class GContextConfig
{
    public var contextClass:Class<IGContext>;

    public function new(?p_stage:MonoBehaviour, ?p_viewRect:GRectangle = null, ?p_useClientSize:Bool = false) {
		
        //contextClass = GCanvasContext;
    }
}
