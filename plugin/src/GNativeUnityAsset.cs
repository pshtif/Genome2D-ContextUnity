/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
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

        protected bool isBinaryAsset = false;

        public string text;
        public byte[] bytes;
        
        public GNativeUnityAsset(MonoBehaviour p_wrapper, Action<string> p_loaded)
        {
            _wrapper = p_wrapper;
            _loaded = p_loaded;
        }
        
        public void Load(string p_url)
        {
            if (p_url.IndexOf("http") != 0)
            {
                isBinaryAsset = p_url.IndexOf(".bytes") == p_url.Length-6;
                TextAsset ta = Resources.Load<TextAsset>(p_url);
                if (ta == null)
                {
                    ta = Resources.Load<TextAsset>(p_url.Substring(0, p_url.LastIndexOf(".")));
                }

                if (ta != null)
                {
                    if (isBinaryAsset) {
                        bytes = ta.bytes;
                    } else {
                        text = ta.text;
                    }
                    _loaded(p_url);
                }
                else
                {
                    Debug.Log("Asset "+ p_url +" not found.");
                }
            }    
            else
            {
                _wrapper.StartCoroutine(GetData(p_url));   
            }
        }
        
        IEnumerator GetData(string p_url)
        {
            using (UnityWebRequest uwr = UnityWebRequest.Get(p_url))
            {
                yield return uwr.SendWebRequest();

                if (uwr.isNetworkError || uwr.isHttpError)
                {
                    Debug.Log(uwr.error);
                }
                else
                {
                    if (isBinaryAsset) {
                        bytes = uwr.downloadHandler.data;
                    } else {
                        text = uwr.downloadHandler.text;
                    }
                    _loaded(p_url);
                }
            }
        }
    }
}