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
        protected Vector2[] _uvs;
        protected int[] _indices;
        protected Color[] _colors;
        
        protected List<Material> _materials;
        protected int _currentBatchIndex = 0;
        protected int _quadIndex = 0;

        protected Texture _lastTexture;

        public GNativeUnityContext(MonoBehaviour p_wrapper)
        {
            _wrapper = p_wrapper;
            _meshes = new List<Mesh>();
            _materials = new List<Material>();

            _vertices = new Vector3[4 * MAX_BATCH_SIZE];
            _uvs = new Vector2[4 * MAX_BATCH_SIZE];
            _indices = new int[6 * MAX_BATCH_SIZE];
            _colors = new Color[4 * MAX_BATCH_SIZE];
            for (int i = 0; i < MAX_BATCH_SIZE; i++)
            {
                _vertices[i * 4] = new Vector3(0, 1, 0);
                _vertices[i * 4 + 1] = new Vector3(0, 0, 0);
                _vertices[i * 4 + 2] = new Vector3(1, 0, 0);
                _vertices[i * 4 + 3] = new Vector3(1, 1, 0);
                
                _uvs[i * 4] = new Vector2(0, 1);
                _uvs[i * 4 + 1] = new Vector2(0, 0);
                _uvs[i * 4 + 2] = new Vector2(1, 0);
                _uvs[i * 4 + 3] = new Vector2(1, 1);
                
                _indices[i * 6] = i * 4;
                _indices[i * 6 + 1] = i * 4 + 1;
                _indices[i * 6 + 2] = i * 4 + 2;

                _indices[i * 6 + 3] = i * 4;
                _indices[i * 6 + 4] = i * 4 + 2;
                _indices[i * 6 + 5] = i * 4 + 3;

                _colors[i * 4] = new Color32(1, 1, 1, 1);
                _colors[i * 4 + 1] = new Color32(1, 1, 1, 1);
                _colors[i * 4 + 2] = new Color32(1, 1, 1, 1);
                _colors[i * 4 + 3] = new Color32(1, 1, 1, 1);
            }
            
            for (int mi = 0; mi < 200; mi++)
            {
                Mesh mesh = new Mesh();
                mesh.MarkDynamic();

                _meshes.Add(mesh);

                Material material = new Material(Shader.Find("Genome2D/UnlitShader"));
                _materials.Add(material);
            }
        }

        public void Begin()
        {
            _currentBatchIndex = 0;
            _meshes[_currentBatchIndex].Clear();
        }

        public void Draw(Texture p_texture, BlendMode p_blendMode, float p_x, float p_y, float p_scaleX, float p_scaleY,
            float p_rotation, float p_red, float p_green, float p_blue, float p_alpha, float p_u, float p_v, float p_uScale,
            float p_vScale, float p_textureWidth, float p_textureHeight, float p_texturePivotX, float p_texturePivotY)
        {
            if (_lastTexture != null && _lastTexture != p_texture)
            {
                FlushRenderer();
            }
            
            Mesh mesh = _meshes[_currentBatchIndex];
            Material material = _materials[_currentBatchIndex];
            material.mainTexture = p_texture;
            _lastTexture = p_texture;

            float tx;
            float rtx;
            float ty;
            float rty;
            float cos = 1;
            float sin = 0;

            if (p_rotation != 0)
            {
                cos = Mathf.Cos(p_rotation);
                sin = Mathf.Sin(p_rotation);
            }

            tx = p_scaleX * (-p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (-p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }

            _vertices[_quadIndex * 4].x = p_x + tx;
            _vertices[_quadIndex * 4].y = p_y + ty;

            tx = p_scaleX * (-p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }

            _vertices[_quadIndex * 4 + 1].x = p_x + tx;
            _vertices[_quadIndex * 4 + 1].y = p_y + ty;

            tx = p_scaleX * (p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }
                 
            _vertices[_quadIndex * 4 + 2].x = p_x + tx;
            _vertices[_quadIndex * 4 + 2].y = p_y + ty;

            tx = p_scaleX * (p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (-p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }
            
            _vertices[_quadIndex * 4 + 3].x = p_x + tx;
            _vertices[_quadIndex * 4 + 3].y = p_y + ty;

            _uvs[_quadIndex * 4].x = p_u;
            _uvs[_quadIndex * 4].y = 1 - p_v;
            _uvs[_quadIndex * 4 + 1].x = p_u;
            _uvs[_quadIndex * 4 + 1].y = 1 - (p_v + p_vScale);
            _uvs[_quadIndex * 4 + 2].x = p_u + p_uScale;
            _uvs[_quadIndex * 4 + 2].y = 1 - (p_v + p_vScale);
            _uvs[_quadIndex * 4 + 3].x = p_u + p_uScale;
            _uvs[_quadIndex * 4 + 3].y = 1 - p_v;

            _colors[_quadIndex * 4].r = p_red;
            _colors[_quadIndex * 4].g = p_green;
            _colors[_quadIndex * 4].b = p_blue;
            _colors[_quadIndex * 4].a = p_alpha;
            
            _colors[_quadIndex * 4 + 1].r = p_red;
            _colors[_quadIndex * 4 + 1].g = p_green;
            _colors[_quadIndex * 4 + 1].b = p_blue;
            _colors[_quadIndex * 4 + 1].a = p_alpha;
            
            _colors[_quadIndex * 4 + 2].r = p_red;
            _colors[_quadIndex * 4 + 2].g = p_green;
            _colors[_quadIndex * 4 + 2].b = p_blue;
            _colors[_quadIndex * 4 + 2].a = p_alpha;
            
            _colors[_quadIndex * 4 + 3].r = p_red;
            _colors[_quadIndex * 4 + 3].g = p_green;
            _colors[_quadIndex * 4 + 3].b = p_blue;
            _colors[_quadIndex * 4 + 3].a = p_alpha;
            

            _quadIndex++;
            
            if (_quadIndex >= MAX_BATCH_SIZE) FlushRenderer();
        }
        
        
        
        public void FlushRenderer()
        {
            if (_quadIndex > 0)
            {
                Mesh mesh = _meshes[_currentBatchIndex];

                // If we are not separating renderer from batch limit set this here
                Vector3[] cv = new Vector3[_quadIndex * 4];
                Array.Copy(_vertices, 0, cv, 0, _quadIndex * 4);
                mesh.vertices = cv;

                int[] ci = new int[_quadIndex * 6];
                Array.Copy(_indices, 0, ci, 0, _quadIndex*6);
                mesh.triangles = ci;

                Vector2[] cu = new Vector2[_quadIndex * 4];
                Array.Copy(_uvs, 0, cu, 0, _quadIndex * 4);
                mesh.uv = cu;
                Material material = _materials[_currentBatchIndex];
                
                Color[] cc = new Color[_quadIndex * 4];
                Array.Copy(_colors, 0, cc, 0, _quadIndex * 4);
                mesh.colors = cc;

                Graphics.DrawMesh(mesh, new Vector3(0, 0, 0), Quaternion.identity, material, 0);
                
                _quadIndex = 0;
            }

            _currentBatchIndex++;
            _meshes[_currentBatchIndex].Clear();
            _lastTexture = null;
        }
    }
}