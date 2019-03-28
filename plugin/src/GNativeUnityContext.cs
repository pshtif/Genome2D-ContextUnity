using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

namespace UnityTestLibrary
{
    public class GNativeUnityContext
    {
        public int c;
        protected MonoBehaviour _wrapper;
        public Texture texture;

        public GNativeUnityContext(MonoBehaviour p_wrapper)
        {
            _wrapper = p_wrapper;
        }

        public void AddValues(int a, int b) {
            c = a + b;  
        }
    
        public static int GenerateRandom(int min, int max) {
            System.Random rand = new System.Random();
            return rand.Next(min, max);
        }

        public void LoadTexture(string p_url)
        {
            _wrapper.StartCoroutine(GetText(p_url));
        }
        
        IEnumerator GetText(string p_url)
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
                    // Get downloaded asset bundle
                    texture = DownloadHandlerTexture.GetContent(uwr);
                    MeshRenderer mr = _wrapper.GetComponentInChildren<MeshRenderer>();
                    mr.sharedMaterials[0].mainTexture = texture;
                }
            }
        }
    }
}