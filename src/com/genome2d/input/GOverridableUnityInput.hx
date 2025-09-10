package com.genome2d.input;

import com.genome2d.input.Exception;
import cs.NativeArray;
import genome2dnativeplugin.*;
import unityengine.*;

class GOverridableUnityInput implements IGUnityInput {

    // Simulate Input Logic
    // Simulate Input Logic is manipulated via reflection, don't change signatures
    public static var simulatedTouches:List<Touch> = new List<Touch>();

    static function get_touch_count():Int {
        if (simulatedTouches.isEmpty()) {
            return GNativeUnityOverridableInput.BaseInput.touchCount;
        }
        return 1;
    }

    static function get_touches():Array<Touch> {
        var touchCount = get_touch_count();
        var tempTouches = new Array<Touch>();
        for (i in 0...touchCount) {
            tempTouches.push(get_touch(i, false));
        }
        return tempTouches;
    }

    public static function get_touch(id:Int, ?eatTouch:Bool = true):Touch {
        if (simulatedTouches.isEmpty()) {
            return GNativeUnityOverridableInput.BaseInput.GetTouch(id);
        }

        // currently two finger gestures are not supported for simulating
        if (id >= 1) {
            return GNativeUnityOverridableInput.BaseInput.GetTouch(id);
        }

        if (eatTouch) {
            return simulatedTouches.pop(); // remove first
        }
        return simulatedTouches.first(); // peek
    }
    // End Simulate Input Logic

    public function new() {
    }

    public function getDeviceOrientation():DeviceOrientation {
        throw createNotSupportedException("getDeviceOrientation");
    }

    public function getTouchCount():Int {
        return get_touch_count();
    }

    public function getTouch(index:Int):Touch {
        return get_touch(index, false);
    }

    public function getTouches():NativeArray<Touch> {
        var arr = get_touches();
        var nativeArr = new NativeArray<Touch>(arr.length);
        for (i in 0...arr.length) {
            nativeArr[i] = arr[i];
        }
        return nativeArr;
    }

    public function getMouseButtonDown(button:Int):Bool {
        return (get_touch_count() > 0 && get_touch(0, false).phase == TouchPhase.Began) || 
        GNativeUnityOverridableInput.BaseInput.GetMouseButtonDown(button);
    }

    public function getMouseButtonUp(button:Int):Bool {
        return (get_touch_count() > 0 && get_touch(0, false).phase == TouchPhase.Ended) || 
        GNativeUnityOverridableInput.BaseInput.GetMouseButtonUp(button);
    }

    public function getMouseButton(button:Int):Bool {
        return (get_touch_count() > 0 && (
                get_touch(0, false).phase == TouchPhase.Began || 
                get_touch(0, false).phase == TouchPhase.Moved || 
                get_touch(0, false).phase == TouchPhase.Stationary)
            ) || 
        GNativeUnityOverridableInput.BaseInput.GetMouseButton(button);
    }

    public function getMousePosition():Vector2 {
        return (get_touch_count() > 0) ? get_touch(0, false).position : GNativeUnityOverridableInput.BaseInput.mousePosition;
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