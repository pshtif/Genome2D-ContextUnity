/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context;

import com.genome2d.input.Exception.NotImplementedException;
import com.genome2d.input.GOverridableUnityInput;
import com.genome2d.input.GOldUnityInput;
import com.genome2d.input.GUnityInputType;
import com.genome2d.input.IGUnityInput;
import unityengine.*;
import genome2dnativeplugin.*;
import com.genome2d.callbacks.GCallback.GCallback0;
import com.genome2d.callbacks.GCallback.GCallback1;
import com.genome2d.callbacks.GCallback.GCallback2;
import com.genome2d.textures.GTexture;
import com.genome2d.context.IGRenderer;
import com.genome2d.geom.GMatrix;
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
import com.genome2d.geom.GVector3D;

@:nativeGen
class GUnityContext implements IGContext {

    //Experimental
    public var USE_TOUCHES_WITH_PRIORITY:Bool = false;

    public var onInitialized(default,null):GCallback0;
    public var onFailed(default,null):GCallback1<String>;
    public var onInvalidated(default,null):GCallback0;
    public var onFrame(default,null):GCallback1<Float>;
    public var onMouse(default,null):GCallback2<String, Bool>;
    public var onMouseInput(default, null):GCallback1<GMouseInput>;
    public var onKeyboardInput(default,null):GCallback1<GKeyboardInput>;
    public var onResize(default,null):GCallback2<Int,Int>;

    public var g2d_onMouseInputInternal:GMouseInput->Void;

    private var g2d_renderTarget:GTexture;
    private var g2d_backgroundColor:Color;

    private var g2d_projectionMatrix:GProjectionMatrix = new GProjectionMatrix();
    private var g2d_viewPortRect:Rect = new Rect(0, 0, 0, 0);
    private var g2d_zAxisVector:GVector3D = GVector3D.Z_AXIS;
    private var g2d_cachedMatrix:GMatrix;

    private var g2d_currentDeltaTime:Float;
    private var g2d_currentTime:Float;

    private var g2d_stats:IGStats;

    private var g2d_maxBatchSize:Int;
    private var g2d_meshCount:Int;

    private var g2d_mouseInitialized = false;
    private var g2d_lastMouseX:Float;
    private var g2d_lastMouseY:Float;

    private var g2d_unityInputType:GUnityInputType;
    private var g2d_inputsMap:Map<GUnityInputType,IGUnityInput>;

    private var g2d_nextFrameCallback:Void->Void;
    public function callNextFrame(p_callback:Void->Void):Void {
        g2d_nextFrameCallback = p_callback;
    }

    private var g2d_stageViewRect:GRectangle;
    inline public function getStageViewRect():GRectangle {
        return g2d_stageViewRect;
    }
    private var g2d_activeViewRect:GRectangle;
    private var g2d_activeMaskRect:GRectangle;

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

