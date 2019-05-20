Shader "Genome2D/DesaturateShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                fixed4 col = tex2D(_MainTex, i.uv) * i.color;
                // 0.22, 0.707, 0.071 Unity luminance function, but we are using Genome2D luminance numbers for parity
                fixed3 lum = dot( col, fixed3(0.3, 0.59, 0.11) );
                return fixed4(lum.r, lum.g, lum.b, col.a);
            }
            ENDCG
        }
    }
}
