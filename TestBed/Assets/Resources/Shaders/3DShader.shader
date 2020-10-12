// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Genome2D/3DShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightDirection ("Light Direction", Vector) = (1,1,1,1)
		_LightColor ("Light Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (0,0,0,0)
		_TintColor ("Tint Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        ZTest Less
        ZWrite On
        Cull Front
        Blend SrcAlpha OneMinusSrcAlpha
        //Blend [BlendSrcMode] [BlendDstMode]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _LightDirection;
            fixed4 _LightColor;
            fixed4 _AmbientColor;
            fixed4 _TintColor;

            float4 _MainTex_ST;
            float4x4 _CameraMatrix;
            float4x4 _ModelMatrix;
            float4x4 _InvertedMatrix;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(_ModelMatrix, float4(v.vertex.xyz, 1.0));
                o.vertex = mul(_CameraMatrix, float4(o.vertex.xyz, 1.0));
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                o.normal = mul(_InvertedMatrix, v.normal);
                o.normal = normalize(o.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float light = -dot(i.normal, _LightDirection.xyz);
				light = clamp(light, 0.0, 1.0);

				float3 directionColor = col.xyz * light * _LightColor;
				float3 ambientColor = col.xyz * _AmbientColor.xyz;

				col = half4(directionColor + ambientColor, col.w);

                return col * _TintColor;// * i.color;
            }
            ENDCG
        }
    }
}

