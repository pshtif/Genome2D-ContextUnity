/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.deprecated.components.renderable.particles.GSimpleParticleSystemD;
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.particles.GParticleSystemComponent;
import com.genome2d.examples.AbstractExample;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.textures.GTextureManager;

@:nativeGen
class CameraExample extends AbstractExample
{
		public var camera1:GCameraController;
		public var camera2:GCameraController;
		public var camera3:GCameraController;
		public var camera4:GCameraController;
		/**
        Initialize Example code
     **/
    override public function initExample():Void {		
				title = "MULTI CAMERA EXAMPLE";
				detail = "Example showcasing multiple instanced cameras with different viewports while rendering the same scene. Cameras can be used with different position, scaling, rotation, viewports to suit your needs. Commonly used  to render split screen or UI elements while maintaining aspect ratios across different devices. Using cameras for scene transformations is in most cases the most optimal solution since it doesn't involve invalidation and is directly updated within projection matrix in shader.";
				
				/**/
				camera1 = GNode.createWithComponent(GCameraController);
				camera1.node.setPosition(400, 300);
				camera1.setView(0, 0, .5, .5);
				camera1.contextCamera.group = 3;
				getGenome().root.addChild(camera1.node);
				
				camera2 = GNode.createWithComponent(GCameraController);
				camera2.node.setPosition(400, 300);
				camera2.setView(0.5, 0, .5, 0.5);
				camera2.zoom = 2;
				camera2.contextCamera.group = 3;
				getGenome().root.addChild(camera2.node);

				camera3 = GNode.createWithComponent(GCameraController);
				camera3.node.setPosition(400, 300);
				camera3.setView(0, 0.5, .5, .5);
				camera3.contextCamera.group = 3;
				camera3.zoom = 4;
				getGenome().root.addChild(camera3.node);
				
				camera4 = GNode.createWithComponent(GCameraController);
				camera4.node.setPosition(400, 300);
				camera4.setView(0.5, 0.5, .5, 0.5);
				camera4.zoom = 8;
				camera4.contextCamera.group = 3;
				getGenome().root.addChild(camera4.node);

				// Create a node with simple particle system component
				var particleSystem:GSimpleParticleSystemD = GNode.createWithComponent(GSimpleParticleSystemD);
				particleSystem.texture = GTextureManager.getTexture("assets/atlas.png_particle");
				particleSystem.emission = 128;
				particleSystem.emissionTime = 1;
				particleSystem.emit = true;
				particleSystem.energy = 10;
				particleSystem.dispersionAngleVariance = Math.PI*2;
				particleSystem.initialVelocity = 20;
				particleSystem.initialVelocityVariance = 40;
				particleSystem.initialAngleVariance = 5;
				particleSystem.endAlpha = 0;
				particleSystem.initialScale = 2;
				particleSystem.endScale = .2;
				particleSystem.useWorldSpace = true;
				particleSystem.node.setPosition(400, 300);
				particleSystem.node.cameraGroup = 2;
				container.addChild(particleSystem.node);

				getGenome().onUpdate.add(update_handler);
    }

		private function update_handler(p_deltaTime:Float) {
				camera1.node.rotation += .02;
				camera4.node.rotation -= .02;
		}
}
