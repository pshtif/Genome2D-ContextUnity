package com.genome2d.examples.custom;

import com.genome2d.particles.modules.GParticleEmitterModule;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.context.GBlendMode;

class CustomModule extends GParticleEmitterModule
{
	public var accelerationY:Float =.2;

	public function new() {
		super();		
		
		updateParticleModule = true;
		spawnParticleModule = true;
	}

	override public function spawnParticle(p_emitter:GParticleEmitter, p_particle:GParticle):Void {
		p_particle.blendMode = GBlendMode.ADD;
		p_particle.scaleX = 4;
		p_particle.scaleY = 4;
		p_particle.red = 1;
		p_particle.green = .5;
		p_particle.blue = 0;
	}
	
	override public function updateParticle(p_emitter:GParticleEmitter, p_particle:GParticle, p_deltaTime:Float):Void {
		var life:Float = p_particle.accumulatedTime/1000;
		p_particle.scaleX = 4 - life*2.5;
		p_particle.scaleY = 4 - life*2.5;
		p_particle.alpha = 1-life*1.1;
	}
}