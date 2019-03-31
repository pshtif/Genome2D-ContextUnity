package com.pixel;

import com.genome2d.project.GProject;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.macros.MGDebug;
import com.genome2d.debug.GDebug;

@:nativeGen
class UnityTestProject extends GProject {
    override private function init():Void {
        GStaticAssetManager.addFromUrl("http://i.imgur.com/oIaHNEG.jpg");
        GStaticAssetManager.loadQueue(assetsLoaded_handler, assetsFailed_handler);
    }

    private function assetsFailed_handler(p_asset:GAsset):Void {
		MGDebug.ERROR(p_asset.id);
	}

	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		//GStaticAssetManager.generate();
        GDebug.info("assetsLoaded");
	}
}