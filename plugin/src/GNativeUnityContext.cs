using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.Rendering;

namespace Genome2DNativePlugin
{
    public class GNativeUnityContext
    {
        public const int MAX_BATCH_SIZE = 10000; 
        
        protected MonoBehaviour _wrapper;
        protected List<Mesh> _meshes;
        protected Vector3[] _vertices;
        protected List<Material> _materials;
        protected int _currentBatchIndex = 0;
        protected int _quadIndex = 0;

        public GNativeUnityContext(MonoBehaviour p_wrapper)
        {
            _wrapper = p_wrapper;
            _meshes = new List<Mesh>();
            _materials = new List<Material>();

            for (int mi = 0; mi < 200; mi++)
            {
                Mesh mesh = new Mesh();

                _vertices = new Vector3[4 * MAX_BATCH_SIZE];
                for (int i = 0; i < MAX_BATCH_SIZE; i++)
                {
                    _vertices[i * 4] = new Vector3(0, 0, 0);
                    _vertices[i * 4 + 1] = new Vector3(1, 0, 0);
                    _vertices[i * 4 + 2] = new Vector3(0, 1, 0);
                    _vertices[i * 4 + 3] = new Vector3(1, 1, 0);
                }

                mesh.vertices = _vertices;

                int[] tri = new int[6 * MAX_BATCH_SIZE];
                for (int i = 0; i < MAX_BATCH_SIZE; i++)
                {
                    tri[i * 6] = i * 4;
                    tri[i * 6 + 1] = i * 4 + 2;
                    tri[i * 6 + 2] = i * 4 + 1;

                    tri[i * 6 + 3] = i * 4 + 2;
                    tri[i * 6 + 4] = i * 4 + 3;
                    tri[i * 6 + 5] = i * 4 + 1;
                }

                mesh.triangles = tri;

                /*
                Vector3[] normals = new Vector3[4];
                normals[0] = -Vector3.forward;
                normals[1] = -Vector3.forward;
                normals[2] = -Vector3.forward;
                normals[3] = -Vector3.forward;
                mesh.normals = normals;
                /**/
                Vector2[] uv = new Vector2[4 * MAX_BATCH_SIZE];
                for (int i = 0; i < MAX_BATCH_SIZE; i++)
                {
                    uv[i * 4] = new Vector2(0, 0);
                    uv[i * 4 + 1] = new Vector2(1, 0);
                    uv[i * 4 + 2] = new Vector2(0, 1);
                    uv[i * 4 + 3] = new Vector2(1, 1);
                }

                mesh.uv = uv;

                _meshes.Add(mesh);

                Material material = new Material(Shader.Find("Genome2D/UnlitShader"));
                _materials.Add(material);
            }
        }

        public void Begin()
        {
            Debug.Log(_currentBatchIndex);
            _currentBatchIndex = 0;
        }

        public void Draw(Texture p_texture, BlendMode p_blendMode, float p_x, float p_y, float p_scaleX, float p_scaleY,
            float p_rotation, float p_red, float p_green, float p_blue, float p_alpha, Texture p_filter)
        {
            Mesh mesh = _meshes[_currentBatchIndex];
            Material material = _materials[_currentBatchIndex];
            material.mainTexture = p_texture;

            _vertices[_quadIndex * 4].x = p_x - p_scaleX * p_texture.width / 2;
            _vertices[_quadIndex * 4].y = p_y - p_scaleY * p_texture.height / 2;
            _vertices[_quadIndex * 4 + 1].x = p_x + p_scaleX * p_texture.width / 2;
            _vertices[_quadIndex * 4 + 1].y = p_y - p_scaleY * p_texture.height / 2;
            _vertices[_quadIndex * 4 + 2].x = p_x - p_scaleX * p_texture.width / 2;
            _vertices[_quadIndex * 4 + 2].y = p_y + p_scaleY * p_texture.height / 2;
            _vertices[_quadIndex * 4 + 3].x = p_x + p_scaleX * p_texture.width / 2;
            _vertices[_quadIndex * 4 + 3].y = p_y + p_scaleY * p_texture.height / 2;

            _quadIndex++;
            
            if (_quadIndex >= MAX_BATCH_SIZE) FlushRenderer();
        }
        
        public void FlushRenderer()
        {
            if (_quadIndex > 0)
            {
                Mesh mesh = _meshes[_currentBatchIndex];

                // If we are not separating renderer from batch limit set this here
                mesh.vertices = _vertices;
                Material material = _materials[_currentBatchIndex];

                Graphics.DrawMesh(mesh, new Vector3(0, 0, 0), Quaternion.identity, material, 0);
                
                _quadIndex = 0;
            }

            _currentBatchIndex++;
        }
    }
}