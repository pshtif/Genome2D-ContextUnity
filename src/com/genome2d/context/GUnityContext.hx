package com.genome2d.context;

import unityengine.*;
import unityengine.rendering.*;
import genome2dnativeplugin.*;
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
import com.genome2d.project.GProject;

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

    private var g2d_currentDeltaTime:Float;
    private var g2d_currentTime:Float;

    private var g2d_nextFrameCallback:Void->Void;
    public function callNextFrame(p_callback:Void->Void):Void {
        g2d_nextFrameCallback = p_callback;
    }

	private var g2d_stageViewRect:GRectangle;
    inline public function getStageViewRect():GRectangle {
        return g2d_stageViewRect;
    }

    private var g2d_defaultCamera:GCamera;
    public function getDefaultCamera():GCamera {
        return g2d_defaultCamera;
    }
    
	private var g2d_nativeStage:GProject;
    public function getNativeStage():GProject {
		return g2d_nativeStage;
	}

    private var g2d_nativeContext:GNativeUnityContext;
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
		g2d_stageViewRect = p_config.viewRect;

		g2d_defaultCamera = new GCamera(this);

		onInitialized = new GCallback0();
        onFailed = new GCallback1<String>();
        onInvalidated = new GCallback0();
        onResize = new GCallback2<Int,Int>();
        onFrame = new GCallback1<Float>();
        onMouseInput = new GCallback1<GMouseInput>();
        onKeyboardInput = new GCallback1<GKeyboardInput>();
	}

    public function init():Void {
        g2d_currentTime = Date.now().getTime();

        g2d_nativeContext = new GNativeUnityContext(g2d_nativeStage);
        g2d_nativeStage.onFrame.add(g2d_enterFrame_handler);
        g2d_nativeStage.onMouseButton.add(g2d_mouseButton_handler);
        g2d_nativeStage.onMouseMove.add(g2d_mouseMove_handler);
		onInitialized.dispatch();
	}

    private function g2d_enterFrame_handler():Void {
        var currentTime:Float = Date.now().getTime();
        g2d_currentDeltaTime = currentTime - g2d_currentTime;
        g2d_currentTime = currentTime;
        if (g2d_nextFrameCallback != null) {
            var callback:Void->Void = g2d_nextFrameCallback;
            g2d_nextFrameCallback = null;
            callback();
        }
        onFrame.dispatch(g2d_currentDeltaTime);
    }

    private function g2d_mouseButton_handler(p_button:Int, p_state:Bool):Void {
        var mx:Float = Input.mousePosition.x - g2d_stageViewRect.x;
        var my:Float = Input.mousePosition.y - g2d_stageViewRect.y;
    }

    private function g2d_mouseMove_handler():Void {
        var mx:Float = Input.mousePosition.x - g2d_stageViewRect.x;
        var my:Float = Input.mousePosition.y - g2d_stageViewRect.y;

        Debug.Log(Input.mousePosition.x +" : "+Input.mousePosition.y);
        Debug.Log(mx +" : "+my);
    }


    public function dispose():Void {

	}

    public function setBackgroundColor(p_color:Int, p_alpha:Float = 1):Void {}
    public function begin():Bool {
        g2d_nativeContext.Begin();
		return true;
	}

    public function end():Void {
        flushRenderer();
    }

    public function draw(p_texture:GTexture, p_blendMode:GBlendMode, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_filter:GFilter = null):Void {
        g2d_nativeContext.Draw(p_texture.nativeTexture, BlendMode.OneMinusSrcAlpha, p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, p_texture.u, p_texture.v, p_texture.uScale, p_texture.vScale, p_texture.width, p_texture.height, p_texture.pivotX, p_texture.pivotY, g2d_stageViewRect.height);
        //g2d_nativeContext.Draw(p_texture.nativeTexture, BlendMode.OneMinusSrcAlpha, p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, 0, 0, .5, .5, p_texture.nativeTexture.width, p_texture.nativeTexture.height);
    }

    public function drawSource(p_texture:GTexture, p_blendMode:GBlendMode, p_sourceX:Float, p_sourceY:Float, p_sourceWidth:Float, p_sourceHeight:Float, p_sourcePivotX:Float, p_sourcePivotY:Float, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_filter:GFilter = null):Void {}

    public function drawMatrix(p_texture:GTexture, p_blendMode:GBlendMode, p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float=1, p_filter:GFilter = null):Void {}

    public function drawPoly(p_texture:GTexture, p_blendMode :GBlendMode, p_vertices:Array<Float>, p_uvs:Array<Float>, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_filter:GFilter = null):Void {}

    public function setBlendMode(p_blendMode:GBlendMode, p_premultiplied:Bool):Void {}

    public function setRenderer(p_renderer:IGRenderer):Void {}

	public function flushRenderer():Void {
        g2d_nativeContext.FlushRenderer();
    }

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
