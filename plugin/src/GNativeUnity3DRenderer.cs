using System;
using System.Linq;
using UnityEngine;

namespace Genome2DNativePlugin
{
    public class GNativeUnity3DRenderer
    {
        protected Vector3[] _vertices;
        protected Vector3[] _normals;
        protected Vector2[] _uvs;
        protected Color[] _colors;
        protected int[] _indices;

        protected Mesh _mesh;
        protected Material _material;
        
        public GNativeUnity3DRenderer(double[] p_vertices, double[] p_uvs, uint[] p_indices, double[] p_normals)
        {
            int size = p_vertices.Length / 3;
            if (size != p_uvs.Length/2) Debug.LogError("Invalid size of uv array.");
            _vertices = new Vector3[size];
            _uvs = new Vector2[size];
            _normals = new Vector3[size];
            _colors = new Color[size];

            String vertexDebug = "";
            String uvDebug = "";
            String normalDebug = "";
            String indexDebug = "";

            for (int i = 0; i < size; i++)
            {
                _vertices[i] = new Vector3((float)p_vertices[i*3], (float)p_vertices[i*3+1], (float)p_vertices[i*3+2]);
                _uvs[i] = new Vector2((float)p_uvs[i*2], (float)p_uvs[i*2+1]);
                _normals[i] = new Vector3((float) p_normals[i * 3], (float) p_normals[i * 3 + 1],
                    (float) p_normals[i * 3 + 2]);
                _colors[i] = new Color(1, 1, 1, 1);
                vertexDebug += p_vertices[i*3] + "," + p_vertices[i*3+1] + "," + p_vertices[i * 3 + 2] + ", ";
                uvDebug += p_uvs[i * 2] + "," + p_uvs[i * 2 + 1] + ", ";
                normalDebug += p_normals[i * 3] + "," + p_normals[i * 3 + 1] + "," + p_normals[i * 3 + 2] + ", ";
            }

            for (int i = 0; i < p_indices.Length; i++)
            {
                indexDebug += p_indices[i] + ", ";
            }
            
            Debug.Log(vertexDebug);
            Debug.Log(uvDebug);
            Debug.Log(indexDebug);
            Debug.Log(normalDebug);

            _mesh = new Mesh();
            _mesh.MarkDynamic();
            _mesh.vertices = _vertices;
            _mesh.uv = _uvs;
            _mesh.normals = _normals;
            _mesh.triangles = _indices;
            _mesh.colors = _colors;

            _material = new Material(Shader.Find("Genome2D/3DShader"));
        }

        public void Draw(Texture p_texture, Matrix4x4 p_modelMatrix, Matrix4x4 p_cameraMatrix)
        {
            _material.SetMatrix("_CameraMatrix", p_cameraMatrix);
            _material.SetMatrix("_ModelMatrix", p_modelMatrix);
            _material.mainTexture = p_texture;
            
            _material.SetPass(0);
            Graphics.DrawMeshNow(_mesh, new Vector3(0, 0, 0), Quaternion.identity);
        }
    }
}