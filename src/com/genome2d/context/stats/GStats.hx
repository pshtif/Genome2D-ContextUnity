/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context.stats;

import com.genome2d.context.IGContext;

/**

**/
class GStats implements IGStats
{
    static public var fps:Int = 0;
    static public var drawCalls:Int = 0;
    static public var nodeCount:Int = 0;
    static public var customStats:Array<String>;

    static public var x:Int = 0;
    static public var y:Int = 0;
    static public var scaleX:Float = 1;
    static public var scaleY:Float = 1;
    static public var visible:Bool = false;

    public function new() {
        
    }

    public function render(p_context:IGContext):Void {
        
    }

    public function clear():Void {
        drawCalls = 0;
    }
}