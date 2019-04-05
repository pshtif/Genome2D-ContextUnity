/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.assets;

import genome2dnativeplugin.*;
import com.genome2d.assets.GAsset;
import com.genome2d.debug.GDebug;
import haxe.Http;

/**

**/
class GXmlAsset extends GAsset
{
    private var _nativeAsset:GNativeUnityAsset;

    public var xml:Xml;

    override public function load():Void {
        if (!g2d_loaded &&  !g2d_loading && g2d_url != null) {
            g2d_loading = true;
            _nativeAsset = new GNativeUnityAsset(Genome2D.getInstance().getContext().getNativeStage(), g2d_complete_handler);
            _nativeAsset.Load(g2d_url);
        } else {
            GDebug.warning("Asset already loading, was loaded or invalid url specified.");
        }
    }

    private function g2d_complete_handler(p_url:String):Void {
        g2d_loading = false;
        xml = Xml.parse(_nativeAsset.text);
        g2d_loaded = true;
        onLoaded.dispatch(this);
    }

    private function g2d_ioError_handler():Void {

    }
}
