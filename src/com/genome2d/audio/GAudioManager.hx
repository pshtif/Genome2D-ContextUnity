package com.genome2d.audio;

import unityengine.*;
import com.genome2d.macros.MGDebug;
import com.genome2d.assets.GAudioAsset;

class GAudioManager
{
    static public function playAudio(p_audio:GAudioAsset, p_volume:Float = 1) {
        AudioSource.PlayClipAtPoint(p_audio.nativeAudio, new Vector3(0, 0, 0), p_volume);
    }
}