    inline public function getMaskRect():GRectangle {
        return g2d_activeMaskRect;
    }
    inline public function setMaskRect(p_maskRect:GRectangle):Void {
        if (p_maskRect != g2d_activeMaskRect || ((p_maskRect != null && g2d_activeMaskRect != null) && (p_maskRect.width != g2d_activeMaskRect.width || p_maskRect.height != g2d_activeMaskRect.height && p_maskRect.x != g2d_activeMaskRect.x || p_maskRect.y != g2d_activeMaskRect.y))) {

            if (p_maskRect == null) {
                g2d_activeMaskRect = null;
                setActiveCamera(g2d_activeCamera);
                g2d_viewPortRect.Set(g2d_activeViewRect.x, g2d_activeViewRect.y, g2d_activeViewRect.width, g2d_activeViewRect.height);
                GL.Viewport(g2d_viewPortRect);
            } else {
                flushRenderer();

                g2d_activeMaskRect = g2d_activeViewRect.intersection(new GRectangle(p_maskRect.x + g2d_activeViewRect.x + g2d_activeViewRect.width * .5 - g2d_activeCamera.x * g2d_activeCamera.scaleX, p_maskRect.y + g2d_activeViewRect.y + g2d_activeViewRect.height * .5 - g2d_activeCamera.y * g2d_activeCamera.scaleY, p_maskRect.width, p_maskRect.height));

                g2d_projectionMatrix.reset();
                g2d_projectionMatrix.ortho(g2d_activeMaskRect.width, g2d_activeMaskRect.height, null);

                g2d_projectionMatrix.prependTranslation(-g2d_activeMaskRect.x+g2d_defaultCamera.x-g2d_activeCamera.x*g2d_activeCamera.scaleX, -g2d_activeMaskRect.y+g2d_defaultCamera.y-g2d_activeCamera.y*g2d_activeCamera.scaleX, 0);
                g2d_projectionMatrix.prependScale(g2d_activeCamera.scaleX, g2d_activeCamera.scaleY, 1);

                GL.LoadProjectionMatrix(g2d_projectionMatrix.rawData);

                // TODO need to test as it's inverted in Unity
                g2d_viewPortRect.Set(g2d_activeMaskRect.x, g2d_activeViewRect.height-g2d_activeMaskRect.y-g2d_activeMaskRect.height, g2d_activeMaskRect.width, g2d_activeMaskRect.height);
                GL.Viewport(g2d_viewPortRect);
            }
        }
    }

    private var g2d_activeCamera:GCamera;
    public function setActiveCamera(p_camera:GCamera):Bool {
        if (g2d_stageViewRect.width*p_camera.normalizedViewWidth <= 0 ||
        g2d_stageViewRect.height*p_camera.normalizedViewHeight <= 0) return false;

        flushRenderer();

        g2d_activeCamera = p_camera;

        g2d_activeViewRect.setTo(Std.int(g2d_stageViewRect.width*g2d_activeCamera.normalizedViewX),
        Std.int(g2d_stageViewRect.height*(1-g2d_activeCamera.normalizedViewY) - g2d_stageViewRect.height*g2d_activeCamera.normalizedViewHeight),
        Std.int(g2d_stageViewRect.width*g2d_activeCamera.normalizedViewWidth),
        Std.int(g2d_stageViewRect.height*g2d_activeCamera.normalizedViewHeight));
        var vx:Float = (g2d_activeViewRect.width*.5)/g2d_activeCamera.normalizedViewWidth;//g2d_activeViewRect.width;
        var vy:Float = (g2d_activeViewRect.height*.5)/g2d_activeCamera.normalizedViewHeight;

        g2d_projectionMatrix.reset();
        g2d_projectionMatrix.ortho(g2d_stageViewRect.width, g2d_stageViewRect.height, null);

        g2d_projectionMatrix.prependTranslation(vx, vy, 0);
        g2d_projectionMatrix.prependRotation(g2d_activeCamera.rotation*180/Math.PI, g2d_zAxisVector, null);
        g2d_projectionMatrix.prependScale(g2d_activeCamera.scaleX*1/g2d_activeCamera.normalizedViewWidth, g2d_activeCamera.scaleY*1/g2d_activeCamera.normalizedViewHeight, 1);
        g2d_projectionMatrix.prependTranslation(-g2d_activeCamera.x, -g2d_activeCamera.y, 0);

        GL.LoadProjectionMatrix(g2d_projectionMatrix.rawData);
        g2d_viewPortRect.Set(g2d_activeViewRect.x, g2d_activeViewRect.y, g2d_activeViewRect.width, g2d_activeViewRect.height);
        GL.Viewport(g2d_viewPortRect);

        return true;
    }
    public function getActiveCamera():GCamera {
        return g2d_activeCamera;
    }

