package com.genome2d.examples.custom;

import com.genome2d.particles.modules.GParticleEmitterModule;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticleEmitter;

class ParticleModule extends GParticleEmitterModule
{
	public var accelerationY:Float =.2;

	public function new() {
		super();		
		
		updateParticleModule = true;
		spawnParticleModule = true;
	}

	override public function spawnParticle(p_emitter:GParticleEmitter, p_particle:GParticle):Void {
		p_particle.x += Math.random()*32-16;
		p_particle.y += Math.random()*32-16;
	}
	
	override public function updateParticle(p_emitter:GParticleEmitter, p_particle:GParticle, p_deltaTime:Float):Void {
		if (p_particle.density > 0 && !p_particle.fixed && p_particle.group == null) {
			p_particle.velocityX += p_particle.fluidX / (p_particle.density * 0.9 + 0.1);
			p_particle.velocityY += p_particle.fluidY / (p_particle.density * 0.9 + 0.1);
		}

		p_particle.velocityY += accelerationY;
		if (!p_particle.fixed) {
			p_particle.x += p_particle.velocityX * p_deltaTime / 30;
			p_particle.y += p_particle.velocityY * p_deltaTime / 30;
		}
		p_particle.accumulatedTime += p_deltaTime;

		if (p_particle.accumulatedTime > 1000) p_particle.die = true;
	}
}