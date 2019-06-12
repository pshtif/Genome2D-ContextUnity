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
import sys.io.FileOutput;

class GFileOutput {

    private var _fileOutput:FileOutput;

    public function new(p_path:String):Void
    {
        _fileOutput = File.write(p_path, true);
    }

    public function close():Void
    {
        if (_fileOutput != null) {
            _fileOutput.close();
            _fileOutput = null;
        }
    }

    public function writeUInt8(p_value:UInt):Void
    {
        return _fileOutput.writeByte(p_value);
    }

    public function writeInt8(p_value:Int):Void
    {
        return _fileOutput.writeByte(p_value);
    }

    public function writeUInt16(p_value:UInt):Void
    {
        return _fileOutput.writeUInt16(p_value);
    }

    public function writeInt16(p_value:Int):Void
    {
        return _fileOutput.writeInt16(p_value);
    }

    public function writeUInt32(p_value:UInt):Void
    {
        if (_fileOutput.bigEndian) {
            _fileOutput.writeByte((p_value >> 24) & 0xFF);
            _fileOutput.writeByte((p_value >> 16) & 0xFF);
            _fileOutput.writeByte((p_value >> 8) & 0xFF);
            _fileOutput.writeByte(p_value & 0xFF);
        } else {
            _fileOutput.writeByte(p_value & 0xFF);
            _fileOutput.writeByte((p_value >> 8) & 0xFF);
            _fileOutput.writeByte((p_value >> 16) & 0xFF);
            _fileOutput.writeByte((p_value >> 24) & 0xFF);
        }
    }

    public function writeInt32(p_value:Int):Void
    {
        return _fileOutput.writeInt32(p_value);
    }

    public function writeBytes(p_bytes:Bytes, p_offset:UInt, p_length:UInt):Void
    {
        _fileOutput.writeBytes(p_bytes, p_offset, p_length);
    }

    public function writeUTFBytes(p_value:String):Void
    {
        _fileOutput.writeString(p_value, Encoding.UTF8);
    }

    public function writeUTF(p_value:String):Void
    {
        _fileOutput.writeUInt16(p_value.length);
        writeUTFBytes(p_value);
    }
}