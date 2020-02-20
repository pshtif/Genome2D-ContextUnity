using System;
using System.Collections;
using System.IO;
using UnityEngine;
using System.Threading.Tasks;

namespace Genome2DNativePlugin
{
    public class GNativeFileWriter
    {
        private Action<GNativeFileWriter> _onFlush;
        private Action<GNativeFileWriter> _onError;
        
        private FileStream _fileStream;
        private string _error;

        public static void WriteSync(string p_filePath, byte[] p_bytes)
        {
            File.WriteAllBytes(p_filePath, p_bytes);
        }
        
        public static GNativeFileWriter WriteAsync(string p_filePath, byte[] p_bytes, Action<GNativeFileWriter> p_onFlush, Action<GNativeFileWriter> p_onError)
        {
            return new GNativeFileWriter(p_filePath, p_bytes, p_onFlush, p_onError);
        }

        private GNativeFileWriter(string p_filePath, byte[] p_bytes, Action<GNativeFileWriter> p_onFlush, Action<GNativeFileWriter> p_onError)
        {
            _onFlush = p_onFlush;
            _onError = p_onError;

            WriteToFile(p_filePath, p_bytes);
        }

        public string Error
        {
            get { return _error; }
        }
        
        public void Close()
        {
            _onFlush = null;
            _onError = null;
            _error = null;
            
            if (_fileStream != null)
            {
                _fileStream.Dispose();
                _fileStream = null;
            }
        }
        
        private async void WriteToFile(string p_filePath, byte[] p_bytes)
        {
            try
            {
                _fileStream = File.Open(p_filePath, FileMode.Create);
                await _fileStream.WriteAsync(p_bytes, 0, p_bytes.Length);
                
                _fileStream.Flush(); 
                
                if (_onFlush != null) {
                    _onFlush(this);
                }
            }
            catch (Exception exception)
            {
                _error = exception.Message;
                
                if (_onError != null) {
                    _onError(this);
                }
            }
            
            if (_fileStream != null)
            {
                _fileStream.Dispose();
                _fileStream = null;
            }
        }
    }
}