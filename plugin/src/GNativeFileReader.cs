using System;
using System.Collections;
using System.IO;
using UnityEngine;
using System.Threading.Tasks;

namespace Genome2DNativePlugin
{
    public class GNativeFileReader
    {
        private Action<GNativeFileReader> _onRead;
        private Action<GNativeFileReader> _onError;
        
        private FileStream _fileStream;
        private byte[] _result;
        private string _error;

        public static byte[] ReadSync(string p_filePath)
        {
            return File.ReadAllBytes(p_filePath);
        }
        
        public static GNativeFileReader ReadAsync(string p_filePath, Action<GNativeFileReader> p_onRead, Action<GNativeFileReader> p_onError)
        {
            return new GNativeFileReader(p_filePath, p_onRead, p_onError);
        }

        private GNativeFileReader(string p_filePath, Action<GNativeFileReader> p_onRead, Action<GNativeFileReader> p_onError)
        {
            _onRead = p_onRead;
            _onError = p_onError;

            ReadFile(p_filePath);
        }
        
        public byte[] Result
        {
            get { return _result; }
        }
        
        public string Error
        {
            get { return _error; }
        }
        
        public void Close()
        {
            _onRead = null;
            _onError = null;
            _result = null;
            _error = null;
            
            if (_fileStream != null)
            {
                _fileStream.Dispose();
                _fileStream = null;
            }
        }
        
        private async void ReadFile(string p_filePath)
        {
            try
            {
                _fileStream = File.Open(p_filePath, FileMode.Open);
                
                var bytesCount = (int)_fileStream.Length;
                _result = new byte[bytesCount];
                
                await _fileStream.ReadAsync(_result, 0, bytesCount);
                
                if (_onRead != null) {
                    _onRead(this);
                }
            }
            catch (Exception exception)
            {
                _error = exception.Message;
                _result = null;
                
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