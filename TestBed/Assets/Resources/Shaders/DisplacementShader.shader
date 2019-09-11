Shader "Genome2D/DisplacementShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}        
        _Offset("Offset", Float) = 0.0
        _ScaleX("ScaleX", Float) = 0.1 
        _ScaleY("ScaleY", Float) = 0.1
        _DisplacementMap ("DisplacementTexture", 2D) = "white" {}
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
            
            sampler2D _DisplacementMap;
            float4 _DisplacementMap_ST;
            
            float _Offset;
            float _ScaleX;
            float _ScaleY;

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
                offsetCoord.uv.y = offsetCoord.uv.y + _Offset;
                
                fixed4 colDisp = tex2D(_DisplacementMap, offsetCoord.uv); 
                offsetCoord.uv.x = i.uv.x + colDisp.r * _ScaleX;
                offsetCoord.uv.y = i.uv.y + colDisp.r * _ScaleY;
                
                // sample the texture
                fixed4 col = tex2D(_MainTex, offsetCoord.uv);
                return col * i.color;
            }
            ENDCG
        }
    }
}
