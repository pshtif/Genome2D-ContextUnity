package com.genome2d.assets;

import com.genome2d.assets.GAsset;

@:nativeGen
class GImageAsset extends GAsset {
    private var g2d_type:GImageAssetType;
    #if swc @:extern #end
    public var type(get,never):GImageAssetType;
    #if swc @:getter(type) #end
    inline private function get_type():GImageAssetType {
        return g2d_type;
    }

}