package com.genome2d.assets;

import genome2dnativeplugin.*;
import com.genome2d.debug.GDebug;
import com.genome2d.macros.MGDebug;
import haxe.io.Bytes;

class GBinaryAsset extends GAsset {

    private var _nativeAsset:GNativeUnityAsset;

    public var data:Bytes;

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
        data = Bytes.ofData(_nativeAsset.bytes);

        g2d_loaded = true;
        onLoaded.dispatch(this);
    }

    private function errorHandler(p_error:String):Void {
        MGDebug.G2D_ERROR(p_error);
    }
}
