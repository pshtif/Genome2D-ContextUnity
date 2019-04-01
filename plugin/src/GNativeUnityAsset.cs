using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

namespace Genome2DNativePlugin
{
    public class GNativeUnityAsset
    {
        protected MonoBehaviour _wrapper;
        protected Action<string> _loaded;

        public Texture texture;
        
        public GNativeUnityAsset(MonoBehaviour p_wrapper, Action<string> p_loaded)
        {
            _wrapper = p_wrapper;
            _loaded = p_loaded;
        }
        
        public void Load(string p_url)
        {
            if (p_url.IndexOf("Resources/") == 0)
            {
                Debug.Log(p_url.Substring(10, p_url.Length-14));
                texture = Resources.Load<Texture2D>(p_url.Substring(10, p_url.Length-14));
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
                    
                    // This was just direct texture test
                    //MeshRenderer mr = _wrapper.GetComponentInChildren<MeshRenderer>();
                    //mr.sharedMaterials[0].mainTexture = DownloadHandlerTexture.GetContent(uwr);
                }
            }
        }
    }
}