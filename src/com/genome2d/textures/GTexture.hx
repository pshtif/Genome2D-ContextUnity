/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.textures;

import unityengine.*;
import com.genome2d.debug.GDebug;
import com.genome2d.context.IGContext;
import com.genome2d.geom.GRectangle;
import com.genome2d.context.GContextFeature;
import com.genome2d.textures.GTextureSourceType;

class GTexture extends GTextureBase
{
	public function getImage():Dynamic {
		if (g2d_sourceType == GTextureSourceType.TEXTURE) {
			//return cast (g2d_source,GTexture).getImage();
		}
		return g2d_source;
	}

	override public function setSource(p_value:Dynamic):Dynamic {
        if (g2d_source != p_value) {
            g2d_dirty = true;
			g2d_source = p_value;
            if (Std.is(g2d_source, Texture)) {
				// Implement source of native Unity texture;
                g2d_sourceType = GTextureSourceType.IMAGE;
				g2d_nativeTexture = g2d_source;
                g2d_gpuWidth = g2d_nativeWidth = g2d_nativeTexture.width;
                g2d_gpuHeight = g2d_nativeHeight = g2d_nativeTexture.height;
                premultiplied = false;
            } else if (Std.is(g2d_source,GRectangle)) {
                g2d_sourceType = GTextureSourceType.RENDER_TARGET;
                g2d_nativeWidth = p_value.width;
				g2d_nativeHeight = p_value.height;
				premultiplied = false;
            } else if (Std.is(g2d_source, GTexture)) {
				var parent:GTexture = cast g2d_source;
				parent.onInvalidated.add(parentInvalidated_handler);
				parent.onDisposed.add(parentDisposed_handler);
				g2d_gpuWidth = parent.g2d_gpuWidth;
				g2d_gpuHeight = parent.g2d_gpuHeight;
				g2d_nativeWidth = parent.g2d_nativeWidth;
				g2d_nativeHeight = parent.g2d_nativeHeight;
				g2d_nativeTexture = parent.nativeTexture;
				g2d_inverted = parent.g2d_inverted;
				g2d_sourceType = GTextureSourceType.TEXTURE;
				premultiplied = parent.premultiplied;
			} else {
                GDebug.error("Invalid texture source.");
            }
            g2d_dirty = true;
        }
        return g2d_source;
    }
	
    public function invalidateNativeTexture(p_reinitialize:Bool):Void {
		if (g2d_sourceType == GTextureSourceType.RENDER_TARGET) {
			if (g2d_nativeTexture == null || g2d_nativeTexture.width != g2d_nativeWidth || g2d_nativeTexture.height != g2d_nativeHeight) {
				g2d_gpuWidth = g2d_nativeWidth;
				g2d_gpuHeight = g2d_nativeHeight;
				g2d_nativeTexture = new RenderTexture(g2d_nativeWidth, g2d_nativeHeight, 16);
			}
		}

		if (g2d_nativeTexture != null) {
			if (repeatable) {
				g2d_nativeTexture.wrapMode = TextureWrapMode.Repeat;
			} else {
				g2d_nativeTexture.wrapMode = TextureWrapMode.Clamp;
			}

			if (filteringType == GTextureFilteringType.LINEAR) {
				g2d_nativeTexture.filterMode = FilterMode.Point;
			} else {
				g2d_nativeTexture.filterMode = FilterMode.Bilinear;	
			}
		}
    }

	override public function getAlphaAtUV(p_u:Float, p_v:Float):Int {
		var alpha:Int = 0;
		
        var texture2d:Texture2D = cast g2d_nativeTexture;
        if( texture2d != null ) {

            var color:Color = texture2d.GetPixel(Std.int(p_u * g2d_nativeTexture.width),Std.int(p_v * g2d_nativeTexture.height));
            alpha = Std.int(color.a * 255);
        }

        return alpha;
	}

	override public function dispose(p_disposeSource:Bool = false):Void {
		if (g2d_sourceType != GTextureSourceType.TEXTURE && g2d_nativeTexture != null) Object.DestroyImmediate(g2d_nativeTexture);

		/*
		if (g2d_sourceType == GTextureSourceType.RENDER_TARGET) {
			cast (g2d_nativeTexture, RenderTexture).Release();
		}
		/*
		*/
		g2d_nativeTexture = null;

		super.dispose(p_disposeSource);
	}

	/*
	 * 	Get an instance from reference
	 */
	static public function fromReference(p_reference:String) {
		return GTextureManager.getTexture(p_reference.substr(1));
	}
	
	/****************************************************************************************************
	 * 	GPU DEPENDANT PROPERTIES
	 ****************************************************************************************************/
	
	private var g2d_nativeTexture:Texture;
	/**
	 * 	Native texture reference
	 */
    public var nativeTexture(get,never):Texture;
    inline private function get_nativeTexture():Texture {
        return g2d_nativeTexture;
    }
	
	/**
	 * 	Check if this texture has same gpu texture as the passed texture
	 *
	 * 	@param p_texture
	 */
    public function hasSameGPUTexture(p_texture:GTexture):Bool {
        return p_texture.nativeTexture == nativeTexture;
    }
}