    public function new(p_config:GContextConfig) {
        if (p_config.nativeStage == null) MGDebug.ERROR("You need to specify nativeStage in the config.");

        g2d_nativeStage = p_config.nativeStage;
        g2d_stageViewRect = p_config.viewRect;
        g2d_maxBatchSize = p_config.maxBatchSize;
        g2d_meshCount = p_config.meshCount;
        g2d_activeViewRect = new GRectangle(0, 0, 0, 0);

        g2d_defaultCamera = new GCamera(this);
        g2d_defaultCamera.x = g2d_stageViewRect.width / 2;
        g2d_defaultCamera.y = g2d_stageViewRect.height / 2;
        g2d_cachedMatrix = new GMatrix();

        g2d_unityInputType = p_config.unityInputType;
        g2d_inputsMap = new Map();

        onInitialized = new GCallback0();
        onFailed = new GCallback1<String>();
        onInvalidated = new GCallback0();
        onResize = new GCallback2<Int,Int>();
        onFrame = new GCallback1<Float>();
        onMouse = new GCallback2<String, Bool>();
        onMouseInput = new GCallback1<GMouseInput>();
        onKeyboardInput = new GCallback1<GKeyboardInput>();

        g2d_stats = new GStats(g2d_nativeStage);
    }

    public function init():Void {
        g2d_currentTime = unityengine.Time.time * 1000;
        g2d_backgroundColor = Color.black;

        g2d_nativeContext = new GNativeUnityContext(g2d_nativeStage, g2d_enterFrame_handler, g2d_maxBatchSize, g2d_meshCount);
        g2d_nativeStage.onFrame.add(g2d_enterFrame_handler);
        g2d_nativeStage.onUpdate.add(g2d_update_handler);
        onInitialized.dispatch();
    }

    private function g2d_enterFrame_handler():Void {
        var currentTime:Float = unityengine.Time.time * 1000;
        g2d_currentDeltaTime = currentTime - g2d_currentTime;
        g2d_currentTime = currentTime;

        g2d_stats.render(this);
        if (g2d_nextFrameCallback != null) {
            var callback:Void->Void = g2d_nextFrameCallback;
            g2d_nextFrameCallback = null;
            callback();
        }
        onFrame.dispatch(g2d_currentDeltaTime);
    }

    private function g2d_update_handler():Void {
        var unityInput = getUnityInput();

        var mouseDown = false;
        var mouseUp = false;
        var holdingDown = false;

        if (USE_TOUCHES_WITH_PRIORITY && unityInput.getTouchCount() > 0) {
            var touch = unityInput.getTouch(0);

            if (touch.phase == TouchPhase.Began) {
                mouseDown = true;
                holdingDown = true;
            } else if (touch.phase == TouchPhase.Ended || touch.phase == TouchPhase.Canceled) {
                mouseUp = true;
            } else if (touch.phase == TouchPhase.Moved || touch.phase == TouchPhase.Stationary) {
                holdingDown = true;
            }
        } else {
            mouseDown = unityInput.getMouseButtonDown(0);
            mouseUp = unityInput.getMouseButtonUp(0);
            holdingDown = unityInput.getMouseButton(0);
        }

        if (mouseDown) {
            g2d_mouse_handler(GMouseInputType.MOUSE_DOWN, true);
            onMouse.dispatch(GMouseInputType.MOUSE_DOWN, true);
        } else if (mouseUp) {
            g2d_mouse_handler(GMouseInputType.MOUSE_UP, false);
            onMouse.dispatch(GMouseInputType.MOUSE_UP, false);
        } else {
            g2d_mouse_handler(GMouseInputType.MOUSE_MOVE, holdingDown);
            onMouse.dispatch(GMouseInputType.MOUSE_MOVE, holdingDown);
        }

        if (unityInput.getMouseScrollDelta().y != 0) {
            g2d_mouse_handler(GMouseInputType.MOUSE_WHEEL, holdingDown);
            onMouse.dispatch(GMouseInputType.MOUSE_WHEEL, holdingDown);
        }
    }

