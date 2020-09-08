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
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.Rendering;
using com.genome2d.geom;
using Object = UnityEngine.Object;

namespace Genome2DNativePlugin
{
    public class GNativeUnityContext
    {   
        /* URP preparation
        static GNativeUnityContext _instance;

        [RuntimeInitializeOnLoadMethod]
        static void OnProjectLoaded()
        {
            Debug.Log("After Scene is loaded and game is running");
            Application.quitting += Quit;
        }

        static void Quit() {
            RenderPipelineManager.beginFrameRendering -= _instance.OnRender;
        }
        /* */
        private readonly int _maxBatchSize;
        // @deprecated removed in next updates
        private readonly int _meshCount;

        protected int _renderType = 1;

        protected Material _defaultMaterial;
        protected IGNativeUnityFilter _lastFilter;
        protected MonoBehaviour _wrapper;
        protected List<Mesh> _meshes;
        
        protected Vector3[] _vertices;
        protected Vector2[] _uvs;
        protected int[] _quadIndices;
        protected int[] _polyIndices;
        protected Color[] _colors;
        
        protected int _currentBatchIndex = 0;
        protected int _quadIndex = 0;
        protected int _polyIndex = 0;

        protected Texture _lastTexture;
        protected Material _lastMaterialPass;
        protected BlendMode _lastSrcBlendMode;
        protected BlendMode _lastDstBlendMode;

        protected Action _onRenderCallback;

        public GNativeUnityContext(MonoBehaviour p_wrapper, Action p_onRenderCallback, int p_maxBatchSize, int p_meshCount)
        {
            _maxBatchSize = p_maxBatchSize;
            _meshCount = p_meshCount;

            _wrapper = p_wrapper;
            _meshes = new List<Mesh>();

            _vertices = new Vector3[4 * _maxBatchSize];
            _uvs = new Vector2[4 * _maxBatchSize];
            _quadIndices = new int[6 * _maxBatchSize];
            _polyIndices = new int[6 * _maxBatchSize];
            _colors = new Color[4 * _maxBatchSize];
            for (int i = 0; i < _maxBatchSize; i++)
            {
                _vertices[i * 4] = new Vector3(0, 1, 0);
                _vertices[i * 4 + 1] = new Vector3(0, 0, 0);
                _vertices[i * 4 + 2] = new Vector3(1, 0, 0);
                _vertices[i * 4 + 3] = new Vector3(1, 1, 0);
                
                _uvs[i * 4] = new Vector2(0, 1);
                _uvs[i * 4 + 1] = new Vector2(0, 0);
                _uvs[i * 4 + 2] = new Vector2(1, 0);
                _uvs[i * 4 + 3] = new Vector2(1, 1);
                
                _quadIndices[i * 6] = i * 4;
                _quadIndices[i * 6 + 1] = i * 4 + 1;
                _quadIndices[i * 6 + 2] = i * 4 + 2;

                _quadIndices[i * 6 + 3] = i * 4;
                _quadIndices[i * 6 + 4] = i * 4 + 2;
                _quadIndices[i * 6 + 5] = i * 4 + 3;

                _colors[i * 4] = new Color32(1, 1, 1, 1);
                _colors[i * 4 + 1] = new Color32(1, 1, 1, 1);
                _colors[i * 4 + 2] = new Color32(1, 1, 1, 1);
                _colors[i * 4 + 3] = new Color32(1, 1, 1, 1);
            }
            
            for (int mi = 0; mi < _meshCount ; mi++)
            {
                Mesh mesh = new Mesh();
                mesh.MarkDynamic();

                _meshes.Add(mesh);
            }
            
            _defaultMaterial = new Material(Shader.Find("Genome2D/UnlitShader"));
            _defaultMaterial.SetInt("BlendSrcMode", (int)BlendMode.SrcAlpha);
            _defaultMaterial.SetInt("BlendDstMode", (int)BlendMode.OneMinusSrcAlpha);

            _wrapper.gameObject.AddComponent<AudioListener>();

            /* URP preparation
            if (p_onRenderCallback != null) {
                _onRenderCallback = p_onRenderCallback;
                RenderPipelineManager.beginFrameRendering += OnRender;
            }
            /* */
        }
        /*
        public void OnRender(ScriptableRenderContext p_context, Camera[] p_cameras) {
            _onRenderCallback();
        }
        /* */
        public void Begin()
        {
            _lastMaterialPass = null;
            _currentBatchIndex = 0;
        }

