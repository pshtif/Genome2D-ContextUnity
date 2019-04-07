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
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.GSpineComponent;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

@:nativeGen
class SpineExample extends AbstractExample
{
	public var scale:Float = 2;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SPINE EXAMPLE";
		detail = "Spine component enables you to render skeletal animations from Spine software.";

		var spineMaster:GSpineComponent = GNode.createWithComponent(GSpineComponent);

		spineMaster.setup(GStaticAssetManager.getTextAssetById("assets/spine/diggy/diggy.txt").text, GTextureManager.getTexture("diggy"));
		spineMaster.getSpine().addSkeleton("default", GStaticAssetManager.getTextAssetById("assets/spine/diggy/stastny.json").text);
		spineMaster.getSpine().setActiveSkeleton("default");
		spineMaster.getSpine().setAnimation(0, "stastny", true);
		/*
		spineMaster.setup(GStaticAssetManager.getTextAssetById("assets/spine/spineboy/spineboy-old.txt").text, GTextureManager.getTexture("spineboy"));
		spineMaster.getSpine().addSkeleton("default", GStaticAssetManager.getTextAssetById("assets/spine/spineboy/spineboy-old-skeleton.json").text);
		spineMaster.getSpine().setActiveSkeleton("default");
		spineMaster.getSpine().setAnimation(0, "walk", true);
		/**/
		spineMaster.node.setPosition(Math.random()*Screen.width, Math.random()*(Screen.height-100)+100);
		spineMaster.node.setScale(scale,scale);
		getGenome().root.addChild(spineMaster.node);

		for (i in 0...500) {
			var spine:GSpineComponent = GNode.createWithComponent(GSpineComponent);
			spine.autoUpdate = false;
			spine.setupReferenced(spineMaster.getSpine());
			spine.node.setPosition(Math.random()*Screen.width, Math.random()*(Screen.height-50)+50);
			spine.node.setScale(scale,scale);
			getGenome().root.addChild(spine.node);
		}
    }
}