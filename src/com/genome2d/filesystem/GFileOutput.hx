/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */

package com.genome2d.filesystem;

import haxe.io.BytesData;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import haxe.io.Encoding;
import genome2dnativeplugin.GNativeFileWriter;

class GFileOutput {

    private var _bigEndian:Bool;
    private var _onFlush:Void -> Void;
    private var _onError:String -> Void;
    private var _path:String;
    private var _async:Bool;
    
    private var _bytesBuffer:BytesBuffer;
    private var _nativeWriter:GNativeFileWriter;

    public function new(p_path:String, p_async:Bool, p_onFlush:Void -> Void, p_onError:String -> Void):Void
    {
        _path = p_path;
        _async = p_async;
        _onFlush = p_onFlush;
        _onError = p_onError;
        
        _bigEndian = true;
        _bytesBuffer = new BytesBuffer();
    }
    
    private function onNativeFlush(loader:GNativeFileWriter):Void
    {
        _bytesBuffer = null;
        
        if (_nativeWriter != null) {
            _nativeWriter.Close();
            _nativeWriter = null;
        }

        if (_onFlush != null) {
            _onFlush();
        }
    }

    private function onNativeError(loader:GNativeFileWriter):Void
    {
        _bytesBuffer = null;

        if (_nativeWriter != null) {
            _nativeWriter.Close();
            _nativeWriter = null;
        }
        
        if (_onError != null) {
            _onError(loader.Error);
        }
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
    
    public function flush():Void
    {
        var bytesCount:Int = _bytesBuffer.length;
        var bytesData:BytesData = _bytesBuffer.getBytes().getData();
        _bytesBuffer = null;

        if (_async) {
            _nativeWriter = GNativeFileWriter.WriteAsync(_path, bytesData, bytesCount, onNativeFlush, onNativeError);
        } else {
            GNativeFileWriter.WriteSync(_path, bytesData, bytesCount);
        }
    }
    
    public function close():Void
    {
        _bytesBuffer = null;
        _path = null;
        _onFlush = null;
        _onError = null;
        
        if (_nativeWriter != null) {
            _nativeWriter.Close();
            _nativeWriter = null;
        }
    }

    public function writeUInt8(p_value:UInt):Void
    {
        return _bytesBuffer.addByte(p_value);
    }

    public function writeInt8(p_value:Int):Void
    {
        return _bytesBuffer.addByte(p_value);
    }

    public function writeUInt16(p_value:UInt):Void
    {
        if (_bigEndian) {
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
            _bytesBuffer.addByte(p_value & 0xFF);
        } else {
            _bytesBuffer.addByte(p_value & 0xFF);
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
        }
    }

    public function writeInt16(p_value:Int):Void
    {
        if (_bigEndian) {
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
            _bytesBuffer.addByte(p_value & 0xFF);
        } else {
            _bytesBuffer.addByte(p_value & 0xFF);
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
        }
    }

    public function writeUInt32(p_value:UInt):Void
    {
        if (_bigEndian) {
            _bytesBuffer.addByte((p_value >> 24) & 0xFF);
            _bytesBuffer.addByte((p_value >> 16) & 0xFF);
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
            _bytesBuffer.addByte(p_value & 0xFF);
        } else {
            _bytesBuffer.addByte(p_value & 0xFF);
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
            _bytesBuffer.addByte((p_value >> 16) & 0xFF);
            _bytesBuffer.addByte((p_value >> 24) & 0xFF);
        }
    }

    public function writeInt32(p_value:Int):Void
    {
        if (_bigEndian) {
            _bytesBuffer.addByte((p_value >> 24) & 0xFF);
            _bytesBuffer.addByte((p_value >> 16) & 0xFF);
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
            _bytesBuffer.addByte(p_value & 0xFF);
        } else {
            _bytesBuffer.addByte(p_value & 0xFF);
            _bytesBuffer.addByte((p_value >> 8) & 0xFF);
            _bytesBuffer.addByte((p_value >> 16) & 0xFF);
            _bytesBuffer.addByte((p_value >> 24) & 0xFF);
        }
    }

    public function writeBytes(p_bytes:Bytes, p_offset:UInt, p_length:UInt):Void
    {
        _bytesBuffer.addBytes(p_bytes, p_offset, p_length);
    }

    public function writeUTFBytes(p_value:String):Void
    {
        _bytesBuffer.addString(p_value, Encoding.UTF8);
    }

    public function writeUTF(p_value:String):Void
    {
        writeUInt16(p_value.length);
        writeUTFBytes(p_value);
    }
}