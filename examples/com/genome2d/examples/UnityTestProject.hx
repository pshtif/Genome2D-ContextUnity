/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import unityengine.*;
import com.genome2d.project.GProject;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.macros.MGDebug;
import com.genome2d.debug.GDebug;
import com.genome2d.textures.GTextureManager;
import com.genome2d.assets.GImageAsset;
import com.genome2d.context.GBlendMode;
import com.genome2d.textures.GTexture;
import com.genome2d.context.filters.GFilter;
import com.genome2d.context.filters.GDesaturateFilter;

@:nativeGen
class UnityTestProject extends GProject {
	private var _texture1:GTexture;
	private var _texture2:GTexture;
	private var _filter:GFilter;

    override private function init():Void {
		GStaticAssetManager.addFromUrl("assets/texture.png");
		GStaticAssetManager.addFromUrl("assets/ball.png");
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

		_texture1 = GTextureManager.getTexture("assets/ball.png");
		_texture2 = GTextureManager.getTexture("assets/texture.png");
		
		_filter = new GDesaturateFilter();

		getGenome().onPreRender.add(render_handler);
	}

	private function render_handler():Void {
		//getGenome().getContext().draw(_texture, GBlendMode.NONE, 0, 0);
		
		for (i in 0...30) {
			getGenome().getContext().draw(_texture1, GBlendMode.NORMAL, 40*i, 100, 1, 1, 0, 1, 1, 1, 1, null);
			getGenome().getContext().draw(_texture2, GBlendMode.NORMAL, 40*i, 200, 1, 1, 0, 1, 1, 1, 1, null);
		}
	}
}