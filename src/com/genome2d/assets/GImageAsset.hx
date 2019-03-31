package com.genome2d.assets;

import unitytestlibrary.*;
import com.genome2d.assets.GAsset;
import com.genome2d.debug.GDebug;

@:nativeGen
class GImageAsset extends GAsset {
    private var _nativeAsset:GNativeUnityAsset;

    private var g2d_type:GImageAssetType;
    #if swc @:extern #end
    public var type(get,never):GImageAssetType;
    #if swc @:getter(type) #end
    inline private function get_type():GImageAssetType {
        return g2d_type;
    }

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
        g2d_loaded = true;
        onLoaded.dispatch(this);
    }

    private function g2d_ioError_handler():Void {

    }
}