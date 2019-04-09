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
        public const int MAX_BATCH_SIZE = 10000;

        protected int _renderType = 1;
        
        protected MonoBehaviour _wrapper;
        protected List<Mesh> _meshes;
        
        protected Vector3[] _vertices;
        protected Vector2[] _uvs;
        protected int[] _quadIndices;
        protected int[] _polyIndices;
        protected Color[] _colors;
        
        protected List<Material> _materials;
        protected int _currentBatchIndex = 0;
        protected int _quadIndex = 0;
        protected int _polyIndex = 0;

        protected Texture _lastTexture;
        protected Material _lastMaterialPass;
        protected BlendMode _lastSrcBlendMode;
        protected BlendMode _lastDstBlendMode;

        public GNativeUnityContext(MonoBehaviour p_wrapper)
        {
            _wrapper = p_wrapper;
            _meshes = new List<Mesh>();
            _materials = new List<Material>();

            _vertices = new Vector3[4 * MAX_BATCH_SIZE];
            _uvs = new Vector2[4 * MAX_BATCH_SIZE];
            _quadIndices = new int[6 * MAX_BATCH_SIZE];
            _polyIndices = new int[6 * MAX_BATCH_SIZE];
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
            
            for (int mi = 0; mi < 200; mi++)
            {
                Mesh mesh = new Mesh();
                mesh.MarkDynamic();

                _meshes.Add(mesh);

                Material material = new Material(Shader.Find("Genome2D/UnlitShader"));
                material.SetInt("BlendSrcMode", (int)BlendMode.SrcAlpha);
                material.SetInt("BlendDstMode", (int)BlendMode.OneMinusSrcAlpha);
                _materials.Add(material);
            }
        }

        public void Begin()
        {
            _lastMaterialPass = null;
            _currentBatchIndex = 0;
            _meshes[_currentBatchIndex].Clear();
        }

        public void Draw(Texture p_texture, BlendMode p_srcBlendMode, BlendMode p_dstBlendMode, float p_x, float p_y, float p_scaleX, float p_scaleY,
            float p_rotation, float p_red, float p_green, float p_blue, float p_alpha, float p_u, float p_v, float p_uScale,
            float p_vScale, float p_textureWidth, float p_textureHeight, float p_texturePivotX, float p_texturePivotY)
        {
            if (!Object.ReferenceEquals(_lastTexture, p_texture) || p_srcBlendMode != _lastSrcBlendMode || p_dstBlendMode != _lastDstBlendMode || _renderType != 1)
            {
                if (_lastTexture) FlushRenderer();
                
                Mesh mesh = _meshes[_currentBatchIndex];
                Material material = _materials[_currentBatchIndex];
                material.mainTexture = p_texture;
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
            
            if (_quadIndex >= MAX_BATCH_SIZE) FlushRenderer();
        }
        
        public void DrawMatrix(Texture p_texture, BlendMode p_srcBlendMode, BlendMode p_dstBlendMode, GMatrix p_matrix,
            float p_red, float p_green, float p_blue, float p_alpha, float p_u, float p_v, float p_uScale,float p_vScale,
            float p_textureWidth, float p_textureHeight, float p_texturePivotX, float p_texturePivotY)
        {
            if (!Object.ReferenceEquals(_lastTexture, p_texture) || p_srcBlendMode != _lastSrcBlendMode || p_dstBlendMode != _lastDstBlendMode || _renderType != 1)
            {
                if (_lastTexture) FlushRenderer();
                
                Mesh mesh = _meshes[_currentBatchIndex];
                Material material = _materials[_currentBatchIndex];
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
            
            if (_quadIndex >= MAX_BATCH_SIZE) FlushRenderer();
        }

        public void DrawPoly(Texture p_texture, BlendMode p_srcBlendMode, BlendMode p_dstBlendMode, double[] p_vertices, double[] p_uvs,
            float p_x, float p_y, float p_scaleX, float p_scaleY, float p_rotation, float p_red, float p_green, float p_blue, float p_alpha)
        {
            if (!Object.ReferenceEquals(_lastTexture, p_texture) || p_srcBlendMode != _lastSrcBlendMode || p_dstBlendMode != _lastDstBlendMode || _renderType != 2 || p_vertices.Length/2+_polyIndex > 6 * MAX_BATCH_SIZE)
            {
                if (_lastTexture) FlushRenderer();
                
                Mesh mesh = _meshes[_currentBatchIndex];
                Material material = _materials[_currentBatchIndex];
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

        public void FlushRenderer()
        {
            if (_quadIndex > 0 || _polyIndex > 0)
            {
                GNativeStats.drawCalls++;
                
                Mesh mesh = _meshes[_currentBatchIndex];

                if (_renderType == 1)
                {
                    Vector3[] cv = new Vector3[_quadIndex * 4];
                    Array.Copy(_vertices, 0, cv, 0, _quadIndex * 4);
                    mesh.vertices = cv;

                    int[] ci = new int[_quadIndex * 6];
                    Array.Copy(_quadIndices, 0, ci, 0, _quadIndex * 6);
                    mesh.triangles = ci;

                    Vector2[] cu = new Vector2[_quadIndex * 4];
                    Array.Copy(_uvs, 0, cu, 0, _quadIndex * 4);
                    mesh.uv = cu;

                    Color[] cc = new Color[_quadIndex * 4];
                    Array.Copy(_colors, 0, cc, 0, _quadIndex * 4);
                    mesh.colors = cc;
                }
                else
                {
                    Vector3[] cv = new Vector3[_polyIndex];
                    Array.Copy(_vertices, 0, cv, 0, _polyIndex);
                    mesh.vertices = cv;

                    int[] ci = new int[_polyIndex];
                    Array.Copy(_polyIndices, 0, ci, 0, _polyIndex);
                    mesh.triangles = ci;

                    Vector2[] cu = new Vector2[_polyIndex];
                    Array.Copy(_uvs, 0, cu, 0, _polyIndex);
                    mesh.uv = cu;

                    Color[] cc = new Color[_polyIndex];
                    Array.Copy(_colors, 0, cc, 0, _polyIndex);
                    mesh.colors = cc;
                }

                Material material = _materials[_currentBatchIndex];
                if (_lastMaterialPass != material)
                {
                    material.SetPass(0);
                    _lastMaterialPass = material;
                }

                Graphics.DrawMeshNow(mesh, new Vector3(0, 0, 0), Quaternion.identity);
                
                _quadIndex = 0;
                _polyIndex = 0;
            }

            _currentBatchIndex++;
            _meshes[_currentBatchIndex].Clear();
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