    private function g2d_mouse_handler(p_type:String, p_buttonDown:Bool):Void {
        var unityInput = getUnityInput();

        var position:{x:Single, y:Single} = (unityInput.getTouchCount() > 0)
            ? unityInput.getTouch(0).position
            : unityInput.getMousePosition();

        // Since we are sending mouse move per update call it's not always moving
        if (p_type == GMouseInputType.MOUSE_MOVE) {
            if (!g2d_mouseInitialized) {
                g2d_mouseInitialized = true;
            } else {
                if (g2d_lastMouseX == position.x && g2d_lastMouseY == position.y) {
                    return;
                }
            }
            g2d_lastMouseX = position.x;
            g2d_lastMouseY = position.y;
        }

        var mx:Float = position.x - g2d_stageViewRect.x;
        var my:Float = Screen.height - position.y - g2d_stageViewRect.y;

        var input:GMouseInput = new GMouseInput(this, this, p_type, mx, my);
        input.worldX = input.contextX = mx;
        input.worldY = input.contextY = my;
        input.buttonDown = p_buttonDown;
        input.ctrlKey = false;
        input.altKey = false;
        input.shiftKey = false;
        input.delta = Std.int(unityInput.getMouseScrollDelta().y);
        input.nativeCaptured = false;

        onMouseInput.dispatch(input);
        if (!input.captured) g2d_onMouseInputInternal(input);
    }

    public function dispose():Void {

    }

    public function getUnityInput(inputType:Null<GUnityInputType> = null):IGUnityInput {
        if (inputType == null)
            inputType = g2d_unityInputType;

        if (g2d_inputsMap.exists(inputType))
            return g2d_inputsMap[inputType];

        var input:IGUnityInput = null;

        switch (inputType) {
            case GUnityInputType.OLD:
                input = new GOldUnityInput();

            case GUnityInputType.OVERRIDABLE:
                input = new GOverridableUnityInput();

            default:
                throw new NotImplementedException("Create $inputType input handler isn't supported (yet)");
        }

        g2d_inputsMap.set(inputType, input);

        return input;
    }

    public function setBackgroundColor(p_color:Int, p_alpha:Float = 1):Void {
        var red = Std.int(p_color >> 16 & 0xFF) / 0xFF;
        var green = Std.int(p_color >> 8 & 0xFF) / 0xFF;
        var blue = Std.int(p_color & 0xFF) / 0xFF;

        g2d_backgroundColor = new Color(red, green, blue, p_alpha);
    }

    public function begin():Bool {
        g2d_stats.clear();
        setActiveCamera(g2d_defaultCamera);
        GL.Clear(false, true, g2d_backgroundColor, 1);
        g2d_nativeContext.Begin();
        return true;
    }

    public function end():Void {
        flushRenderer();
    }

    public function draw(p_texture:GTexture, p_blendMode:GBlendMode, p_x:Float, p_y:Float, p_scaleX:Float, p_scaleY:Float, p_rotation:Float, p_red:Float, p_green:Float, p_blue:Float, p_alpha:Float, p_filter:GFilter):Void {
        var srcBlendMode = GBlendModeFunc.getSrcBlendMode(p_blendMode, p_texture.premultiplied);
        var dstBlendMode = GBlendModeFunc.getDstBlendMode(p_blendMode, p_texture.premultiplied);
        g2d_nativeContext.Draw(p_texture.nativeTexture, p_texture.premultiplied, srcBlendMode, dstBlendMode, p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, p_texture.u, p_texture.v, p_texture.uScale, p_texture.vScale, p_texture.width, p_texture.height, p_texture.pivotX, p_texture.pivotY, p_filter);
    }

