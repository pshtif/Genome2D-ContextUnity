/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */

package com.genome2d.filesystem;

import haxe.io.Bytes;
import genome2dnativeplugin.GNativeFileReader;

class GFileInput {

    private var _bytes:Bytes;
    private var _bigEndian:Bool;
    private var _position:Int;

    private var _nativeLoader:GNativeFileReader;
    private var _onReady:Void -> Void;
    private var _onError:String -> Void;
    
    public function new(p_path:String, p_async:Bool, p_onReady:Void -> Void, p_onError:String -> Void):Void
    {
        _onReady = p_onReady;
        _onError = p_onError;
        
        _bigEndian = true;
        _position = 0;
        
        if (p_async) {
            _nativeLoader = GNativeFileReader.ReadAsync(p_path, onNativeReady, onNativeError);
        } else {
            _bytes = Bytes.ofData(GNativeFileReader.ReadSync(p_path));
        }
    }
    
    private function onNativeReady(reader:GNativeFileReader):Void
    {
        _bytes = Bytes.ofData(reader.Result);
        
        if (_nativeLoader != null) {
            _nativeLoader.Close();
            _nativeLoader = null;
        }
        
        if (_onReady != null) {
            _onReady();
        }
    }

    private function onNativeError(reader:GNativeFileReader):Void
    {
        _bytes = null;

        if (_nativeLoader != null) {
            _nativeLoader.Close();
            _nativeLoader = null;
        }

        if (_onError != null) {
            _onError(reader.Error);
        }
    }

    public var length(get, never):UInt;

    private function get_length():UInt
    {
        return _bytes.length;
    }

    public var bigEndian(get, set):Bool;

    private function get_bigEndian():Bool
    {
        return _bigEndian;
    }

    private function set_bigEndian(value:Bool):Bool
    {
        _bigEndian = value;
        
        return value;
    }

    public function close():Void
    {
        _onReady = null;
        _onError = null;
        
        if (_nativeLoader != null) {
            _nativeLoader.Close();
            _nativeLoader = null;
        }
        
        _bytes = null;
    }

    public function readUInt8():UInt
    {
        return _bytes.get(_position++);
    }

    public function readInt8():Int
    {
        var value = _bytes.get(_position++);
        
        if (value & 0x80 != 0) {
            return value - 0x100;
        } else {
            return value;
        }
    }

    public function readUInt16():UInt
    {
        var ch1 = readUInt8();
        var ch2 = readUInt8();

        if (_bigEndian) {
            return (ch1 << 8) | ch2;
        } else {
            return (ch2 << 8) + ch1;
        }
    }

    public function readInt16():Int
    {
        var ch1 = readUInt8();
        var ch2 = readUInt8();

        var value;

        if (_bigEndian) {
            value = ((ch1 << 8) | ch2);
        } else {
            value = ((ch2 << 8) | ch1);
        }

        if ((value & 0x8000) != 0) {
            return value - 0x10000;
        } else {
            return value;
        }
    }

    public function readUInt32():UInt
    {
        var ch1 = readUInt8();
        var ch2 = readUInt8();
        var ch3 = readUInt8();
        var ch4 = readUInt8();

        if (_bigEndian) {
            return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
        } else {
            return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
        }
    }

    public function readInt32():Int
    {
        var ch1 = readUInt8();
        var ch2 = readUInt8();
        var ch3 = readUInt8();
        var ch4 = readUInt8();

        if (_bigEndian) {
            return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
        } else {
            return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
        }
    }

    public function readBytes(offset:UInt, length:UInt):Bytes
    {
        return this._bytes.sub(offset, length);
    }

    public function readUTFBytes(length:UInt):String
    {
        this._position += length;

        return this._bytes.getString(this._position - length, length);
    }

    public function readUTF():String
    {
        return readUTFBytes(readUInt16());
    }
}