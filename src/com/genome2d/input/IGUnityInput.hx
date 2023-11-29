package com.genome2d.input;

import cs.NativeArray;
import unityengine.*;

interface IGUnityInput {
    public function getDeviceOrientation():DeviceOrientation;

    public function getTouchCount():Int;
    public function getTouch(index:Int):Touch;
    public function getTouches():NativeArray<Touch>;

    public function getMouseButtonDown(button:Int):Bool;
    public function getMouseButtonUp(button:Int):Bool;
    public function getMouseButton(button:Int):Bool;
    public function getMousePosition():Vector2;
    public function getMouseScrollDelta():Vector2;

    public function getKeyDown(name:String):Bool;
    public function getKeyUp(name:String):Bool;
    public function getKey(name:String):Bool;
}