        public void Draw(Texture p_texture, BlendMode p_srcBlendMode, BlendMode p_dstBlendMode, float p_x, float p_y, float p_scaleX, float p_scaleY,
            float p_rotation, float p_red, float p_green, float p_blue, float p_alpha, float p_u, float p_v, float p_uScale,
            float p_vScale, float p_textureWidth, float p_textureHeight, float p_texturePivotX, float p_texturePivotY, IGNativeUnityFilter p_filter)
        {
            if (!Object.ReferenceEquals(_lastTexture, p_texture) || p_srcBlendMode != _lastSrcBlendMode || p_dstBlendMode != _lastDstBlendMode || _renderType != 1 || _lastFilter != p_filter)
            {
                if (_lastTexture) FlushRenderer();
                Material material = (p_filter == null) ? _defaultMaterial : p_filter.getMaterial();
                _lastFilter = p_filter;
                if (_lastFilter != null) _lastFilter.bind();
                material.mainTexture = p_texture;
                //material.SetTexture("_MainTex", p_texture);
                _lastTexture = p_texture;
                material.SetInt("BlendSrcMode", (int)p_srcBlendMode);
                material.SetInt("BlendDstMode", (int)p_dstBlendMode);
                _lastSrcBlendMode = p_srcBlendMode;
                _lastDstBlendMode = p_dstBlendMode;
                
                _renderType = 1;
            }

            float tx;
            float rtx;
            float ty;
            float rty;
            float cos = 1;
            float sin = 0;
            int vertexIndex = _quadIndex * 4;

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

            _vertices[vertexIndex].x = p_x + tx;
            _vertices[vertexIndex].y = p_y + ty;
            
            _uvs[vertexIndex].x = p_u;
            _uvs[vertexIndex].y = 1 - p_v;
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;

            tx = p_scaleX * (-p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }

            vertexIndex++;
            _vertices[vertexIndex].x = p_x + tx;
            _vertices[vertexIndex].y = p_y + ty;
            
            _uvs[vertexIndex].x = p_u;
            _uvs[vertexIndex].y = 1 - (p_v + p_vScale);
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;

            tx = p_scaleX * (p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }

            vertexIndex++;
            _vertices[vertexIndex].x = p_x + tx;
            _vertices[vertexIndex].y = p_y + ty;
            
            _uvs[vertexIndex].x = p_u + p_uScale;
            _uvs[vertexIndex].y = 1 - (p_v + p_vScale);
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;

            tx = p_scaleX * (p_textureWidth / 2 - p_texturePivotX);
            ty = p_scaleY * (-p_textureHeight / 2 - p_texturePivotY);
            
            if (p_rotation != 0)
            {
                rtx = cos * tx - sin * ty;
                rty = sin * tx + cos * ty;
                tx = rtx;
                ty = rty;
            }

            vertexIndex++;
            _vertices[vertexIndex].x = p_x + tx;
            _vertices[vertexIndex].y = p_y + ty;

            _uvs[vertexIndex].x = p_u + p_uScale;
            _uvs[vertexIndex].y = 1 - p_v;
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;

            _quadIndex++;
            
            if (_quadIndex >= _maxBatchSize) FlushRenderer();
        }
        
