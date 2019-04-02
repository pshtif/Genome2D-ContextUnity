package com.pixel;

import com.genome2d.project.GProject;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.macros.MGDebug;
import com.genome2d.debug.GDebug;
import com.genome2d.textures.GTextureManager;
import com.genome2d.assets.GImageAsset;
import com.genome2d.context.GBlendMode;
import com.genome2d.textures.GTexture;

@:nativeGen
class UnityTestProject extends GProject {
	private var _texture:GTexture;

    override private function init():Void {
        GStaticAssetManager.addFromUrl("assets/atlas.png");
		GStaticAssetManager.addFromUrl("assets/atlas.xml");
        GStaticAssetManager.loadQueue(assetsLoaded_handler, assetsFailed_handler);
    }

    private function assetsFailed_handler(p_asset:GAsset):Void {
		MGDebug.ERROR(p_asset.id);
	}

	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		GDebug.info("assetsLoaded");

		GStaticAssetManager.generate();

		_texture = GTextureManager.getTexture("assets/atlas.png_0");
		
		getGenome().onPreRender.add(render_handler);
	}

	private function render_handler():Void {
		getGenome().getContext().draw(_texture, GBlendMode.NONE, 0, 0);
		/*
		for (i in 0...10000) {
			getGenome().getContext().draw(_texture, GBlendMode.NONE, Math.random()*800-400, Math.random()*600-300);
		}
	 	*/
	}
}