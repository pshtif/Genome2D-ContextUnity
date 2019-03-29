package com.genome2d.assets;
import com.genome2d.debug.GDebug;
import com.genome2d.macros.MGDebug;
import haxe.io.Bytes;

class GBinaryAsset extends GAsset {

    public var data:Bytes;

    override public function load():Void {

    }

    private function loadedHandler(p_data:String):Void {
        g2d_loaded = true;

        onLoaded.dispatch(this);
    }

    private function errorHandler(p_error:String):Void {
        MGDebug.G2D_ERROR(p_error);
    }
}
