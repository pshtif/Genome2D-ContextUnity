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
import haxe.io.Encoding;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;

class GFileInput {

    private var _fileInput:FileInput;
    private var _length:UInt;

    public function new(p_path:String):Void
    {
        _fileInput = File.read(p_path, true);
        _fileInput.bigEndian = true;
        _fileInput.seek(0, FileSeek.SeekEnd);
        _length = _fileInput.tell();
        _fileInput.seek(0, FileSeek.SeekBegin);
    }

    public var length(get, never):UInt;

    private function get_length():UInt
    {
        return _length;
    }

    public var bigEndian(get, set):Bool;

    private function get_bigEndian():Bool
    {
        return _fileInput.bigEndian;
    }

    private function set_bigEndian(value:Bool):Bool
    {
        _fileInput.bigEndian = value;
        
        return value;
    }

    public function close():Void
    {
        if (_fileInput != null) {
            _fileInput.close();
            _fileInput = null;
        }
    }

    public function readUInt8():UInt
    {
        return _fileInput.readByte();
    }

    public function readInt8():Int
    {
        return _fileInput.readInt8();
    }

    public function readUInt16():UInt
    {
        return _fileInput.readUInt16();
    }

    public function readInt16():Int
    {
        return _fileInput.readInt16();
    }

    public function readUInt32():UInt
    {
        var ch1 = readUInt8();
        var ch2 = readUInt8();
        var ch3 = readUInt8();
        var ch4 = readUInt8();

        if (_fileInput.bigEndian) {
            return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
        } else {
            return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
        }
    }

    public function readInt32():Int
    {
        return _fileInput.readInt32();
    }

    public function readBytes(offset:UInt, length:UInt):Bytes
    {
        var result:Bytes = Bytes.alloc(length);
        _fileInput.readBytes(result, offset, length);
        return result;
    }

    public function readUTFBytes(length:UInt):String
    {
        return _fileInput.readString(length, Encoding.UTF8);
    }

    public function readUTF():String
    {
        return readUTFBytes(_fileInput.readUInt16());
    }
}