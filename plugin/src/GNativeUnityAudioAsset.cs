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
    public class GNativeUnityAudioAsset
    {
        protected MonoBehaviour _wrapper;
        protected Action<string> _loaded;

        public AudioClip audioClip;
        
        public GNativeUnityAudioAsset(MonoBehaviour p_wrapper, Action<string> p_loaded)
        {
            _wrapper = p_wrapper;
            _loaded = p_loaded;
        }
        
        public void Load(string p_url)
        {
            if (p_url.IndexOf("http") != 0)
            {
                audioClip = Resources.Load<AudioClip>(p_url);
                if (audioClip == null)
                {
                    audioClip = Resources.Load<AudioClip>(p_url.Substring(0, p_url.LastIndexOf(".")));
                }

                if (audioClip != null)
                {
                    _loaded(p_url);
                }
                else
                {
                    Debug.Log("Asset "+ p_url +" not found.");
                }
            }    
            else
            {
                _wrapper.StartCoroutine(GetAudio(p_url));   
            }
        }
        
        IEnumerator GetAudio(string p_url)
        {
            // Tries MPEG which is MP2/MP3 other support not implemented yet
            using (UnityWebRequest uwr = UnityWebRequestMultimedia.GetAudioClip(p_url, AudioType.MPEG))
            {
                yield return uwr.SendWebRequest();

                if (uwr.isNetworkError || uwr.isHttpError)
                {
                    Debug.Log(uwr.error);
                }
                else
                {
                    audioClip = DownloadHandlerAudioClip.GetContent(uwr);
                    _loaded(p_url);
                }
            }
        }
    }
}