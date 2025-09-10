/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context;

import com.genome2d.input.GUnityInputType;
import com.genome2d.geom.GRectangle;
import com.genome2d.context.stats.IGStats;
import com.genome2d.project.GProject;

class GContextConfig
{
    public var contextClass:Class<IGContext>;
    public var nativeStage:GProject;
    public var statsClass:Class<IGStats>;
    public var viewRect:GRectangle;
    public var maxBatchSize:Int = 10000;
    public var meshCount:Int = 200;
    public var unityInputType:GUnityInputType = GUnityInputType.OVERRIDABLE;

    public function new(p_stage:GProject, p_viewRect:GRectangle = null) {
        nativeStage = p_stage;
        viewRect = p_viewRect;
        contextClass = GUnityContext;
        statsClass = null;
    }
}