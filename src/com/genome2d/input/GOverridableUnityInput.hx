package com.genome2d.input;

import com.genome2d.input.Exception;
import cs.NativeArray;
import genome2dnativeplugin.*;
import unityengine.*;

class GOverridableUnityInput implements IGUnityInput {

    public function new() {
    }

    public function getDeviceOrientation():DeviceOrientation {
        throw createNotSupportedException("getDeviceOrientation");
    }

    public function getTouchCount():Int {
        return GNativeUnityOverridableInput.BaseInput.touchCount;
    }

    public function getTouch(index:Int):Touch {
        return GNativeUnityOverridableInput.BaseInput.GetTouch(index);
    }

    public function getTouches():NativeArray<Touch> {
        var touches = new NativeArray<Touch>(getTouchCount());
        for (i in 0...touches.length) {
            touches[i] = getTouch(i);
        }

        return touches;
    }

    public function getMouseButtonDown(button:Int):Bool {
        return GNativeUnityOverridableInput.BaseInput.GetMouseButtonDown(button);
    }

    public function getMouseButtonUp(button:Int):Bool {
        return GNativeUnityOverridableInput.BaseInput.GetMouseButtonUp(button);
    }

    public function getMouseButton(button:Int):Bool {
        return GNativeUnityOverridableInput.BaseInput.GetMouseButton(button);
    }

    public function getMousePosition():Vector2 {
        return GNativeUnityOverridableInput.BaseInput.mousePosition;
    }

    public function getMouseScrollDelta():Vector2 {
        return GNativeUnityOverridableInput.BaseInput.mouseScrollDelta;
    }

    public function getKeyDown(name:String):Bool {
        throw createNotSupportedException("getKeyDown");
    }

    public function getKeyUp(name:String):Bool {
        throw createNotSupportedException("getKeyUp");
    }

    public function getKey(name:String):Bool {
        throw createNotSupportedException("getKey");
    }

    private function createNotSupportedException(methodName:String):NotSupportedException {
        return new NotSupportedException("Unity (overridable) input doesn't supporte");
    }
}