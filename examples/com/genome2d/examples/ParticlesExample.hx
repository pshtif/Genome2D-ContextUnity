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
import com.genome2d.examples.custom.CustomModule;
import com.genome2d.examples.custom.CustomSPHModule;
import com.genome2d.components.renderable.particles.GParticleSystemComponent;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.textures.GTextureManager;
import com.genome2d.debug.GDebug;
import com.genome2d.input.GMouseInput;

@:nativeGen
class ParticlesExample extends AbstractExample
{
	public var particleCount:Int = 256;
	private var _particleSystem:GParticleSystemComponent;
	private var _emitter:GParticleEmitter;

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
        _particleSystem = GNode.createWithComponent(GParticleSystemComponent);
		_particleSystem.particleSystem.enableSph = true;
		_particleSystem.particleSystem.setupGrid(Screen.width,Screen.height,20);
		_particleSystem.node.setPosition(Screen.width/2, Screen.height/2);
		_particleSystem.node.name = "particleSystem";
		container.addChild(_particleSystem.node);

		_emitter = new GParticleEmitter();
		_emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		_emitter.rate = new GCurve(particleCount);
		//_emitter.x = Screen.width/2;
		//_emitter.y = Screen.height/2-200;
		_emitter.duration = 1;
		_emitter.loop = true;
		_emitter.enableSph = true;
		var particleModule = new CustomSPHModule();
		particleModule.accelerationY = .2;
		_emitter.addModule(particleModule);

		//particleSystem.particleSystem.addEmitter(_emitter);

		_emitter = new GParticleEmitter();
		_emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		_emitter.rate = new GCurve(particleCount);
		//_emitter.x = Screen.width/2;
		//_emitter.y = Screen.height/2+200;
		_emitter.duration = 1;
		_emitter.loop = true;
		_emitter.enableSph = true;
		var particleModule = new CustomSPHModule();
		particleModule.accelerationY = -.2;
		_emitter.addModule(particleModule);
		_emitter.addModule(new CustomModule());

		_particleSystem.particleSystem.addEmitter(_emitter);

		Genome2D.getInstance().getContext().onMouseInput.add(mouseInput_handler);
    }

	private function mouseInput_handler(p_input:GMouseInput):Void {
		_particleSystem.node.setPosition(p_input.contextX, p_input.contextY);
	}
}
