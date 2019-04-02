using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

namespace Genome2DNativePlugin
{
    public class GNativeUnityImageAsset
    {
        protected MonoBehaviour _wrapper;
        protected Action<string> _loaded;

        public Texture texture;
        
        public GNativeUnityImageAsset(MonoBehaviour p_wrapper, Action<string> p_loaded)
        {
            _wrapper = p_wrapper;
            _loaded = p_loaded;
        }
        
        public void Load(string p_url)
        {
            if (p_url.IndexOf("http") != 0)
            {
                Debug.Log(p_url.Substring(0, p_url.LastIndexOf(".")));
                texture = Resources.Load<Texture2D>(p_url.Substring(0, p_url.LastIndexOf(".")));
                Debug.Log(texture);
                _loaded(p_url);
            }    
            else
            {
                _wrapper.StartCoroutine(GetTexture(p_url));   
            }
        }
        
        IEnumerator GetTexture(string p_url)
        {
            using (UnityWebRequest uwr = UnityWebRequestTexture.GetTexture(p_url))
            {
                yield return uwr.SendWebRequest();

                if (uwr.isNetworkError || uwr.isHttpError)
                {
                    Debug.Log(uwr.error);
                }
                else
                {
                    Debug.Log("Loaded");
                    texture = DownloadHandlerTexture.GetContent(uwr);
                    _loaded(p_url);
                }
            }
        }
    }
}