    @:access(com.genome2d.textures.GTexture)
    public function drawSource(p_texture:GTexture, p_blendMode:GBlendMode, p_sourceX:Float, p_sourceY:Float, p_sourceWidth:Float, p_sourceHeight:Float, p_sourcePivotX:Float, p_sourcePivotY:Float, p_x:Float, p_y:Float, p_scaleX:Float, p_scaleY:Float, p_rotation:Float, p_red:Float, p_green:Float, p_blue:Float, p_alpha:Float, p_filter:GFilter):Void {
        var srcBlendMode = GBlendModeFunc.getSrcBlendMode(p_blendMode, p_texture.premultiplied);
        var dstBlendMode = GBlendModeFunc.getDstBlendMode(p_blendMode, p_texture.premultiplied);
        var u:Float = p_sourceX / p_texture.g2d_gpuWidth;
        var v:Float = p_sourceY / p_texture.g2d_gpuHeight;
        var uScale:Float = p_sourceWidth / p_texture.g2d_gpuWidth;
        var vScale:Float = p_sourceHeight / p_texture.g2d_gpuHeight;
        g2d_nativeContext.Draw(p_texture.nativeTexture, p_texture.premultiplied, srcBlendMode, dstBlendMode, p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, u, v, uScale, vScale, p_sourceWidth, p_sourceHeight, p_sourcePivotX, p_sourcePivotY, p_filter == null ? null : p_filter);
    }

    public function drawMatrix(p_texture:GTexture, p_blendMode:GBlendMode, p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float, p_red:Float, p_green:Float, p_blue:Float, p_alpha:Float, p_filter:GFilter):Void {
        g2d_cachedMatrix.setTo(p_a, p_b, p_c, p_d, p_tx, p_ty);
        var srcBlendMode = GBlendModeFunc.getSrcBlendMode(p_blendMode, p_texture.premultiplied);
        var dstBlendMode = GBlendModeFunc.getDstBlendMode(p_blendMode, p_texture.premultiplied);
        g2d_nativeContext.DrawMatrix(p_texture.nativeTexture, p_texture.premultiplied, srcBlendMode, dstBlendMode, cast g2d_cachedMatrix, p_red, p_green, p_blue, p_alpha, p_texture.u, p_texture.v, p_texture.uScale, p_texture.vScale, p_texture.width, p_texture.height, p_texture.pivotX, p_texture.pivotY, p_filter);
    }

    public function drawPoly(p_texture:GTexture, p_blendMode:GBlendMode, p_vertices:Array<Float>, p_uvs:Array<Float>, p_x:Float, p_y:Float, p_scaleX:Float, p_scaleY:Float, p_rotation:Float, p_red:Float, p_green:Float, p_blue:Float, p_alpha:Float, p_filter:GFilter):Void {
        var srcBlendMode = GBlendModeFunc.getSrcBlendMode(p_blendMode, p_texture.premultiplied);
        var dstBlendMode = GBlendModeFunc.getDstBlendMode(p_blendMode, p_texture.premultiplied);
        g2d_nativeContext.DrawPoly(p_texture.nativeTexture, p_texture.premultiplied, srcBlendMode, dstBlendMode, cs.Lib.nativeArray(p_vertices, false), cs.Lib.nativeArray(p_uvs, false), p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, p_texture.u, p_texture.v, p_texture.uScale, p_texture.vScale, p_filter);
    }

    public function setBlendMode(p_blendMode:GBlendMode, p_premultiplied:Bool):Void {}
    public function setRenderer(p_renderer:IGRenderer):Void {
        flushRenderer();
    }

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
        return g2d_renderTarget;
    }
    public function getRenderTargetMatrix():GMatrix3D {
        return null;
    }
    public function setRenderTarget(p_texture:GTexture = null, p_transform:GMatrix3D = null, p_clear:Bool = false):Void {
        if (p_transform != null) MGDebug.WARNING("Transform on render target not supported yet.");

        if (p_texture != g2d_renderTarget) {
            flushRenderer();
        }

        if (p_texture == null) {
            RenderTexture.active = null;

            setActiveCamera(g2d_activeCamera);
        } else {
            Graphics.SetRenderTarget(cast (p_texture.nativeTexture, RenderTexture));

            if (p_clear) {
                GL.Clear(true, true, Color.clear);
            }

            g2d_projectionMatrix.reset();
            g2d_projectionMatrix.orthoRtt(p_texture.nativeWidth, p_texture.nativeHeight, null);
            GL.LoadProjectionMatrix(g2d_projectionMatrix.rawData);
        }

        g2d_renderTarget = p_texture;
    }

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