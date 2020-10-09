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

        public Vector3 lightDirection;
        public Color lightColor;
        public Color ambientColor;
        public Color tintColor;
        
        public GNativeUnity3DRenderer(double[] p_vertices, double[] p_uvs, uint[] p_indices, double[] p_normals)
        {
            lightDirection = Vector3.one;

            _mesh = new Mesh();
            _mesh.MarkDynamic();

            InvalidateGeometry(p_vertices, p_uvs, p_indices, p_normals);

            _material = new Material(Shader.Find("Genome2D/3DShader"));
        }

        public void InvalidateGeometry(double[] p_vertices, double[] p_uvs, uint[] p_indices, double[] p_normals) {
            int size = p_vertices.Length / 3;

            _vertices = new Vector3[size];
            _uvs = new Vector2[size];
            _normals = new Vector3[size];
            _colors = new Color[size];
            _indices = new int[p_indices.Length];

            for (int i = 0; i < size; i++)
            {
                _vertices[i] = new Vector3((float)p_vertices[i * 3], (float)p_vertices[i * 3 + 1], (float)p_vertices[i * 3 + 2]);
                _uvs[i] = new Vector2((float)p_uvs[i * 2], 1-(float)p_uvs[i * 2 + 1]);
                _normals[i] = new Vector3((float)p_normals[i * 3], (float)p_normals[i * 3 + 1], (float)p_normals[i * 3 + 2]);
                _colors[i] = new Color(1, 1, 1, 1);
            }

            // Since we are working with UInt inside Genome2D across platforms we need to convert it to int[] here
            for (int i = 0; i < p_indices.Length; i++)
            {
                _indices[i] = (int)p_indices[i];
            }

            _mesh.vertices = _vertices;
            _mesh.uv = _uvs;
            _mesh.normals = _normals;
            _mesh.triangles = _indices;
            _mesh.colors = _colors;
        }

        public void Draw(Texture p_texture, Matrix4x4 p_modelMatrix, Matrix4x4 p_cameraMatrix)
        {
            _material.SetVector("_LightDirection", lightDirection);
            _material.SetColor("_LightColor", lightColor);
            _material.SetColor("_AmbientColor", ambientColor);
            _material.SetColor("_TintColor", tintColor);
            _material.SetMatrix("_CameraMatrix", p_cameraMatrix);
            _material.SetMatrix("_ModelMatrix", p_modelMatrix);
            _material.SetMatrix("_InvertedMatrix", p_modelMatrix.transpose.inverse);

            _material.mainTexture = p_texture;
            _material.SetPass(0);

            Graphics.DrawMeshNow(_mesh, Vector3.zero, Quaternion.identity);
        }
    }
}