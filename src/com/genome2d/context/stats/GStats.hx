/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context.stats;

import unityengine.*;
import genome2dnativeplugin.*;
import com.genome2d.context.IGContext;

/**

**/
class GStats implements IGStats
{
    static public var fps(get,never):Int;
    static public function get_fps():Int {
        return GNativeStats.fps;
    }

    static public var drawCalls(get,set):Int;
    static public function get_drawCalls():Int {
        return GNativeStats.drawCalls;
    }
    static public function set_drawCalls(p_drawCalls:Int):Int {
        return GNativeStats.drawCalls = p_drawCalls;
    }
    static public var nodeCount:Int = 0;
    static public var customStats:Array<String>;

    static public var x:Int = 0;
    static public var y:Int = 0;
    static public var scaleX:Float = 1;
    static public var scaleY:Float = 1;
    static public var visible:Bool = false;

    static private var g2d_nativeStats:GNativeStats;

    public function new(p_stage:MonoBehaviour) {
        g2d_nativeStats = new GNativeStats(p_stage);
    }

    public function render(p_context:IGContext):Void {
        g2d_nativeStats.Update(visible);
    }

    public function clear():Void {
        drawCalls = 0;
    }
}