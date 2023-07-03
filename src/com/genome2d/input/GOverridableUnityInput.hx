/*
package com.genome2d.input;

import com.genome2d.input.Exception;
import cs.NativeArray;
import unityengine.*;

class GOverridableUnityInput implements IGUnityInput {

    private var inputModule:StandaloneInputModule;

    public function new() {
        inputModule = EventSystem.current.GetComponent(StandaloneInputModule);
    }

    public function getDeviceOrientation():DeviceOrientation {
        throw createNotSupportedException("getDeviceOrientation");
    }

    public function getTouchCount():Int {
        return inputModule.input.touchCount;
    }

    public function getTouch(index:Int):Touch {
        return inputModule.input.GetTouch(index);
    }

    public function getTouches():NativeArray<Touch> {
        throw createNotSupportedException("getTouches");
    }

    public function getMouseButtonDown(button:Int):Bool {
        return inputModule.input.GetMouseButtonDown(button);
    }

    public function getMouseButtonUp(button:Int):Bool {
        return inputModule.input.GetMouseButtonUp(button);
    }

    public function getMouseButton(button:Int):Bool {
        return inputModule.input.GetMouseButton(button);
    }

    public function getMousePosition():Vector3 {
        return inputModule.input.mousePosition;
    }

    public function getMouseScrollDelta():Vector2 {
        return inputModule.input.mouseScrollDelta;
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

 */