        public void DrawMatrix(Texture p_texture, BlendMode p_srcBlendMode, BlendMode p_dstBlendMode, GMatrix p_matrix,
            float p_red, float p_green, float p_blue, float p_alpha, float p_u, float p_v, float p_uScale,float p_vScale,
            float p_textureWidth, float p_textureHeight, float p_texturePivotX, float p_texturePivotY, IGNativeUnityFilter p_filter)
        {
            if (!Object.ReferenceEquals(_lastTexture, p_texture) || p_srcBlendMode != _lastSrcBlendMode || p_dstBlendMode != _lastDstBlendMode || _renderType != 1 || _lastFilter != p_filter)
            {
                if (_lastTexture) FlushRenderer();
                Mesh mesh = _meshes[_currentBatchIndex];
                Material material = (p_filter == null) ? _defaultMaterial : p_filter.getMaterial();
                _lastFilter = p_filter;
                if (_lastFilter != null) _lastFilter.bind();
                material.mainTexture = p_texture;
                _lastTexture = p_texture;
                material.SetInt("BlendSrcMode", (int)p_srcBlendMode);
                material.SetInt("BlendDstMode", (int)p_dstBlendMode);
                _lastSrcBlendMode = p_srcBlendMode;
                _lastDstBlendMode = p_dstBlendMode;
                
                _renderType = 1;
            }

            float tx;
            float ty;
            int vertexIndex = _quadIndex * 4;
            
            tx = -p_textureWidth / 2 - p_texturePivotX;
            ty = -p_textureHeight / 2 - p_texturePivotY;

            _vertices[vertexIndex].x = (float) (p_matrix.a * tx + p_matrix.c * ty + p_matrix.tx);
            _vertices[vertexIndex].y = (float) (p_matrix.b * tx + p_matrix.d * ty + p_matrix.ty);
            
            _uvs[vertexIndex].x = p_u;
            _uvs[vertexIndex].y = 1 - p_v;
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;
                      
            tx = -p_textureWidth / 2 - p_texturePivotX;
            ty = p_textureHeight / 2 - p_texturePivotY;

            vertexIndex++;
            _vertices[vertexIndex].x = (float) (p_matrix.a * tx + p_matrix.c * ty + p_matrix.tx);
            _vertices[vertexIndex].y = (float) (p_matrix.b * tx + p_matrix.d * ty + p_matrix.ty);
            
            _uvs[vertexIndex].x = p_u;
            _uvs[vertexIndex].y = 1 - (p_v + p_vScale);
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;
            
            tx = p_textureWidth / 2 - p_texturePivotX;
            ty = p_textureHeight / 2 - p_texturePivotY;

            vertexIndex++;
            _vertices[vertexIndex].x = (float) (p_matrix.a * tx + p_matrix.c * ty + p_matrix.tx);
            _vertices[vertexIndex].y = (float) (p_matrix.b * tx + p_matrix.d * ty + p_matrix.ty);
            
            _uvs[vertexIndex].x = p_u + p_uScale;
            _uvs[vertexIndex].y = 1 - (p_v + p_vScale);
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;
            
            tx = p_textureWidth / 2 - p_texturePivotX;
            ty = -p_textureHeight / 2 - p_texturePivotY;

            vertexIndex++;
            _vertices[vertexIndex].x = (float) (p_matrix.a * tx + p_matrix.c * ty + p_matrix.tx);
            _vertices[vertexIndex].y = (float) (p_matrix.b * tx + p_matrix.d * ty + p_matrix.ty);

            _uvs[vertexIndex].x = p_u + p_uScale;
            _uvs[vertexIndex].y = 1 - p_v;
            
            _colors[vertexIndex].r = p_red;
            _colors[vertexIndex].g = p_green;
            _colors[vertexIndex].b = p_blue;
            _colors[vertexIndex].a = p_alpha;

            _quadIndex++;
            
            if (_quadIndex >= _maxBatchSize) FlushRenderer();
        }

