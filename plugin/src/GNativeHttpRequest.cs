using System;
using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace Genome2DNativePlugin
{
    public class GNativeHttpRequest
    {
        protected MonoBehaviour _wrapper;
        protected Action<GNativeHttpRequest> _onLoad;
        protected Action<GNativeHttpRequest> _onError;
        
        private UnityWebRequest _uwr;
        
        public GNativeHttpRequest(MonoBehaviour p_wrapper, Action<GNativeHttpRequest> p_onLoad, Action<GNativeHttpRequest> p_onError)
        {
            _wrapper = p_wrapper;
            _onLoad = p_onLoad;
            _onError = p_onError;
        }
        
        private string GetUrlWithQueryParams(string p_url, string[][] p_queryParams)
        {
            if (p_queryParams.Length == 0)
            {
                return p_url;
            }
            
            for (int i = 0; i < p_queryParams.Length; i++) 
            {
                p_url += ((i == 0) ? "?" : "&") + p_queryParams[i][0] + "=" +  p_queryParams[i][1];
            }
            
            return p_url;
        }
        
        public void SendGetRequest(string p_url, string[][] p_headers, string[][] p_queryParams)
        {
            _wrapper.StartCoroutine(SendRequest(UnityWebRequest.Get(GetUrlWithQueryParams(p_url, p_queryParams)), p_headers));
        }
        
        public void SendPostRequest(string p_url, string[][] p_headers, string[][] p_queryParams, string[][] p_formParams)
        {
            WWWForm form = new WWWForm();
            for (int i = 0; i < p_formParams.Length; i++)
            {
                form.AddField(p_formParams[i][0], p_formParams[i][1]);
            }
            
            _wrapper.StartCoroutine(SendRequest(UnityWebRequest.Post(GetUrlWithQueryParams(p_url, p_queryParams), form), p_headers));
        }
        
        public void SendRawPostRequest(string p_url, string[][] p_headers, string[][] p_queryParams, string p_data)
        {
            UnityWebRequest request = new UnityWebRequest(GetUrlWithQueryParams(p_url, p_queryParams), "POST");
            request.uploadHandler = (UploadHandler) new UploadHandlerRaw(Encoding.UTF8.GetBytes(p_data));
            request.downloadHandler = (DownloadHandler) new DownloadHandlerBuffer();
            _wrapper.StartCoroutine(SendRequest(request, p_headers));
        }
        
        public string ResponseText
        {
            get { return _uwr.downloadHandler.text; }
        }
        
        public byte[] ResponseData
        {
            get { return _uwr.downloadHandler.data; }
        }
        
        public int ResponseCode
        {
            get { return (int) _uwr.responseCode; }
        }

        public string GetResponseHeader(string p_name)
        {
            return _uwr.GetResponseHeader(p_name);
        }

        public string Error
        {
            get { return _uwr.error; }
        }
        
        public void Abort()
        {
            if (_uwr != null) {
                _uwr.Abort();
            }
        }
        
        public void Close()
        {            
            if (_uwr != null)
            {
                _uwr.Dispose();
                _uwr = null;
            }
        }
        
        private IEnumerator SendRequest(UnityWebRequest p_uwr, string[][] p_headers)
        {
            _uwr = p_uwr;
            
            for (int i = 0; i < p_headers.Length; i++) 
            {
                _uwr.SetRequestHeader(p_headers[i][0], p_headers[i][1]);
            }
            
            yield return _uwr.SendWebRequest();

            if (_uwr != null)
            {
                if (_uwr.isNetworkError || _uwr.isHttpError || !_uwr.isDone)
                {
                    _onError(this);
                }
                else
                {
                    _onLoad(this);
                }
            }
            
            Close();
        }
    }
}