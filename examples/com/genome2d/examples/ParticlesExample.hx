/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import unityengine.*;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.particles.modules.GSPHVelocityModule;
import com.genome2d.geom.GRectangle;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.examples.custom.ParticleModule;
import com.genome2d.components.renderable.particles.GParticleSystemComponent;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.textures.GTextureManager;
import com.genome2d.debug.GDebug;

@:nativeGen
class ParticlesExample extends AbstractExample
{

	private var emitter:GParticleEmitter;
	private var module:ParticleModule;

    static public function main() {
        var inst = new ParticlesExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "PARTICLES EXAMPLE";
		detail = "To achieve more complex particle systems Genome2D offers fully customizable particle systems using both spawn and update modules.";

		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.particleSystem.enableSph = true;
		particleSystem.particleSystem.setupGrid(Screen.width,Screen.height,20);
		particleSystem.node.setPosition(0, 0);
		particleSystem.node.name = "particleSystem";
		container.addChild(particleSystem.node);

		emitter = new GParticleEmitter();
		emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		emitter.rate = new GCurve(128);
		emitter.x = Screen.width/2;
		emitter.y = Screen.height/2-200;
		emitter.duration = 1;
		emitter.loop = true;
		emitter.enableSph = true;
		var particleModule = new ParticleModule();
		particleModule.accelerationY = .2;
		emitter.addModule(particleModule);

		particleSystem.particleSystem.addEmitter(emitter);

		emitter = new GParticleEmitter();
		emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		emitter.rate = new GCurve(128);
		emitter.x = Screen.width/2;
		emitter.y = Screen.height/2+200;
		emitter.duration = 1;
		emitter.loop = true;
		emitter.enableSph = true;
		var particleModule = new ParticleModule();
		particleModule.accelerationY = -.2;
		emitter.addModule(particleModule);

		particleSystem.particleSystem.addEmitter(emitter);
    }
}
