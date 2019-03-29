using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

namespace UnityTestLibrary
{
    public class GNativeUnityAsset
    {
        protected MonoBehaviour _wrapper;
        protected Action<string> _loaded;
        
        public GNativeUnityAsset(MonoBehaviour p_wrapper, Action<string> p_loaded)
        {
            _wrapper = p_wrapper;
            _loaded = p_loaded;
        }
        
        public void Load(string p_url)
        {
            _wrapper.StartCoroutine(GetTexture(p_url));
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
                    _loaded(p_url);
                    // Get downloaded asset bundle
                    //texture = DownloadHandlerTexture.GetContent(uwr);
                    MeshRenderer mr = _wrapper.GetComponentInChildren<MeshRenderer>();
                    mr.sharedMaterials[0].mainTexture = DownloadHandlerTexture.GetContent(uwr);
                }
            }
        }
    }
}