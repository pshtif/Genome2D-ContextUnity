/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context;

import unityengine.rendering.*;

class GBlendModeFunc
{
	public static var blendFactors:Array<Map<GBlendMode,Array<BlendMode>>> = [
		[
			GBlendMode.NONE => [BlendMode.One, BlendMode.Zero],
			GBlendMode.NORMAL => [BlendMode.SrcAlpha, BlendMode.OneMinusSrcAlpha],
			GBlendMode.ADD => [BlendMode.SrcAlpha, BlendMode.DstAlpha],
			GBlendMode.MULTIPLY => [BlendMode.DstColor, BlendMode.OneMinusSrcAlpha],
			GBlendMode.SCREEN => [BlendMode.SrcAlpha, BlendMode.One],
			GBlendMode.ERASE => [BlendMode.Zero, BlendMode.OneMinusSrcAlpha],
		],
		[
			GBlendMode.NONE => [BlendMode.One, BlendMode.Zero],
			GBlendMode.NORMAL => [BlendMode.One, BlendMode.OneMinusSrcAlpha],
			GBlendMode.ADD => [BlendMode.One, BlendMode.One],
			GBlendMode.MULTIPLY => [BlendMode.DstColor, BlendMode.OneMinusSrcAlpha],
			GBlendMode.SCREEN => [BlendMode.One, BlendMode.OneMinusSrcColor],
			GBlendMode.ERASE => [BlendMode.Zero, BlendMode.OneMinusSrcAlpha],
		]
	];
	/*
	static public function addBlendMode(p_normalFactors:Array<BlendMode>, p_premultipliedFactors:Array<BlendMode>):Int { 
		blendFactors[0].push(p_normalFactors);
		blendFactors[1].push(p_premultipliedFactors);
		
		return blendFactors[0].length;
	}
	/*
	*/
	inline static public function getSrcBlendMode(p_mode:GBlendMode, p_premultiplied:Bool):BlendMode {
		var p:Int = (p_premultiplied) ? 1 : 0;
		var blendMode:BlendMode = BlendMode.SrcAlpha;
		if (p_premultiplied) {
			if (p_mode == GBlendMode.NONE) blendMode = BlendMode.One;
			//if (p_mode == GBlendMode.NORMAL) blendMode = BlendMode.SrcAlpha;
			//if (p_mode == GBlendMode.ADD) blendMode = BlendMode.SrcAlpha;
			if (p_mode == GBlendMode.MULTIPLY) blendMode = BlendMode.DstColor;
			//if (p_mode == GBlendMode.SCREEN) blendMode = BlendMode.SrcAlpha;
			if (p_mode == GBlendMode.ERASE) blendMode = BlendMode.Zero;
		} else {
			if (p_mode == GBlendMode.NONE) blendMode = BlendMode.One;
			if (p_mode == GBlendMode.NORMAL) blendMode = BlendMode.One;
			if (p_mode == GBlendMode.ADD) blendMode = BlendMode.One;
			if (p_mode == GBlendMode.MULTIPLY) blendMode = BlendMode.DstColor;
			if (p_mode == GBlendMode.SCREEN) blendMode = BlendMode.One;
			if (p_mode == GBlendMode.ERASE) blendMode = BlendMode.Zero;
		}
		return blendMode;
	}

	inline static public function getDstBlendMode(p_mode:GBlendMode, p_premultiplied:Bool):BlendMode {
		var p:Int = (p_premultiplied) ? 1 : 0;
		var blendMode:BlendMode = BlendMode.OneMinusSrcAlpha;
		if (p_premultiplied) {
			if (p_mode == GBlendMode.NONE) blendMode = BlendMode.Zero;
			//if (p_mode == GBlendMode.NORMAL) blendMode = BlendMode.OneMinusSrcAlpha;
			if (p_mode == GBlendMode.ADD) blendMode = BlendMode.DstAlpha;
			//if (p_mode == GBlendMode.MULTIPLY) blendMode = BlendMode.OneMinusSrcAlpha;
			if (p_mode == GBlendMode.SCREEN) blendMode = BlendMode.One;
			//if (p_mode == GBlendMode.ERASE) blendMode = BlendMode.OneMinusSrcAlpha;
		} else {
			if (p_mode == GBlendMode.NONE) blendMode = BlendMode.Zero;
			//if (p_mode == GBlendMode.NORMAL) blendMode = BlendMode.OneMinusSrcAlpha;
			if (p_mode == GBlendMode.ADD) blendMode = BlendMode.One;
			//if (p_mode == GBlendMode.MULTIPLY) blendMode = BlendMode.OneMinusSrcAlpha;
			if (p_mode == GBlendMode.SCREEN) blendMode = BlendMode.OneMinusSrcColor;
			//if (p_mode == GBlendMode.ERASE) blendMode = BlendMode.OneMinusSrcAlpha;
		}
		return blendMode;
	}
}