package com.genome2d.context;

import unityengine.*;
import unitytestlibrary.*;
import com.genome2d.callbacks.GCallback.GCallback0;
import com.genome2d.callbacks.GCallback.GCallback1;
import com.genome2d.callbacks.GCallback.GCallback2;
import com.genome2d.input.IGFocusable;
import com.genome2d.textures.GTexture;
import com.genome2d.context.IGRenderer;
import com.genome2d.context.renderers.GRendererCommon;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.context.stats.GStats;
import com.genome2d.context.stats.IGStats;
import com.genome2d.geom.GRectangle;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;
import com.genome2d.context.filters.GFilter;
import com.genome2d.macros.MGDebug;

@:nativeGen
class GUnityContext implements IGContext {

	public var onInitialized(default,null):GCallback0;
    public var onFailed(default,null):GCallback1<String>;
    public var onInvalidated(default,null):GCallback0;
    public var onFrame(default,null):GCallback1<Float>;
    public var onMouseInput(default, null):GCallback1<GMouseInput>;
    public var onKeyboardInput(default,null):GCallback1<GKeyboardInput>;
    public var onResize(default,null):GCallback2<Int,Int>;

	public var g2d_onMouseInputInternal:GMouseInput->Void;

	private var g2d_stageViewRect:GRectangle;
    inline public function getStageViewRect():GRectangle {
        return g2d_stageViewRect;
    }

    private var g2d_defaultCamera:GCamera;
    public function getDefaultCamera():GCamera {
        return g2d_defaultCamera;
    }
    
	private var g2d_nativeStage:MonoBehaviour;
    public function getNativeStage():MonoBehaviour {
		return g2d_nativeStage;
	}
    public function getNativeContext():GRectangle {
		return null;
	}

	public function getMaskRect():GRectangle {
		return null;
	}
    public function setMaskRect(p_maskRect:GRectangle):Void {

	}

    public function setActiveCamera(p_camera:GCamera):Bool {
		return false;
	}
    public function getActiveCamera():GCamera {
		return null;
	}

	public function new(p_config:GContextConfig) {
		if (p_config.nativeStage == null) MGDebug.ERROR("You need to specify nativeStage in the config.");

		g2d_nativeStage = p_config.nativeStage;
		g2d_stageViewRect = new GRectangle(0,0,100,100); // Default so far

		g2d_defaultCamera = new GCamera(this);
        g2d_defaultCamera.x = g2d_stageViewRect.width / 2;
        g2d_defaultCamera.y = g2d_stageViewRect.height / 2;

		onInitialized = new GCallback0();
        onFailed = new GCallback1<String>();
        onInvalidated = new GCallback0();
        onResize = new GCallback2<Int,Int>();
        onFrame = new GCallback1<Float>();
        onMouseInput = new GCallback1<GMouseInput>();
        onKeyboardInput = new GCallback1<GKeyboardInput>();
	}

    public function init():Void {
		onInitialized.dispatch();
	}

    public function dispose():Void {

	}

    public function setBackgroundColor(p_color:Int, p_alpha:Float = 1):Void {}
    public function begin():Bool {
		return true;
	}

    public function end():Void {}

    public function draw(p_texture:GTexture, p_blendMode:GBlendMode, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_filter:GFilter = null):Void {}

    public function drawSource(p_texture:GTexture, p_blendMode:GBlendMode, p_sourceX:Float, p_sourceY:Float, p_sourceWidth:Float, p_sourceHeight:Float, p_sourcePivotX:Float, p_sourcePivotY:Float, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_filter:GFilter = null):Void {}

    public function drawMatrix(p_texture:GTexture, p_blendMode:GBlendMode, p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float=1, p_filter:GFilter = null):Void {}

    public function drawPoly(p_texture:GTexture, p_blendMode:GBlendMode, p_vertices:Array<Float>, p_uvs:Array<Float>, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_filter:GFilter = null):Void {}

    public function setBlendMode(p_blendMode:GBlendMode, p_premultiplied:Bool):Void {}

    public function callNextFrame(p_callback:Void->Void):Void {}

    public function setRenderer(p_renderer:IGRenderer):Void {}
	public function flushRenderer():Void {}
	public function getRenderer():IGRenderer {
		return null;
	}

    public function resize(p_rect:GRectangle):Void {}

    public function clearStencil():Void {}
    public function renderToStencil(p_stencilLayer:Int):Void {}
    public function renderToColor(p_stencilLayer:Int):Void {}
    public function setDepthTest(p_depthMask:Bool, p_depthFunc:GDepthFunc):Void {}
    public function getRenderTarget():GTexture {
		return null;
	}
	public function getRenderTargetMatrix():GMatrix3D {
		return null;
	}
    public function setRenderTarget(p_texture:GTexture = null, p_transform:GMatrix3D = null, p_clear:Bool = false):Void {}
    public function setRenderTargets(p_textures:Array<GTexture>, p_transform:GMatrix3D = null, p_clear:Bool = false):Void {}

	private function gotFocus():Void {

    }

    private function lostFocus():Void {

    }

	public function hasFeature(p_feature:Int):Bool {
        switch (p_feature) {
            case GContextFeature.RECTANGLE_TEXTURES:
                return true;
        }

        return false;
    }
}