        public void DrawPoly(Texture p_texture, BlendMode p_srcBlendMode, BlendMode p_dstBlendMode, double[] p_vertices, double[] p_uvs,
            float p_x, float p_y, float p_scaleX, float p_scaleY, float p_rotation, float p_red, float p_green, float p_blue, float p_alpha, IGNativeUnityFilter p_filter)
        {
            if (!Object.ReferenceEquals(_lastTexture, p_texture) || p_srcBlendMode != _lastSrcBlendMode || p_dstBlendMode != _lastDstBlendMode || _renderType != 2 || p_vertices.Length/2+_polyIndex > 6 * _maxBatchSize || _lastFilter != p_filter)
            {
                if (_lastTexture) FlushRenderer();
                
                Material material = (p_filter == null) ? _defaultMaterial : p_filter.getMaterial();
                _lastFilter = p_filter;
                if (_lastFilter != null) _lastFilter.bind();
                material.mainTexture = p_texture;
                _lastTexture = p_texture;
                material.SetInt("BlendSrcMode", (int)p_srcBlendMode);
                material.SetInt("BlendDstMode", (int)p_dstBlendMode);
                _lastSrcBlendMode = p_srcBlendMode;
                _lastDstBlendMode = p_dstBlendMode;
                
                _renderType = 2;
            }
            
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

            int length = p_vertices.Length >> 1;
            for (int i = 0; i < length; i++)
            {
                tx = (float) (p_scaleX * p_vertices[i * 2]);
                ty = (float) (p_scaleY * p_vertices[i * 2 + 1]);
            
                if (p_rotation != 0)
                {
                    rtx = cos * tx - sin * ty;
                    rty = sin * tx + cos * ty;
                    tx = rtx;
                    ty = rty;
                }

                _vertices[_polyIndex].x = p_x + tx;
                _vertices[_polyIndex].y = p_y + ty;

                _uvs[_polyIndex].x = (float)p_uvs[i * 2];
                _uvs[_polyIndex].y = 1-(float)p_uvs[i * 2 + 1];
            
                _colors[_polyIndex].r = p_red;
                _colors[_polyIndex].g = p_green;
                _colors[_polyIndex].b = p_blue;
                _colors[_polyIndex].a = p_alpha;

                // Hack for correct winding as the input data are same for all platforms we need to change it here
                if (i % 3 == 0)
                {
                    _polyIndices[_polyIndex] = _polyIndex;
                } else if (i % 3 == 1)
                {
                    _polyIndices[_polyIndex] = _polyIndex+1;
                }
                else
                {
                    _polyIndices[_polyIndex] = _polyIndex-1;
                }

                _polyIndex++;
            }
        }
        /*
        private Dictionary<int, Vector3[]> _vector3Pool = new Dictionary<int, Vector3[]>();

        private Vector3[] getVector3FromPool(int p_size)
        {   
            Vector3[] result;
            
            if (!_vector3Pool.TryGetValue(p_size, out result)) {
                result = new Vector3[p_size];
                _vector3Pool.Add(p_size, result);
            }
            
            return result;
        }
        
        private Dictionary<int, Vector2[]> _vector2Pool = new Dictionary<int, Vector2[]>();

        private Vector2[] getVector2FromPool(int p_size)
        {   
            Vector2[] result;
            
            if (!_vector2Pool.TryGetValue(p_size, out result)) {
                result = new Vector2[p_size];
                _vector2Pool.Add(p_size, result);
            }
            
            return result;
        }
        
        private Dictionary<int, int[]> _intPool = new Dictionary<int, int[]>();

        private int[] getIntFromPool(int p_size)
        {   
            int[] result;
            
            if (!_intPool.TryGetValue(p_size, out result)) {
                result = new int[p_size];
                _intPool.Add(p_size, result);
            }
            
            return result;
        }
        
        private Dictionary<int, Color[]> _colorPool = new Dictionary<int, Color[]>();

        private Color[] getColorFromPool(int p_size)
        {   
            Color[] result;
            
            if (!_colorPool.TryGetValue(p_size, out result)) {
                result = new Color[p_size];
                _colorPool.Add(p_size, result);
            }
            
            return result;
        }
        /* */
        public void FlushRenderer()
        {
            if (_quadIndex > 0 || _polyIndex > 0)
            {
                GNativeStats.drawCalls++;
                
                Mesh mesh = _meshes[_currentBatchIndex];
                mesh.Clear();

                if (_renderType == 1)
                {
                    /*
                    Vector3[] cv = getVector3FromPool(_quadIndex * 4);
                    Array.Copy(_vertices, 0, cv, 0, _quadIndex * 4);
                    mesh.vertices = cv;

                    int[] ci = getIntFromPool(_quadIndex * 6);
                    Array.Copy(_quadIndices, 0, ci, 0, _quadIndex * 6);
                    mesh.triangles = ci;

                    Vector2[] cu = getVector2FromPool(_quadIndex * 4);
                    Array.Copy(_uvs, 0, cu, 0, _quadIndex * 4);
                    mesh.uv = cu;

                    Color[] cc = getColorFromPool(_quadIndex * 4);
                    Array.Copy(_colors, 0, cc, 0, _quadIndex * 4);
                    mesh.colors = cc;
                    /* */
                    mesh.SetVertices(_vertices, 0, _quadIndex * 4);
                    mesh.SetTriangles(_quadIndices, 0, _quadIndex * 6, 0, false, 0);
                    mesh.SetUVs(0, _uvs, 0, _quadIndex * 4);
                    mesh.SetColors(_colors, 0, _quadIndex * 4);
                }
                else
                {
                    /*
                    Vector3[] cv = getVector3FromPool(_polyIndex);
                    Array.Copy(_vertices, 0, cv, 0, _polyIndex);
                    mesh.vertices = cv;

                    int[] ci = getIntFromPool(_polyIndex);
                    Array.Copy(_polyIndices, 0, ci, 0, _polyIndex);
                    mesh.triangles = ci;

                    Vector2[] cu = getVector2FromPool(_polyIndex);
                    Array.Copy(_uvs, 0, cu, 0, _polyIndex);
                    mesh.uv = cu;

                    Color[] cc = getColorFromPool(_polyIndex);
                    Array.Copy(_colors, 0, cc, 0, _polyIndex);
                    mesh.colors = cc;
                    /**/
                    mesh.SetVertices(_vertices, 0, _polyIndex);
                    mesh.SetTriangles(_polyIndices, 0, _polyIndex, 0, false, 0);
                    mesh.SetUVs(0, _uvs, 0, _polyIndex);
                    mesh.SetColors(_colors, 0, _polyIndex);
                }

                Material material = (_lastFilter == null) ? _defaultMaterial : _lastFilter.getMaterial();
                if (true) // _lastMaterialPass != material) Texture change not handled correctly as material is not changing but params are therefore set pass is neede -- sHTiF
                {
                    material.SetPass(0);
                    _lastMaterialPass = material;
                }

                mesh.UploadMeshData(false);
                Graphics.DrawMeshNow(mesh, Vector3.zero, Quaternion.identity);
                
                _quadIndex = 0;
                _polyIndex = 0;
            }

            _currentBatchIndex++;
            if (_currentBatchIndex >= _meshCount) _currentBatchIndex = 0;
            _lastFilter = null;
            _lastTexture = null;
        }
        
