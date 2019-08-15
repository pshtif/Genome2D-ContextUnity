/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */

package com.genome2d.filesystem;

import cs.system.io.Directory;
import cs.system.io.File;
import sys.FileSystem;
import unityengine.Application;
import unityengine.RuntimePlatform;
import unityengine.WWW;

class GFileSystem {

    public static var applicationStorageDirectory(get, never):String;

    private static function get_applicationStorageDirectory():String
    {
        return Application.persistentDataPath;
    }

    public static var documentsDirectory(get, never):String;

    private static function get_documentsDirectory():String
    {
        return Application.persistentDataPath;
    }

    public static var cacheDirectory(get, never):String;

    private static function get_cacheDirectory():String
    {
        return Application.temporaryCachePath;
    }

    public static var applicationDirectory(get, never):String;

    private static function get_applicationDirectory():String
    {
        if (Application.platform == RuntimePlatform.Android) {
            return Application.temporaryCachePath + "/StreamingAssets/";
        }

        return Application.streamingAssetsPath;
    }

    public static function prepareApplicationDirectory(p_files:Array<String>, p_skipExistingFiles:Bool):Void
    {
        if (Application.platform != RuntimePlatform.Android) {
            return;
        }

        for (file in p_files) {
            if (p_skipExistingFiles && exists(applicationDirectory + "/" + file)) {
                continue;
            }
            var www:WWW = new WWW(Application.streamingAssetsPath + "/" + file);
            while (!www.isDone) {

            }
            GFileSystem.createDirectory(getParent(applicationDirectory + "/" + file));
            File.WriteAllBytes(applicationDirectory + "/" + file, www.bytes);
        }
    }

    public static function isDirectory(p_path:String):Bool
    {
        return FileSystem.isDirectory(p_path);
    }

    public static function createDirectory(p_path:String):Void
    {
        FileSystem.createDirectory(p_path);
    }

    public static function deleteDirectory(p_path:String, p_deleteContents:Bool):Void
    {
        Directory.Delete(p_path, p_deleteContents);
    }

    public static function deleteFile(p_path:String):Void
    {
        FileSystem.deleteFile(p_path);
    }

    @:functionCode("
    #if UNITY_IOS
        if (p_value) { UnityEngine.iOS.Device.SetNoBackupFlag(p_path); } else { UnityEngine.iOS.Device.ResetNoBackupFlag(p_path); }
    #endif
    ")
    public static function preventBackup(p_path:String, p_value:Bool):Void
    { }

    public static function hasTrailingSlash(p_path:String):Bool
    {
        var charAt:String = p_path.charAt(p_path.length - 1);
        return charAt == '/' || charAt == '\\';
    }

    public static function resolvePath(p_parentPath:String, p_path:String):String
    {
        return p_parentPath + (hasTrailingSlash(p_parentPath) ? "" : "/") + p_path;
    }

    public static function exists(p_path:String):Bool
    {
        return FileSystem.exists(p_path);
    }

    public static function getParent(p_path:String):String
    {
        var dirEndIndex:Int = p_path.lastIndexOf("/");
        if (dirEndIndex == -1) {
            dirEndIndex = p_path.lastIndexOf("\\");
        }
        if (dirEndIndex > 0) {
            return p_path.substring(0, dirEndIndex);
        }
        return "/";
    }

    public static function getName(p_path:String):String
    {
        var dirEndIndex:Int = p_path.lastIndexOf("/");
        if (dirEndIndex == -1) {
            dirEndIndex = p_path.lastIndexOf("\\");
        }
        if (dirEndIndex + 1 < p_path.length) {
            return p_path.substring(dirEndIndex + 1);
        }
        return "";
    }

    public static function getRelativePath(p_parentPath:String, p_path:String):String
    {
        return p_path.substring(p_parentPath.length);
    }

    public static function getDirectoryListing(p_path:String):Array<String>
    {
        return FileSystem.readDirectory(p_path);
    }

    public static function openFileForRead(p_path:String):GFileInput
    {
        return new GFileInput(p_path);
    }

    public static function openFileForWrite(p_path:String, p_createPath:Bool):GFileOutput
    {
        if (p_createPath) {
            var parentPath:String = getParent(p_path);
            if (!GFileSystem.exists(parentPath)) {
                GFileSystem.createDirectory(parentPath);
            }
        }

        return new GFileOutput(p_path);
    }
}