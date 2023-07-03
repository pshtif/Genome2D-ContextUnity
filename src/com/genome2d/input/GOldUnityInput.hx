package com.genome2d.input;

import cs.NativeArray;
import unityengine.*;

class GOldUnityInput implements IGUnityInput {

    public function new() {
    }

    public function getDeviceOrientation():DeviceOrientation {
        return Input.deviceOrientation;
    }

    public function getTouchCount():Int {
        return Input.touchCount;
    }

    public function getTouch(index:Int):Touch {
        return Input.GetTouch(index);
    }

    public function getTouches():NativeArray<Touch> {
        return Input.touches;
    }

    public function getMouseButtonDown(button:Int):Bool {
        return Input.GetMouseButtonDown(button);
    }

    public function getMouseButtonUp(button:Int):Bool {
        return Input.GetMouseButtonUp(button);
    }

    public function getMouseButton(button:Int):Bool {
        return Input.GetMouseButton(button);
    }

    public function getMousePosition():Vector3 {
        return Input.mousePosition;
    }

    public function getMouseScrollDelta():Vector2 {
        return Input.mouseScrollDelta;
    }

    public function getKeyDown(name:String):Bool {
        return Input.GetKeyDown(name);
    }

    public function getKeyUp(name:String):Bool {
        return Input.GetKeyUp(name);
    }

    public function getKey(name:String):Bool {
        return Input.GetKey(name);
    }
}