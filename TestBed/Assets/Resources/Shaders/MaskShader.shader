Shader "Genome2D/DisplacementShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}        
        _MaskTex ("MaskTexture", 2D) = "white" {}
        _UVRatio("uvRatio", Vector) = (1.0,1.0,0,0)
        _UVS("uvs", Vector) = (0.0,0.0,0.0,0.0)
        BlendSrcMode ("BlendSrcMode", Float) = 0
        BlendDstMode ("BlendDstMode", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
        
        ZWrite Off
        // No reason just for Genome2D other contexts consistency, inverted axes
        Cull Off
        Blend [BlendSrcMode] [BlendDstMode]

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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            
            float4 _UVRatio;
            float4 _UVS;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                v2f offsetCoord = i;
                fixed4 mainCol = tex2D(_MainTex, offsetCoord.uv);
                
                offsetCoord.uv = (offsetCoord.uv - _UVS.zw) * _UVRatio.xy + _UVS.xy;
                
                fixed4 maskCol = tex2D(_MaskTex, offsetCoord.uv);
                return mainCol * maskCol.xxxx;
            }
            ENDCG
        }
    }
}