        public void SetScissorRect(Camera p_camera, Rect p_rect,float p_x, float p_y, float p_scaleX, float p_scaleY)
        {		
            if ( p_rect.x < 0 )
            {
                p_rect.width += p_rect.x;
                p_rect.x = 0;
            }
		
            if ( p_rect.y < 0 )
            {
                p_rect.height += p_rect.y;
                p_rect.y = 0;
            }
		
            p_rect.width = Mathf.Min( 1 - p_rect.x, p_rect.width );
            p_rect.height = Mathf.Min( 1 - p_rect.y, p_rect.height );			
			 
            p_camera.rect = new Rect (0,0,1,1);
            p_camera.ResetProjectionMatrix ();
            Matrix4x4 m = p_camera.projectionMatrix;
            p_camera.rect = p_rect;
            Matrix4x4 m1 = Matrix4x4.TRS( new Vector3( p_x/Screen.width, p_y/Screen.height, 0 ), Quaternion.identity, new Vector3( p_scaleX, p_scaleY, 1 ) );
            Matrix4x4 m2 = Matrix4x4.TRS (new Vector3 ( ( 1/p_rect.width - 1), ( 1/p_rect.height - 1 ), 0), Quaternion.identity, new Vector3 (1/p_rect.width, 1/p_rect.height, 1));
            Matrix4x4 m3 = Matrix4x4.TRS( new Vector3( -p_rect.x  * 2 / p_rect.width, -p_rect.y * 2 / p_rect.height + p_y/Screen.height, 0 ), Quaternion.identity, Vector3.one);
            p_camera.projectionMatrix = m3 * m2 * m1 * m; 
        }	 
    }
}
