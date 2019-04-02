package com.genome2d.assets;

import genome2dnativeplugin.*;
import unityengine.*;
import com.genome2d.assets.GAsset;
import com.genome2d.debug.GDebug;

@:nativeGen
class GImageAsset extends GAsset {
    private var _nativeAsset:GNativeUnityImageAsset;

    public var nativeTexture(get,never):Texture;
    public function get_nativeTexture():Texture {
        return _nativeAsset.texture;
    }

    private var g2d_type:GImageAssetType;
    public var type(default,null):GImageAssetType;

    override public function load():Void {
        if (!g2d_loaded &&  !g2d_loading && g2d_url != null) {
            g2d_loading = true;
            _nativeAsset = new GNativeUnityImageAsset(Genome2D.getInstance().getContext().getNativeStage(), g2d_complete_handler);
            _nativeAsset.Load(g2d_url);
        } else {
            GDebug.warning("Asset already loading, was loaded or invalid url specified.");
        }
    }

    private function g2d_complete_handler(p_url:String):Void {
        type = GImageAssetType.UNITY;

        g2d_loading = false;
        g2d_loaded = true;
        onLoaded.dispatch(this);
    }

    private function g2d_ioError_handler():Void {

    }
}